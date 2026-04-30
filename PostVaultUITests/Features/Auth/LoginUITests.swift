import XCTest

final class LoginUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchWithUITestEnvironment()
    }

    func test_loginScreen_displaysEmailPasswordAndSubmit() {
        XCTAssertTrue(app.textFields[XCUIApplication.AccessID.emailField].waitForExistence(timeout: 4))
        XCTAssertTrue(app.secureTextFields[XCUIApplication.AccessID.passwordField].exists)
        XCTAssertTrue(app.buttons[XCUIApplication.AccessID.submitButton].exists)
    }

    func test_submitDisabled_whenFieldsEmpty() {
        XCTAssertTrue(app.textFields[XCUIApplication.AccessID.emailField].waitForExistence(timeout: 4))
        let submit = app.buttons[XCUIApplication.AccessID.submitButton]
        XCTAssertFalse(submit.isEnabled)
    }

    func test_submitDisabled_whenEmailInvalid() {
        XCTAssertTrue(app.textFields[XCUIApplication.AccessID.emailField].waitForExistence(timeout: 4))
        app.textFields[XCUIApplication.AccessID.emailField].tap()
        app.textFields[XCUIApplication.AccessID.emailField].typeText("not-valid-email")
        let submit = app.buttons[XCUIApplication.AccessID.submitButton]
        XCTAssertFalse(submit.isEnabled)
    }

    func test_submitDisabled_whenEmailValidButPasswordEmpty() {
        XCTAssertTrue(app.textFields[XCUIApplication.AccessID.emailField].waitForExistence(timeout: 4))
        app.textFields[XCUIApplication.AccessID.emailField].tap()
        app.textFields[XCUIApplication.AccessID.emailField].typeText("user@example.com")
        let submit = app.buttons[XCUIApplication.AccessID.submitButton]
        XCTAssertFalse(submit.isEnabled)
    }
}
