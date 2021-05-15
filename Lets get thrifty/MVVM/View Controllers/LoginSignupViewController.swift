//
//  LoginSignupViewController.swift
//  Lets get thrifty
//
//  Created by AYUSH on 03/05/21.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn
import CountryPickerView

class LoginSignupViewController: BaseViewController<LoginSignupViewModel> {
    
    enum UIState {
        case Login
        case Signup
    }

    @IBOutlet weak var _googleSignInButton: GIDSignInButton!
    @IBOutlet weak var _loginSignupButton: UIButton!
    @IBOutlet weak var _continueButton: UIButton!
    @IBOutlet weak var _nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var _phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var _emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var _passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var _confirmPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var _selectCountryButton: UIButton!
    
    let countryPicker = CountryPickerView()
    
    @IBOutlet var _textViews: [UIView]!
    
    private var _currentUIState = UIState.Login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        _loginSignupButton.layer.cornerRadius = 20
        _continueButton.layer.cornerRadius = 20
        _loginSignupButton.layer.borderWidth = 0.75
        _continueButton.layer.borderWidth = 0.75
        _loginSignupButton.layer.borderColor = UIColor.black.cgColor
        _continueButton.layer.borderColor = UIColor.black.cgColor
        _selectCountryButton.layer.cornerRadius = 5
        _selectCountryButton.layer.borderWidth = 0.5
        _selectCountryButton.layer.borderColor = UIColor.black.cgColor
        for view in _textViews {
            if view.tag == 1 || view.tag == 3 || view.tag == 5  {
                view.isHidden = true
            }
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 0.75
            view.layer.borderColor = UIColor.black.cgColor
        }
        GIDSignIn.sharedInstance().presentingViewController = self
//        _googleSignInButton.layer.cornerRadius = 15
        //_googleSignInButton.layer.borderWidth = 0.75
        //_googleSignInButton.backgroundColor = .white
//        _googleSignInButton.backgroundColor = .black
        
    }
    @IBAction func loginSignupButtonTapped(_ sender: Any) {
        _currentUIState = _currentUIState == UIState.Login ? UIState.Signup : UIState.Login
        _showLoginSignUp(state: _currentUIState)
    }
    
    @IBAction func _continueTapped(_ sender: UIButton) {
        if _currentUIState == .Login {
            
            self.viewModel.isLoading.accept(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.viewModel.isLoading.accept(false)
            }
            
        } else if _currentUIState == .Signup {
            showAlertError(title: "Error", errorMessage: "user already exists")
            
            
        }
    }
    @IBAction func _countrySelectorTapped(_ sender: UIButton) {
        self.countryPicker.showCountriesList(from: self)
    }
    
    private func _validateTextField() -> Bool {
        
        guard let email = _emailTextField.text, let username = _phoneNumberTextField.text, let name = _nameTextField.text, let password = _passwordTextField.text, let confirmPass = _confirmPasswordTextField.text  else {
            //
            return false
        }
        if name.count == 0 {
            _nameTextField.errorMessage = "Please enter a name"
            return false
        } else {
            _nameTextField.errorMessage = nil
        }
        if !(email.contains("@") && email.contains(".")) {
            _emailTextField.errorMessage = "Enter valid email"
            return false
        } else {
            _emailTextField.errorMessage = nil
        }
        if username.count < 6 {
            _phoneNumberTextField.errorMessage = "Enter a valid phone number"
            return false
        } else {
            _phoneNumberTextField.errorMessage = nil
        }
        if password.count > 6 {
            _passwordTextField.errorMessage = nil
            if password != confirmPass {
                _confirmPasswordTextField.errorMessage = "Passwords dont match"
                return false
            } else {
                _confirmPasswordTextField.errorMessage = nil
            }
        } else {
            _passwordTextField.errorMessage = "Enter a longer password"
            return false
        }
        
        return true
    }
    
    private func _showLoginSignUp(state: UIState) {
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10.0, options: .allowAnimatedContent , animations: {
            
            for view in self._textViews {
                if view.tag == 1 || view.tag == 3 || view.tag == 5  {
                    view.isHidden = state == UIState.Login
                    view.alpha = state == UIState.Login ? 0 : 1
                }
            }
            self._continueButton.setTitle(state == UIState.Login ? "Log in" : "Sign up", for: .normal)
            self._loginSignupButton.setTitle(state == UIState.Login ? "Already registered? Log in" : "Not registered yet? Sign up", for: .normal)
        }, completion: nil)
    }
    

}

extension LoginSignupViewController: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self._selectCountryButton.setTitle(country.phoneCode, for: .normal)
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont(name: "Arial", size: 15)!
    }
    
    
}
