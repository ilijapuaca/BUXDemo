//
//  PriceSerializer.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation

/// Serializer for Price objects.

/// Ideally this would be a protocol so that we could have different implementations for.
/// Since JSON deserialization is already partially handled for us, going with this pretty nonflexible way.
class PriceSerializer {

    // MARK: - Dictionary keys

    private let currencyKey = "currency"
    private let decimalsKey = "decimals"
    private let amountKey = "amount"

    // MARK: - Utility functions

    /// Serializes price into a dictionary.
    ///
    /// - Parameter price: Price to serialize
    /// - Returns: Dictionary containing relevant price data.
    func serialize(_ price: Price) -> [String: Any] {
        assert(false, "Not implemented")
    }

    /// Deserializes data dictionary into a new Price object.
    ///
    /// - Parameter data: Dictionary containing serialized price data
    /// - Returns: Deserialized Price object, nil if data is malformed.
    func deserialize(_ data: [String: Any]) -> Price? {
        guard let currency = data[currencyKey] as? Currency else {
            return nil
        }
        guard let decimals = data[decimalsKey] as? Int else {
            return nil
        }
        guard let amountString = data[amountKey] as? String,
              let amount = Double(amountString) else {
            return nil
        }

        return Price(currency: currency, decimals: decimals, amount: amount)
    }

}
