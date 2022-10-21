//
//  Countries_of_the_WorldUITests.swift
//  Countries of the WorldUITests
//
//  Created by Sabato Francesco Longobardi on 17/10/22.
//

import XCTest

final class Countries_of_the_WorldUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_mainList() throws {
        let app = XCUIApplication()
        app.launch()
        
        let collectionViewsQuery = app.collectionViews
        let angolaButton = collectionViewsQuery.buttons["Angola, 🇦🇴"]
        XCTAssert(angolaButton.waitForExistence(timeout: 10))
        XCTAssert(app.navigationBars["Countries"].buttons["Sort"].waitForExistence(timeout: 10))
        let verticalScrollBar = app.collectionViews.firstMatch
        verticalScrollBar.swipeUp()
        verticalScrollBar.swipeDown()
        app.navigationBars["Countries"].buttons["Sort"].tap()
        XCTAssert(collectionViewsQuery.buttons["AFRICA"].waitForExistence(timeout: 10))
        collectionViewsQuery.buttons["AFRICA"].tap()
        XCTAssert(collectionViewsQuery.buttons["AMERICAS"].waitForExistence(timeout: 10))
        app.navigationBars["Countries"].buttons["Sort"].tap()
        XCTAssert(collectionViewsQuery.buttons["A"].waitForExistence(timeout: 10))
        
    }
    
    func testDetailsScreen() throws {
        let app = XCUIApplication()
        app.launch()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons["Angola, 🇦🇴"].tap()
        
        XCTAssert(app.staticTexts["Languages: Portuguese"].waitForExistence(timeout: 15))
        XCTAssert(app.staticTexts["Capital: Luanda"].waitForExistence(timeout: 15))
        XCTAssert(app.maps.firstMatch.waitForExistence(timeout: 15))
        XCTAssert(app.navigationBars.firstMatch.waitForExistence(timeout: 15))
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
