//
//  PriceRangeSerializer.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation

/// Serializer for PriceRange objects.

/// Ideally this would be a protocol so that we could have different implementations.
/// Since JSON deserialization is already partially handled for us, going with this pretty nonflexible way.
class PriceRangeSerializer {

    // MARK: - Dictionary keys

    private let currencyKey = "currency"
    private let decimalsKey = "decimals"
    private let lowKey = "low"
    private let highKey = "high"

    // MARK: - Utility functions

    /// Serializes price range into a dictionary.
    ///
    /// - Parameter priceRange: Price range to serialize
    /// - Returns: Dictionary containing relevant price range data.
    func serialize(_ priceRange: PriceRange) -> [String: Any] {
        assert(false, "Not implemented")
    }

    /// Deserializes data dictionary into a new PriceRange object.
    ///
    /// - Parameter data: Dictionary containing serialized price range data
    /// - Returns: Deserialized PriceRange object, nil if data is malformed.
    func deserialize(_ data: [String: Any]) -> PriceRange? {
        guard let currency = data[currencyKey] as? Currency else {
            return nil
        }
        guard let decimals = data[decimalsKey] as? Int else {
            return nil
        }
        guard let minString = data[lowKey] as? String,
              let min = Double(minString) else {
            return nil
        }
        guard let maxString = data[highKey] as? String,
              let max = Double(maxString) else {
            return nil
        }

        return PriceRange(currency: currency, decimals: decimals, min: min, max: max)
    }

}
