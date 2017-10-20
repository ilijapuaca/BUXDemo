//
//  Product.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation

/// Representing product category like this for now. Ideally this would be a static type like enum,
/// allowing us to do easy comparison etc. Because that would have a large impact on
/// flexibility, making it a String for now.
typealias ProductCategory = String

/// I've only seen this be OPEN/CLOSED. Leaving it as String as I assume there are other values.
typealias ProductMarketStatus = String

/// Not sure about the possible values for these, leaving it as a String.
typealias ProductTag = String

/// Model class representing a single product.
class Product: CustomDebugStringConvertible {

    // MARK: - Properties

    /// Symbol of the product.
    let symbol: String

    /// Display name of the product.
    let displayName: String

    /// Security ID of the product.
    let securityId: String

    /// Currency in which product price is expressed.
    let quoteCurrency: Currency

    /// Current price for this product.
    let currentPrice: Price

    /// Closing price for this product.
    let closingPrice: Price

    /// Price range (24h?) for this product.
    let dayRange: PriceRange

    /// Year range for this product.
    let yearRange: PriceRange

    /// Category that the product belongs to.
    let category: ProductCategory

    /// Boolean indicating whether product is favorited or not.
    let favorite: Bool

    /// Market status for this product.
    let marketStatus: ProductMarketStatus

    /// An array of tags for this product.
    let tags: [ProductTag]

    // MARK: - CustomDebugStringConvertible implementation

    var debugDescription: String {
        return "\(securityId): \(displayName) (\(symbol)) \(currentPrice)"
    }

    // MARK: - Initialization

    init(symbol: String, displayName: String, securityId: String, quoteCurrency: Currency,
         currentPrice: Price, closingPrice: Price, dayRange: PriceRange, yearRange: PriceRange,
         category: ProductCategory, favorite: Bool, marketStatus: ProductMarketStatus, tags: [ProductTag]) {
        self.symbol = symbol
        self.displayName = displayName
        self.securityId = securityId
        self.quoteCurrency = quoteCurrency
        self.currentPrice = currentPrice
        self.closingPrice = closingPrice
        self.dayRange = dayRange
        self.yearRange = yearRange
        self.category = category
        self.favorite = favorite
        self.marketStatus = marketStatus
        self.tags = tags
    }

}
