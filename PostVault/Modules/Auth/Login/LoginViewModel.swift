import Foundation
import RxRelay
import RxSwift

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewControllerDidAuthenticate(_ controller: LoginViewController)
}


final class LoginViewModel {


    let isSubmitEnabled = BehaviorRelay<Bool>(value: false)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let didLogin = PublishSubject<Void>()


    private let sessionRepository: SessionRepository
    private let rules = FormValidator()
    private let bag = DisposeBag()

    init(sessionRepository: SessionRepository = AppServices.sessionRepository) {
        self.sessionRepository = sessionRepository
    }

   
    func connect(
        email: Observable<String>,
        password: Observable<String>,
        submitTap: Observable<Void>
    ) {
        let emailTrimmed = email.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.distinctUntilChanged()
        let emailAndPassword = Observable.combineLatest(emailTrimmed, password)

        bindSubmitButtonEnabled(from: emailAndPassword)
        bindSubmit(emailAndPassword: emailAndPassword, submitTap: submitTap)
    }

    private func bindSubmitButtonEnabled(from emailAndPassword: Observable<(String, String)>) {
        emailAndPassword
            .map { [rules] email, password in
                rules.isValidEmail(email)
                    && rules.isValidPasswordLength(password, min: AuthPasswordLength.min, max: AuthPasswordLength.max)
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] ok in
                self?.isSubmitEnabled.accept(ok)
            })
            .disposed(by: bag)
    }

    private func bindSubmit(
        emailAndPassword: Observable<(String, String)>,
        submitTap: Observable<Void>
    ) {
        submitTap
            .withLatestFrom(emailAndPassword)
            .filter { [rules] email, password in
                rules.isValidEmail(email)
                    && rules.isValidPasswordLength(password, min: AuthPasswordLength.min, max: AuthPasswordLength.max)
            }
            .subscribe(onNext: { [weak self] email, password in
                self?.signIn(email: email, password: password)
            })
            .disposed(by: bag)
    }

    private func signIn(email: String, password: String) {
        isLoading.accept(true)
        sessionRepository.login(email: email, password: password)
            .subscribe(
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                    self?.didLogin.onNext(())
                },
                onError: { [weak self] _ in
                    self?.isLoading.accept(false)
                }
            )
            .disposed(by: bag)
    }
}
