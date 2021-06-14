//
//  WebserviceManager.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import Foundation


class WebServiceManager: WebServiceManagerInterface {
    
    var callback: ((Bool, Request, ResponseError?, Int?) -> Bool)?
        
    private var _failedByTokenRequests = [RequestBlockInterface]()
    
    /// Flag which describe, the request has been failed with the token expire and now block the pending request
    private var _didFailedFromToken = false
    
    func dispatch(block: RequestBlockInterface) {
     
        let urlString = block.request.api ?? ""
        let request = block.request is MultipartRequest ? _createMultipartRequest(urlString: urlString, multipartRequest: (block.request as! MultipartRequest), block: block) : _createUrlJsonContentRequest(block: block, urlString: urlString)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let httpResponse = (response as? HTTPURLResponse)
           // let httpResponseHeaders = (response as? HTTPURLResponse)?.allHeaderFields
           // CommonHeaderManager.serverHeaders(headers: httpResponseHeaders)
            self._handleHttpResponse(data, error: error, block: block, response: httpResponse)
        }
        task.resume()
    }
    
    private func _commonUrlRequest(urlString: String, block: RequestBlockInterface) -> URLRequest {
        
        let escapedUrlStr = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let newString = escapedUrlStr?.replacingOccurrences(of: "&", with: "%26")

        let url = URL(string: newString ?? urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = block.request.method.rawValue.uppercased()
        // apply headers
        
        urlRequest.allHTTPHeaderFields = block.request.headers
        
        if let token = UserManager.shared.loginToken?.token, urlRequest.allHTTPHeaderFields?["Authorization"] == nil {
            urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
    
    private func _createUrlJsonContentRequest(block: RequestBlockInterface , urlString: String) -> URLRequest {
        
        var urlRequest = _commonUrlRequest(urlString: urlString, block: block)
        
        if block.request.parameters.count > 0 || block.request.codeableParameters != nil {
            if block.request.method == Request.Method.get {
                var urlComponents = URLComponents(string: urlString)!
                let queryItems = block.request.parameters.map { (arg) -> URLQueryItem in
                    let (key, value) = arg
                    return URLQueryItem(name: key, value: String(describing:value))
                }
                urlComponents.queryItems = queryItems
                urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?
                    .replacingOccurrences(of: "+", with: "%2B")
                let oldUrlRequest = urlRequest
                urlRequest = URLRequest(url: urlComponents.url!)
                urlRequest.allHTTPHeaderFields = oldUrlRequest.allHTTPHeaderFields
            } else {
                // add the parameter as body of the request
                do {
                    if let encodeableParameters = block.request.codeableParameters {
                        urlRequest.httpBody = encodeableParameters
                    } else {
                        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: block.request.parameters, options: [.prettyPrinted])
                    }
                } catch {
                    fatalError("Error while encoding url request parameters")
                }
            }
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }
    
    private func _createMultipartRequest(urlString: String, multipartRequest: MultipartRequest, block: RequestBlockInterface) -> URLRequest{
        var urlRequest = _commonUrlRequest(urlString: urlString, block: block)
        urlRequest.addValue(multipartRequest.contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = multipartRequest.multipartBody
        return urlRequest
    }
    
    private func _handleHttpResponse(_ data:Data?,error:Error?, block: RequestBlockInterface, response: HTTPURLResponse?) {
        
        self._logRequest(request: block.request)
        
        if _handleError(error: error, block: block, response: response) {
            // error occured so return
         //  let responseError = ResponseError(statusCode: error?.statusCode, name: "Cannot get Data", message: "No data in response")
            return
        }
        
        _handleData(data: data, block: block, response: response)
    }
    
    private func _handleData(data: Data?, block: RequestBlockInterface,response: HTTPURLResponse?) {
        
        guard let data = data else {
            let error = ResponseError(statusCode: response?.statusCode, name: "Cannot get Data", message: "No data in response")
            block.performErrorCallback(error: error)
            return
        }
        
        if block.request.traceLog {
         appDebugPrint("Response : ", String(data:data, encoding: .utf8) as Any)
         appDebugPrint(WebServiceManager.seperator)
        }
        
        if let error = block.checkIfAnyError(data: data, response: response ) {
            block.performErrorCallback(error: error)
            return
        }
        
        block.performCallback(data: data)
    }
    
    static let seperator = "------------------------------------------------------"
    
    private func _handleError(error: Error?, block: RequestBlockInterface, response: HTTPURLResponse?) -> Bool {
        if let error = error {
            print("ERROR : \(error) \n")
            var responseError = ResponseError(statusCode: nil, name: nil, message: "Something went wrong")
            // Check if internet not working
            if let urlError = error as? URLError, [URLError.notConnectedToInternet, URLError.networkConnectionLost].contains(urlError.code) {
                responseError = ResponseError(statusCode: response?.statusCode, name: "No Internet" , message: "Cannot connnect to internet")
            } else if let timeoutError = error as? URLError, URLError.timedOut == timeoutError.code {
                responseError = ResponseError(statusCode: response?.statusCode, name: "Timeout", message: "Request connection timeout")
            }
            guard let callback = self.callback else {
                block.performErrorCallback(error: responseError)
                return true
            }
            if !callback(true,block.request,responseError, nil) {
                block.performErrorCallback(error: responseError)
            }
            return true
        }
        
        return false
        
    }
    
    private func _logRequest(request: Request) {
        if request.traceLog {
            print(Constants.baseUrl)
            print("___________________________")
            print("Request : \(request)")
        }
    }
}


class Request: CustomStringConvertible {
    private(set) var isDeamon = false
    private var _parameters: [String: Any] = [String: Any]()
    private(set) var codeableParameters: Data?

    var traceLog = true
    var encoding:ParameterEncoding = .default
    var parameters: [String: Any] {
        get {
            return _parameters
        }
        set {
            newValue.enumerated().forEach({ (_, keyvalue) in
                let (key, value) = keyvalue
                _parameters[key] = value
            })
        }
    }
    private var _headers: [String: String] = [String: String]()
    var headers: [String: String] {
        get {
            return _headers
        }
        set {
            newValue.enumerated().forEach({ (_, keyvalue) in
                let (key, value) = keyvalue
                _headers[key] = value
            })
        }
    }

    var tag: Any?
    private(set) var api: String!
    private(set) var method: Method!
    private init() {
        //Not to allocate memory with default constructor
    }

    init(api: String, method: Method = .get) {
        self.api = api
        self.method = method
        
    }
    
    public var description: String {
        var desc = ""
        desc += "Parameters = \(String(describing: self.parameters))"
        desc += "\nHeaders = \(String(describing: self.headers))"
        desc += "\nApi = \(String(describing: self.api))"
        desc += "\nMethod = \(String(describing: self.method))"
        desc += "\nCodableParameters = \(String(describing: String(data:self.codeableParameters ?? Data(), encoding: .utf8)))"
        return desc
    }
    
    func addEncodeableParameters<T: Encodable>(encodeable: T) {
        do {
            self.codeableParameters =  try JSONEncoder().encode(encodeable)
        } catch {
            fatalError("Error while encoding url request parameters")
        }
    }
    deinit {
        print("Request Deinit")
    }
}
extension Request {

    enum Method: String {
        case options
        case get
        case head
        case post
        case put
        case patch
        case delete
        case trace
        case connect
    }
}

protocol RequestBlockInterface {
    var request: Request { get }
    func performCallback(data: Data)
    func performErrorCallback(error: ResponseError)
}

extension RequestBlockInterface {
    func checkIfAnyError(data: Data, response: HTTPURLResponse?) -> ResponseError? {
        if let error = try? JSONDecoder().decode(ErrorEntity.self, from: data), let success = error.success, !success {
            return ResponseError(statusCode: response?.statusCode, name: nil, message: error.error ?? "Error")
        }
        return nil
    }
}

struct ErrorEntity: Decodable {
    let success: Bool?
    let error: String?
}


enum ParameterEncoding {
    case json
    case `default`
}

struct ResponseError: Error, Decodable {
    let statusCode: Int?
    let name: String?
    let message: String
}

protocol WebServiceManagerInterface {
    var callback:((_ completed: Bool, _ request: Request, _ error: ResponseError? , _ httpStatusCode: Int? ) -> Bool)? { get set}
    func dispatch(block: RequestBlockInterface)
}

struct RequestBlock<T: Decodable> : RequestBlockInterface {
    func performErrorCallback(error: ResponseError) {
        DispatchQueue.main.async {
            self.callback(nil, error)
        }
    }
    
    
    typealias Callback = (T?, ResponseError?) -> Void
    let callback: Callback
    let request: Request
    init(request: Request, callback: @escaping Callback) {
        self.request = request
        self.callback = callback
    }
    
    func performCallback(data: Data) {// There is no error can decode object
            if let object = decodeObject(data: data) {
                DispatchQueue.main.async {
                    self.callback(object,nil)
                }
            } else {
                self.performErrorCallback(error: ResponseError(statusCode: nil, name: nil, message: "Invalid data encountered"))
        }
    }
    
    private func decodeObject(data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error while decoding object \(error)")
            return nil
        }
    }

}

class MultipartRequest: Request {
    
    struct ContentBody {
        let data: NSData
        let mimeType: String
        let fileName: String
    }
    
    let boundary: String = {
       return "Boundary-\(UUID().uuidString)"
    }()
    
    var contentType: String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    @available(*, unavailable)
    override var codeableParameters: Data? {
        get {
            return nil
        }
    }
    
    var multipartBody: Data {
        return createDataBody(withParameters: parameters)
    }
    
    private func createDataBody(withParameters params: [String: Any]) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
            for (key, value) in parameters {
                
                if let contentBody = value as? ContentBody {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(contentBody.fileName)\"\(lineBreak)")
                    body.append("Content-Type: \(contentBody.mimeType + lineBreak + lineBreak)")
                    body.append(contentBody.data as Data)
                } else if  let contentBody = value as? [ContentBody]{
                    
                    for content in contentBody {
                        
                        body.append("--\(boundary + lineBreak)")
                        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(content.fileName)\"\(lineBreak)")
                        body.append("Content-Type: \(content.mimeType + lineBreak + lineBreak)")
                        body.append(content.data as Data)
                        body.append("\(key)\(lineBreak)")
                        }

                    
                } else {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                }
                body.append("\(value)\(lineBreak)")
            }
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

func appPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    
    print(items,separator:separator, terminator: terminator)
    
}

func appDebugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    
    debugPrint(items,separator:separator, terminator: terminator)
}
