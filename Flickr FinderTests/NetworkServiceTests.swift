//
//  Flickr_FinderTests.swift
//  Flickr FinderTests
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import XCTest
@testable import Flickr_Finder

class FlickrFinderTests: XCTestCase {

    var networkService: NetworkService?
    
    override func setUp() {
        networkService = NetworkService(network: NetworkSupportNative())
    }

    override func tearDown() {
        networkService = nil
    }
    
    func test_validateSearchRequest() {
        // Ensure the router provides a valid request
        let request = FlickrRouter.searchPhoto(term: "bleacher report", page: 1).request
        XCTAssertNotNil(request, "Search request is nil!")
        
        // Ensure request url is not nil
        let url = request!.url
        XCTAssertNotNil(url, "Unable to get request url")
        
        // Validate url
        XCTAssertTrue(UIApplication.shared.canOpenURL(url!), "Request url not valid. Cannot open")
    }
    
    func test_networkSearchResults() {
        
        // Provide a valid network service
        XCTAssertNotNil(networkService, "Network service nil. Please provide a valid network service!")
        
        let expectation = XCTestExpectation(description: "Get search photos")
        self.measure {
            networkService!.searchPhotos(searchTerm: "bleacher report", page: 1, completionHandler: { (result) in
                
                // Ensure it succeceds
                XCTAssertTrue(result.isSuccess, "Unable to get search photos")
                
                // Ensure has valid result
                XCTAssertNotNil(result.value, "Unable to get search photos value")
                
                // Ensure photos are not empty
                XCTAssertFalse(result.value?.photos?.photo?.isEmpty ?? true, "Photos are empty")
                
                expectation.fulfill()
            })
        }
        
        wait(for: [expectation], timeout: 10000)
    }
    
    func test_networkTrendingResults() {
        
        // Provide a valid network service
        XCTAssertNotNil(networkService, "Network service nil. Please provide a valid network service!")
        
        let expectation = XCTestExpectation(description: "Get trending photos")
        self.measure {
            networkService!.getTrendingPhotos(page: 1, completionHandler: { result in
                // Ensure it succeceds
                XCTAssertTrue(result.isSuccess, "Unable to get trending photos")
                
                // Ensure has valid result
                XCTAssertNotNil(result.value, "Unable to get trending photos value")
                
                // Ensure photos are not empty
                XCTAssertFalse(result.value?.photos?.photo?.isEmpty ?? true, "Photos are empty")
                
                expectation.fulfill()
            })
        }
        
        wait(for: [expectation], timeout: 10000)
    }

}
