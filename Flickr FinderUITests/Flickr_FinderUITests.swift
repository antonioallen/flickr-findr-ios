//
//  Flickr_FinderUITests.swift
//  Flickr FinderUITests
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import XCTest

class FlickrFinderUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_canSearchAndFindPhotos() {
        
        // Launch app
        let app = XCUIApplication()
        
        // Enter text
        let searchTextField = app.searchFields["Search Photos"]
        searchTextField.tap()
        searchTextField.typeText("bleacher report")
        
        // Tap search
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Wait 3 seconds for results to load
        sleep(3)
        
        // Navigate back to home
        app.navigationBars["bleacher report"].buttons["Trending"].tap()
        
    }

}
