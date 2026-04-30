import XCTest

final class PostListUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchWithUITestEnvironment()
    }

    func test_postsTab_showsPostsTableAfterLogin() {
        app.logInForUITest(email: "user@example.com", password: "password12")
        XCTAssertTrue(app.tables[XCUIApplication.AccessID.postsTable].waitForExistence(timeout: 8))
    }

    func test_postsNavigationTitle() {
        app.logInForUITest(email: "user@example.com", password: "password12")
        XCTAssertTrue(app.navigationBars["Posts"].waitForExistence(timeout: 4))
    }
}
