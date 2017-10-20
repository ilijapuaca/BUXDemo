//
//  Price.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation

/// Representing currency like this for now. Ideally this would be a static type like enum,
/// allowing us to do easy conversions etc. Because that would have a large impact on
/// flexibility, making it a String for now.
typealias Currency = String

/// Represents an arbitrary price.
class Price: CustomDebugStringConvertible {

    // MARK: - Properties

    /// Currency in which price is expressed.
    let currency: Currency

    /// Number of decimals for the amount
    /// This is perhaps relevant when doing two-way communication?
    let decimals: Int

    /// Amount in currency relevant for this price.
    var amount: Double

    // MARK: - CustomDebugStringConvertible implementation

    var debugDescription: String {
        return "\(amount) \(currency)"
    }

    // MARK: - Initialization

    init(currency: Currency, decimals: Int, amount: Double) {
        self.currency = currency
        self.decimals = decimals
        self.amount = amount
    }

}

/// Utility extension for easier dealing with multiple Prices.
extension Price {

    /// Classical sum overload that adds two Prices if they are in the same currency, nil otherwise.
    ///
    /// - Parameters:
    ///   - left:  Price to to calculate sum for
    ///   - right: Price to to calculate sum for
    /// - Returns: New Price with currency/decimals left the same and amount equal to sum of left and right.
    static func +(left: Price, right: Price) -> Price? {
        guard left.currency == right.currency else {
            return nil
        }
        return Price(currency: left.currency, decimals: left.decimals, amount: left.amount + right.amount)
    }

    /// Classical difference overload that adds two Prices if they are in the same currency, nil otherwise.
    ///
    /// - Parameters:
    ///   - left:  Price to to calculate difference for
    ///   - right: Price to to calculate difference for
    /// - Returns: New Price with currency/decimals left the same and amount equal to difference of left and right.
    static func -(left: Price, right: Price) -> Price? {
        guard left.currency == right.currency else {
            return nil
        }
        return Price(currency: left.currency, decimals: left.decimals, amount: left.amount - right.amount)
    }

}
