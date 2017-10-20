//
//  ProductSerializer.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation

/// Serializer for Product objects.

/// Ideally this would be a protocol so that we could have different implementations.
/// Since JSON deserialization is already partially handled for us, going with this pretty nonflexible way.
class ProductSerializer {

    // MARK: - "Child" serialier objects

    private lazy var priceSerializer = {
        return PriceSerializer()
    }()
    private lazy var priceRangeSerializer = {
        return PriceRangeSerializer()
    }()

    // MARK: - Dictionary keys

    private let symbolKey = "symbol"
    private let displayNameKey = "displayName"
    private let securityIdKey = "securityId"
    private let quoteCurrencyKey = "quoteCurrency"
    private let currentPriceKey = "currentPrice"
    private let closingPriceKey = "closingPrice"
    private let dayRangeKey = "dayRange"
    private let yearRangeKey = "yearRange"
    private let categoryKey = "category"
    private let favoriteKey = "favorite"
    private let marketStatusKey = "productMarketStatus"
    private let tagsKey = "tags"

    // MARK: - Utility functions

    /// Serializes product into a dictionary.
    ///
    /// - Parameter product: Product to serialize
    /// - Returns: Dictionary containing relevant product data.
    func serialize(_ product: Product) -> [String: Any] {
        assert(false, "Not implemented")
    }

    /// Deserializes data dictionary into a new Product object.
    ///
    /// - Parameter data: Dictionary containing serialized product data
    /// - Returns: Deserialized Product object, nil if data is malformed.
    func deserialize(_ data: [String: Any]) -> Product? {
        guard let symbol = data[symbolKey] as? String else {
            return nil
        }
        guard let displayName = data[displayNameKey] as? String else {
            return nil
        }
        guard let securityId = data[securityIdKey] as? String else {
            return nil
        }
        guard let quoteCurrency = data[quoteCurrencyKey] as? Currency else {
            return nil
        }
        guard let currentPriceData = data[currentPriceKey] as? [String: Any],
              let currentPrice = priceSerializer.deserialize(currentPriceData) else {
            return nil
        }
        guard let closingPriceData = data[closingPriceKey] as? [String: Any],
              let closingPrice = priceSerializer.deserialize(closingPriceData) else {
                return nil
        }
        guard let dayRangeData = data[dayRangeKey] as? [String: Any],
              let dayRange = priceRangeSerializer.deserialize(dayRangeData) else {
                return nil
        }
        guard let yearRangeData = data[yearRangeKey] as? [String: Any],
              let yearRange = priceRangeSerializer.deserialize(yearRangeData) else {
                return nil
        }
        guard let category = data[categoryKey] as? ProductCategory else {
            return nil
        }
        guard let favorite = data[favoriteKey] as? Bool else {
            return nil
        }
        guard let marketStatus = data[marketStatusKey] as? ProductMarketStatus else {
            return nil
        }
        guard let tags = data[tagsKey] as? [ProductTag] else {
            return nil
        }

        return Product(symbol: symbol, displayName: displayName, securityId: securityId, quoteCurrency: quoteCurrency,
                       currentPrice: currentPrice, closingPrice: closingPrice, dayRange: dayRange,
                       yearRange: yearRange, category: category, favorite: favorite,
                       marketStatus: marketStatus, tags: tags)
    }

    /// Utility function that implements batch deserialization.
    ///
    /// - Parameter data: Array of serialized products
    /// - Returns: Array of deserialized Product objects.
    /// - Throws: Throws an error if any of the array elements could not be deserialized properly.
    func deserialize(_ data: [[String: Any]]) -> [Product]? {
        var products = [Product]()
        // Iterate over JSON array
        for serializedProduct in data {
            if let product = deserialize(serializedProduct) {
                products.append(product)
            } else {
                return nil
            }
        }
        
        return products
    }

}
