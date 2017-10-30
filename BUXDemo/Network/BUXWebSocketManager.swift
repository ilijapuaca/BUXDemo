//
//  BUXWebSocketManager.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 20/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation
import Starscream

/// Closure type used to pass price update related data.
typealias ProductPriceUpdateClosure = (Double?, Error?) -> Void

/// These should obviously be more elaborate. In order to simplify things a little bit making it a string.
typealias WebSocketCommand = String

/// Type of known events that we can receive.
///
/// - quote: Quote update event that contains updated price.
enum EventType: String {
    case quote = "trading.quote"
}

/// Utility class that handles web socket communication with BUX backend.
class BUXWebSocketManager {

    // MARK: - Properties

    /// Configuration class containing network parameters.
    private let config: Config

    /// Cache for active sockets
    private var socketCache = [String: WebSocket]()

    // MARK: - Initialization

    /// Designated initializer for this class.
    ///
    /// - Parameter config: Configuration instance out of which relevant parameters will be extracted
    init(config: Config = Config.default) {
        self.config = config
    }

    deinit {
        // Disconnect any remaining active sockets
        for socket in socketCache.values {
            if socket.isConnected {
                socket.disconnect()
            }
        }
    }

    // MARK: - Utility methods

    /// Subscribes to the channel that publishes product price updates.
    ///
    /// - Parameters:
    ///   - product: Product for which to listen for updates
    ///   - handler: Handler for incoming price updates
    func subscribeToPriceUpdates(product: Product, handler: @escaping ProductPriceUpdateClosure) {
        // Not sure whether reusing the same socket for multiple operations is a more optimal approach, research
        let socket = createSocket()
        socket.onConnect = { [weak self] in
            guard let `self` = self else {
                return
            }

            // Add the socket to socket cache
            self.socketCache[product.securityId] = socket

            // Wait for successful connection to be established before subscribing
            socket.write(string: self.subscribeCommand(product: product))
        }

        socket.onDisconnect = { [weak self] error in
            self?.socketCache[product.securityId] = nil

            // TODO: Should we report an error if disconnect was not called by us?
        }

        socket.onText = { text in
            // Response should obviously be parsed elsewhere based on its type.
            // Since we're interested in single type of response I'll leave this as-is
            if let jsonData = text.data(using: .utf8, allowLossyConversion: false),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
               let responseData = jsonObject as? [String: Any] {
                // We want to disregard any other event types
                if let eventType = responseData["t"] as? String, EventType(rawValue: eventType) == .quote,
                   let body = responseData["body"] as? [String: Any],
                   let newPriceString = body["currentPrice"] as? String,
                   let newPrice = Double(newPriceString) {
                    handler(newPrice, nil)
                } else {
                    // TODO: We'd like to have our own Error implementation that would contain appropriate domain/codes
                    // Pass a super generic error back to indicate something went wrong
                    handler(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
                }
            } else {
                // TODO: We'd like to have our own Error implementation that would contain appropriate domain/codes
                // Pass a super generic error back to indicate something went wrong
                handler(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
            }
        }

        socket.connect()
    }

    /// Unsubscribes from appropriate channel based on passed product.
    ///
    /// - Parameter product: Product to unsubscribe from
    func unsubscribeFromPriceUpdates(product: Product) {
        if let socket = socketCache[product.securityId] {
            socket.write(string: unsubscribeCommand(product: product), completion: {
                socket.disconnect()
            })
        }
    }

    /// Utility method for creating a socket that is already set up for communication with backend.
    ///
    /// - Returns: Initialized WebSocket that can be connected to.
    private func createSocket() -> WebSocket {
        var request = URLRequest(url: URL(string: config.buxWebSocketUrl)!)
        request.setValue("Bearer " + config.buxWebSocketToken, forHTTPHeaderField: "Authorization")

        return WebSocket(request: request)
    }


    /// Utility method that returns a command that can be executed in order to subscribe to relevant product.
    ///
    /// - Parameter product: Product that the command subscribes to
    /// - Returns: Command that can be executed in order to subscribe to product
    private func subscribeCommand(product: Product) -> WebSocketCommand {
        return "{\"subscribeTo\": [\"trading.product.\(product.securityId)\"]}"
    }

    /// Utility method that returns a command that can be executed in order to unsubscribe to relevant product.
    ///
    /// - Parameter product: Product that the uncommand subscribes to
    /// - Returns: Command that can be executed in order to unsubscribe from product
    private func unsubscribeCommand(product: Product) -> WebSocketCommand {
        return "{\"unsubscribeFrom\": [\"trading.product.\(product.securityId)\"]}"
    }

}
