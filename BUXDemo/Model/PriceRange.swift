//
//  PriceRange.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation

/// Represents an arbitrary price range.
class PriceRange: CustomDebugStringConvertible {

    // MARK: - Properties

    /// Currency in which price range is expressed.
    let currency: Currency

    /// Number of decimals for min/max. This is perhaps relevant when doing two-way communication?
    let decimals: Int

    // Minimum amount for this price range.
    let min: Double

    // Maximum amount for this price range.
    let max: Double

    // MARK: - CustomDebugStringConvertible implementation

    var debugDescription: String {
        return "\(min) - \(max) \(currency)"
    }

    // MARK: - Initialization

    init(currency: Currency, decimals: Int, min: Double, max: Double) {
        self.currency = currency
        self.decimals = decimals
        self.min = min
        self.max = max
    }

}
