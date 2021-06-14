//
//  LisitngsRepository.swift
//  Lets get thrifty
//
//  Created by AYUSH on 02/06/21.
//

import UIKit

struct LisingsRepository {
    
    private init() {
        // singleton
    }
    
    static let shared = LisingsRepository()
    
    func getMyListings(with manager: WebServiceManagerInterface, callback: @escaping ((GenericPaginationResponse<[Listing]>?, ResponseError?)->())) {
        guard let id = UserManager.shared.user?._id else { return }
        let request = Request(api: APIClient.listings, method: .get)
        let parametrs = [ "user" : id]
        request.parameters = parametrs
        let requestBlock = RequestBlock<GenericPaginationResponse<[Listing]>>(request: request, callback: callback)
        manager.dispatch(block: requestBlock)
        
    }
    
    func postListing(with manager: WebServiceManagerInterface,listingModel: ListingWebModel, callback: @escaping ((Listing?, ResponseError?)->())) {
        
        
        let parameters = ["name": listingModel.name,
                          "description": listingModel.description,
                          "phone": listingModel.phone,
                          "email": listingModel.email,
                          "address": listingModel.address,
                          "price": listingModel.price,
                          "condition": listingModel.condition] as [String : Any]
        let request = Request(api: APIClient.listings, method: .post)
        request.parameters = parameters
        let requestBlock = RequestBlock<Listing>(request: request, callback: callback)
        manager.dispatch(block: requestBlock)
        
    }
    
    func postLingingPictures(with manager: WebServiceManagerInterface, listingiD: String, photos: [UIImage], callback: @escaping (ListingPicturesResponse?,ResponseError?)->()) {
        let request = MultipartRequest(api: APIClient.listingsPhotos(listingId: listingiD), method: .put)
        
        let files = photos.compactMap { image in
            
            return MultipartRequest.ContentBody(data: image.jpegData(compressionQuality: 0.1)! as NSData,
                                                mimeType: "image/jpeg",
                                                fileName: "test\(Int.random(in: 1...40)).jpeg")
        }
        let parameters = ["files" : files]
        
        request.parameters = parameters
        let block = RequestBlock<ListingPicturesResponse>(request: request,callback: callback)
        
        manager.dispatch(block: block)
        
    }
}
