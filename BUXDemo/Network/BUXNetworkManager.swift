//
//  BUXNetworkManager.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Utility block declarations

typealias ProductsFetchClosure = ([Product]?, Error?) -> Void
typealias ProductFetchClosure = (Product?, Error?) -> Void

/// Utility class that deals with BUX specific network requests.
class BUXNetworkManager {

    // MARK: - Properties

    /// Configuration class containing network parameters.
    private let config: Config

    /// Session manager that'll be used for networking operations.
    private lazy var sessionManager: SessionManager = {
        var additionalHeaders = SessionManager.defaultHTTPHeaders
        additionalHeaders["Authorization"] = "Bearer " + config.buxApiToken
        // Do all the requests return json?
        additionalHeaders["Accept"] = "application/json"

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = additionalHeaders

        return SessionManager(configuration: configuration)
    }()

    /// Object that'll be used for serialization/deserialization before network calls.
    private lazy var productSerializer = {
        return ProductSerializer()
    }()

    // MARK: - Initialization

    /// Designated initializer for this class.
    ///
    /// - Parameter config: Configuration instance out of which relevant parameters will be extracted
    init(config: Config = Config.default) {
        self.config = config
    }

    // MARK: - API calls

    /// Fetches the entire product list through endpoint API call.
    ///
    /// - Parameter handler: Closure that should handle product data or a potential error
    /// - Returns: Newly created DataRequest
    func fetchProducts(handler: @escaping ProductsFetchClosure) -> DataRequest {
        let productsURL = config.buxApiUrl + "/products"
        let request = sessionManager.request(productsURL).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                if let serializedProducts = value as? [[String: Any]] {
                   let products = self?.productSerializer.deserialize(serializedProducts)
                    handler(products, nil)
                } else {
                    // TODO: We'd like to have our own Error implementation that would contain appropriate domain/codes
                    // Pass a super generic error back to indicate something went wrong
                    handler(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
                }
            case .failure(let error):
                let nsError = error as NSError

                // If it was us that canceled the request, don't propagate the error
                if nsError.code != NSURLErrorCancelled {
                    // TODO: We'd like to have our own Error implementation that would contain appropriate domain/codes
                    handler(nil, error)
                }
            }
        }

        return request
    }

}

