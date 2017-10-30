//
//  ProductDetailsViewController.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 20/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import UIKit

/// Presents the user with more detailed info for a particular Product.
class ProductDetailsViewController: UIViewController {

    // MARK: - Properties

    /// Product to show the details for.
    var product: Product!

    /// Web socket manager through which we'll receive real-time product updates.
    private var buxWebSocketManager = BUXWebSocketManager()

    /// Formatter we'll be using to format currencies.
    private lazy var currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = product.quoteCurrency
        currencyFormatter.minimumFractionDigits = product.currentPrice.decimals
        currencyFormatter.maximumFractionDigits = product.currentPrice.decimals
        currencyFormatter.minusSign = "- "
        currencyFormatter.plusSign = "+ "

        return currencyFormatter
    }()

    /// Formatter we'll be using to format percent values.
    private let percentFormatter: NumberFormatter = {
        let percentFormatter = NumberFormatter()
        percentFormatter.locale = Locale.current
        percentFormatter.numberStyle = .percent
        percentFormatter.minusSign = "- "
        percentFormatter.plusSign = "+ "
        percentFormatter.minimumFractionDigits = 2
        percentFormatter.maximumFractionDigits = 2

        return percentFormatter
    }()

    // MARK: - Colors
    // TODO: Move these out into theme specific class

    private let successColor = UIColor(red: 76.0 / 255.0, green: 217.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    private let failureColor = UIColor(red: 255.0 / 255.0, green: 59.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)

    // MARK: - Outlets

    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var closingDifferenceLabel: UILabel!
    @IBOutlet weak var dayLowLabel: UILabel!
    @IBOutlet weak var dayHighLabel: UILabel!
    @IBOutlet weak var yearLowLabel: UILabel!
    @IBOutlet weak var yearHighLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        title = product.displayName.uppercased()

        // Update the UI so that it reflects current product state
        updateUI(product)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Subscribe to price update events
        buxWebSocketManager.subscribeToPriceUpdates(product: product) { [weak self] (newPrice, error) in
            guard let newPrice = newPrice else {
                // Since these come in super often, presenting user with an error wouldn't make much sense
                return
            }

            // Update the UI with new price data
            self?.updateCurrentPrice(newPrice)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Unsubscribe from price update events
        buxWebSocketManager.unsubscribeFromPriceUpdates(product: product)
    }

    // MARK: - Utility methods

    /// Updates the interface so that it reflects current product data.
    ///
    /// - Parameter product: Product to show the data for
    private func updateUI(_ product: Product) {
        currentPriceLabel.text = currencyFormatter.string(from: product.currentPrice.amount as NSNumber)

        updateClosingDifference()

        dayLowLabel.text = currencyFormatter.string(from: product.dayRange.min as NSNumber)
        dayHighLabel.text = currencyFormatter.string(from: product.dayRange.max as NSNumber)

        yearLowLabel.text = currencyFormatter.string(from: product.yearRange.min as NSNumber)
        yearHighLabel.text = currencyFormatter.string(from: product.yearRange.max as NSNumber)

        // TODO: Localize these if I get a final list of values
        statusLabel.text = product.marketStatus
        categoryLabel.text = product.category
    }

    /// Updates current price based on new amount.
    ///
    /// - Parameter amount: New amount for current price of the product
    private func updateCurrentPrice(_ amount: Double) {
//        let oldAmount = product.currentPrice.amount
        // Set the new amount for the current price
        product.currentPrice.amount = amount

        currentPriceLabel.text = currencyFormatter.string(from: amount as NSNumber)

        // The updates are coming in way too frequently for this to look any good,
        // commenting it out in case I implement some kind of throttling
        /*
        let flashColor = oldAmount > amount ? failureColor : successColor
        let originalColor = currentPriceLabel.backgroundColor
        UIView.animate(withDuration: 1.0, animations: {
            self.currentPriceLabel.backgroundColor = flashColor
        }) { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.currentPriceLabel.backgroundColor = originalColor
            })
        }
         */

        // Update closing difference as it is also effected by this change
        updateClosingDifference()
    }

    /// Updates the interface so that is shows the correct difference between the current price and the closing price.
    private func updateClosingDifference() {
        // Empty out the label in case we formatting fails
        closingDifferenceLabel.text = nil

        let closingDifference = (product.currentPrice - product.closingPrice)?.amount ?? 0.0
        let closingDifferenceInPercents = closingDifference / product.closingPrice.amount
        if let closingDiffString = currencyFormatter.string(from: closingDifference as NSNumber),
            let closingDiffPercentString = percentFormatter.string(from: closingDifferenceInPercents as NSNumber) {
            let finalString = String(format: "%@ (%@)", closingDiffString, closingDiffPercentString)
            closingDifferenceLabel.text = finalString

            // Provide visual feedback based on growth trend
            closingDifferenceLabel.textColor = closingDifference > 0 ? successColor : failureColor
        }
    }

}
