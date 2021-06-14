//
//  AddYourAddressViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 31/05/21.
//

import UIKit
import CountryPickerView

class AddYourAddressViewController: BaseViewController<AddYourAddressViewModel> {

    @IBOutlet weak var _streetTextField: UITextField!
    @IBOutlet weak var _cityTextField: UITextField!
    @IBOutlet weak var _stateTextField: UITextField!
    @IBOutlet weak var _countryTextField: UITextField!
    @IBOutlet weak var _emailTextField: UITextField!
    @IBOutlet weak var _phoneTextField: UITextField!
    @IBOutlet weak var _countryCodeButton: UIButton!
    
    let countryPicker = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPicker.delegate = self
        _countryCodeButton.setTitle(viewModel.selectedCountryCode, for: .normal)
        _bindViewModel()

    }
    
    @IBAction func _countryCodeButtonTapped(_ sender: Any) {
        self.countryPicker.showCountriesList(from: self)
    }
    
    @IBAction func _addButtonPressed(_ sender: Any) {
        if validate() {
            guard let street = _streetTextField.text,
                  let city = _cityTextField.text,
                  let state = _stateTextField.text,
                  let country = _countryTextField.text,
                  let email = _emailTextField.text,
                  let phone =  _phoneTextField.text
            else {
                showError("Something went wrong, please try again")
                return
            }
            let phoneNumber = viewModel.selectedCountryCode + phone
            let listing = ListingContactModel(street: street, city: city, state: state, country: country, email: email, phone: phoneNumber)
            viewModel.postListing(contact: listing)
        }
    }
    @IBAction func _backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validate() -> Bool {
        guard let street = _streetTextField.text,
              let city = _cityTextField.text,
              let state = _stateTextField.text,
              let country = _countryTextField.text,
              let email = _emailTextField.text,
              let phone = _phoneTextField.text
        else {
            showError("Something went wrong, please try again")
            return false
        }
        if street.isEmpty || city.isEmpty || state.isEmpty || country.isEmpty || email.isEmpty || phone.isEmpty {
            showError("please enter all the fields")
            return false
        }
        
        if let error = viewModel.checkEmailValidity(email: email) {
            showError(error)
            return false
        }
        
        if phone.count < 6 {
            showError("Please enter a valid phone number")
            return false
        }
        return true
    }
    
    
    private func _bindViewModel() {
        self.viewModel.didUpload.skip(1).bind { [weak self] listing in
            guard let listing = listing else { return }
            self?.showAlertSuccess(title: "Success!!",
                                   message: "Your listing is uploaded successfully",dismiss: 5) {
                guard let navController = (self?.navigationController as? AddListingNavigationController) else {
                    self?.showError("Error dismission controller")
                    return
                }
                self?.navigationController?.dismiss(animated: true,
                                                    completion: {
                    navController.listingDelegate?.didAddNewListing(listing: listing)
                })
                
            }
        }
        
    }

}

extension AddYourAddressViewController: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self._countryCodeButton.setTitle(country.phoneCode, for: .normal)
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont(name: "Arial", size: 15)!
    }
}

extension AddYourAddressViewController {
    struct Builder {
        static func build(viewModel: AddYourAddressViewModel) -> AddYourAddressViewController {
          let storyBoard = UIStoryboard.init(name: "Sell", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: AddYourAddressViewController.identifier) as! AddYourAddressViewController
            vc.viewModel = viewModel
            return vc
            
        }
    }
}
