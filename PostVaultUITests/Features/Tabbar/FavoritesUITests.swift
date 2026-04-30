import XCTest

final class FavoritesUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchWithUITestEnvironment()
    }

    func test_favoritesTab_showsFavoritesTableAfterLogin() {
        app.logInForUITest(email: "user@example.com", password: "password12")
        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.tables[XCUIApplication.AccessID.favoritesTable].waitForExistence(timeout: 6))
    }

    func test_favoritesScreen_showsEmptyStateOrCells() {
        app.logInForUITest(email: "user@example.com", password: "password12")
        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.tables[XCUIApplication.AccessID.favoritesTable].waitForExistence(timeout: 6))

        let table = app.tables[XCUIApplication.AccessID.favoritesTable]
        let hasRows = table.cells.count > 0
        let emptyVisible = app.otherElements[XCUIApplication.AccessID.favoritesEmpty].exists
            || app.staticTexts.matching(identifier: XCUIApplication.AccessID.favoritesEmpty).firstMatch.exists
        XCTAssertTrue(hasRows || emptyVisible, "Favorites should either list rows or show the empty state.")
    }

    func test_favoritesNavigationTitle() {
        app.logInForUITest(email: "user@example.com", password: "password12")
        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.navigationBars["Favorites"].waitForExistence(timeout: 4))
    }
}
