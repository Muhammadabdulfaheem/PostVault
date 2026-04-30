import UIKit
import RxCocoa
import RxSwift


final class LoginViewController: UIViewController {

    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var btnPasswordVisibilty: UIButton!
    @IBOutlet private var loader: UIActivityIndicatorView!

  
    private let viewModel = LoginViewModel()
    private weak var flowDelegate: LoginViewControllerDelegate?
    private let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibilityIdentifiers()
        setupEmailField()
        setupPasswordField()
        setupSubmitButton()
        setupPasswordToggle()
        bindViewModel()
    }


    func configure(flowDelegate: LoginViewControllerDelegate) {
        self.flowDelegate = flowDelegate
    }
}



private extension LoginViewController {
    
    func setupAccessibilityIdentifiers() {
          emailField.accessibilityIdentifier = LoginAccessibility.ID.emailField
          passwordField.accessibilityIdentifier = LoginAccessibility.ID.passwordField
          submitButton.accessibilityIdentifier  = LoginAccessibility.ID.submitButton
          loader.accessibilityIdentifier = LoginAccessibility.ID.loader
      }

      func setupEmailField() {
          applyFieldAppearance(emailField)
          applyPadding(emailField, left: 12, right: 12)
          emailField.keyboardType           = .emailAddress
          emailField.textContentType        = .username
          emailField.returnKeyType          = .next
          emailField.autocapitalizationType = .none
          emailField.autocorrectionType     = .no
          emailField.delegate               = self
      }

      func setupPasswordField() {
          applyFieldAppearance(passwordField)
          applyPadding(passwordField, left: 12, right: 48)
          passwordField.isSecureTextEntry    = true
          passwordField.textContentType      = .password
          passwordField.returnKeyType        = .done
          passwordField.autocapitalizationType = .none
          passwordField.autocorrectionType   = .no
          passwordField.delegate             = self
          passwordField.superview?.backgroundColor = .clear
          refreshEyeIcon()
      }

      func setupSubmitButton() {
          submitButton.isEnabled = false
          applySubmitStyle(validationComplete: false)
      }

      func setupPasswordToggle() {
          btnPasswordVisibilty.rx.tap
              .subscribe(onNext: { [weak self] in
                  self?.togglePasswordVisibility()
              })
              .disposed(by: disposeBag)
      }

      func applyFieldAppearance(_ field: UITextField) {
          field.borderStyle      = .none
          field.backgroundColor  = .clear
          field.clipsToBounds    = true
          field.layer.cornerRadius = 12
          field.layer.borderWidth  = 1
          applyBorder(field)
      }

      func applyPadding(_ field: UITextField, left: CGFloat, right: CGFloat) {
          field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: 0))
          field.leftViewMode = .always
          field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: 0))
          field.rightViewMode = .always
      }

    func applyBorder(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.separator
            .resolvedColor(with: textField.traitCollection)
            .cgColor
    }

    func applySubmitStyle(validationComplete: Bool) {
        var config = UIButton.Configuration.filled()
        config.title = submitButton.configuration?.title ?? submitButton.title(for: .normal) ?? "Submit"
        if validationComplete {
            config.baseBackgroundColor = AppColor.primaryButton.color
            config.baseForegroundColor = .white
        } else {
            config.baseBackgroundColor = AppColor.backgroundDisabled.color
            config.baseForegroundColor = AppColor.disabledText.color
        }
        config.cornerStyle = .large
        submitButton.backgroundColor = .clear
        submitButton.configuration = config
    }

    func togglePasswordVisibility() {
        let t = passwordField.text
        passwordField.isSecureTextEntry.toggle()
        passwordField.text = t
        refreshEyeIcon()
    }

    func refreshEyeIcon() {
        let name = passwordField.isSecureTextEntry ? "eye" : "eye.slash"
        let img = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        btnPasswordVisibilty.setImage(img, for: .normal)
    }
}


private extension LoginViewController {

    func bindViewModel() {
        connectInputs()
        bindSubmitButton()
        bindLoading()
        bindLoginSucceeded()
    }

    func connectInputs() {
        viewModel.connect(
            email: emailField.rx.text.orEmpty.asObservable(),
            password: passwordField.rx.text.orEmpty.asObservable(),
            submitTap: submitButton.rx.tap
                .do(onNext: { [weak self] in self?.view.endEditing(true) })
                .asObservable()
        )
    }

   
    func bindSubmitButton() {
        Driver.combineLatest(viewModel.isSubmitEnabled.asDriver(), viewModel.isLoading.asDriver())
            .drive(onNext: { [weak self] valid, busy in
                guard let self else { return }
                self.submitButton.isEnabled = valid && !busy
                self.applySubmitStyle(validationComplete: valid)
            })
            .disposed(by: disposeBag)
    }

    func bindLoading() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                guard let self else { return }
                if loading {
                    self.loader.startAnimating()
                } else {
                    self.loader.stopAnimating()
                }
                self.view.isUserInteractionEnabled = !loading
            })
            .disposed(by: disposeBag)
    }

    func bindLoginSucceeded() {
        viewModel.didLogin
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.flowDelegate?.loginViewControllerDidAuthenticate(self)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === passwordField else { return true }
        let current = textField.text ?? ""
        guard let r = Range(range, in: current) else { return false }
        return current.replacingCharacters(in: r, with: string).count <= AuthPasswordLength.max
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
