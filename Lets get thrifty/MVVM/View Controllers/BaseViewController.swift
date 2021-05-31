//
//  BaseViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 14/05/21.
//

import UIKit
import RxSwift

class BaseViewController <GenericViewModel: BaseViewModel>: UIViewController {
    
    
    var viewModel: GenericViewModel!
    private(set) var disposableBag = DisposeBag()
    private weak var loader: Loader?
    
    var canShowLoader: Bool {
        return true
    }
    
    var canShowNoInternetConnectionView: Bool {
        return true
    }
    var loaderInsets: UIEdgeInsets {
        return .zero
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._setupViewModelIfCan()
        self._setupViewModelObserving()
        self.viewModel?.loaded()
        self.addLoaderIfCan()
    }
    
    private func _setupViewModelIfCan() {
        if viewModel != nil {
            return
        }
        viewModel = GenericViewModel.init(webServiceMangerInterface: WebServiceManager())
    }
    
    
    private func _setupViewModelObserving() {
        viewModel.isLoading.subscribe { [weak self] _ in
            self?._performOnLoadingActions()
        }.disposed(by: disposableBag)
        
        viewModel.generalErrors.subscribe { [weak self] (event) in
            guard let error = event.element! else { return }
            self?.showError(error.message)
        }.disposed(by: disposableBag)
    }
    
    func showLoader(_ show: Bool) {
        // use to show the generic loader
        if canShowLoader && show {
            self.addLoaderIfCan()
        }
        if show {
            self.loader?.isHidden = !show
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.loader?.alpha = show ?  1 : 0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.loader?.is_Hidden = !show
            self.loader?.isHidden = !show
        })
       
        
    }
    
    func showError(_ error: String?) {
        showLoader(false)
        if error != nil {
            self.showAlertError(title: "Error", errorMessage: error ?? "Something went wrong")
        }
    }
    
    func _performOnLoadingActions() {
        self.view.endEditing(true)
        self.showLoader(viewModel.isLoading.value)
    }
    
    private func addLoaderIfCan() {
        // loader already created
        if loader != nil {
            return
        }
        let loader = Loader(frame: CGRect.zero)
        loader.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loader)
        NSLayoutConstraint.activate(
            [loader.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: loaderInsets.left),
             loader.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: loaderInsets.right),
             loader.topAnchor.constraint(equalTo: self.view.topAnchor, constant: loaderInsets.top),
             loader.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: loaderInsets.bottom)])
        self.loader = loader
        self.view.updateConstraintsIfNeeded()
        self.loader?.isHidden = true
        self.loader?.alpha = 0
    }

}

extension UIViewController{
    func showAlertError(title:String ,errorMessage: String) {
        let vc = UIStoryboard.init(name: "Others", bundle: nil).instantiateViewController(identifier: "AlertViewController") as! AlertViewController
        vc.alertType = .Error
        vc.showSecondButton = false
        vc.alertTitle = title
        vc.message = errorMessage
        self.present(vc, animated: true, completion: nil)
    }
}
