//
//  PriceTests.swift
//  BUXDemoTests
//
//  Created by Ilija Puaca on 20/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import XCTest
@testable import BUXDemo

class PriceTests: XCTestCase {

    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Tests

    func testAddition() {
        let firstPrice = Price(currency: "EUR", decimals: 2, amount: 13.37)
        let secondPrice = Price(currency: "EUR", decimals: 3, amount: 22.666)

        let priceSum = firstPrice + secondPrice
        XCTAssertNotNil(priceSum, "Adding two prices with same currency should not return nil")
        XCTAssertEqual(priceSum!.amount, 36.036, accuracy: 10e-5, "Price sum not valid")

        let thirdPrice = Price(currency: "USD", decimals: 2, amount: 73.31)
        XCTAssertNil(firstPrice + thirdPrice, "Adding two prices that don't have the same currency should return nil")
    }

    func testSubtraction() {
        let firstPrice = Price(currency: "EUR", decimals: 3, amount: 36.036)
        let secondPrice = Price(currency: "EUR", decimals: 3, amount: 22.666)

        let priceDifference = firstPrice - secondPrice
        XCTAssertNotNil(priceDifference, "Subtracting two prices with same currency should not return nil")
        XCTAssertEqual(priceDifference!.amount, 13.37, accuracy: 10e-5, "Price difference not valid")

        let thirdPrice = Price(currency: "USD", decimals: 2, amount: 73.31)
        XCTAssertNil(firstPrice - thirdPrice, "Subtracting two prices that don't have the same currency should return nil")
    }
        
}
