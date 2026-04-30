import XCTest

extension XCUIApplication {

    enum AccessID {
        static let emailField = "login.emailField"
        static let passwordField = "login.passwordField"
        static let submitButton = "login.submitButton"
        static let postsTable = "posts.table"
        static let favoritesTable = "favorites.table"
        static let favoritesEmpty = "favorites.emptyState"
    }

    func launchWithUITestEnvironment() {
        launchEnvironment["UITEST"] = "1"
        launch()
    }

    /// Logs in without requiring the **software** keyboard. Simulator often hides it when
    /// **I/O → Keyboard → Connect Hardware Keyboard** is on; `keyboards` queries then fail even though
    /// `typeText` still works. Physical devices usually show the software keyboard, so both paths are covered.
    func logInForUITest(email: String, password: String, file: StaticString = #file, line: UInt = #line) {
        XCUIDevice.shared.orientation = .portrait

        let emailField = textFields[AccessID.emailField]
        XCTAssertTrue(emailField.waitForExistence(timeout: 10), file: file, line: line)

        emailField.tap()
        emailField.typeText(email)

        let passwordField = secureTextFields[AccessID.passwordField]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 4), file: file, line: line)

        // Move to password by tapping the field (no “Next” / Return on the on-screen keyboard).
        tapForFirstResponder(passwordField)

        passwordField.typeText(password)

        buttons[AccessID.submitButton].tap()
        XCTAssertTrue(tabBars.firstMatch.waitForExistence(timeout: 20), "Expected home UI after login.", file: file, line: line)
    }

    private func tapForFirstResponder(_ element: XCUIElement) {
        if element.isHittable {
            element.tap()
        } else {
            element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }
}
