//
//  ProductCellCollectionViewCell.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import UIKit

/// UICollectionViewCell subclass used to present basic Product information.
class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    /// Formatter we'll be using to format currencies.
    /*
    private let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency

        return currencyFormatter
    }()
     */

    /// Formatter we'll be using to format percent values.
    private let percentFormatter: NumberFormatter = {
        let percentFormatter = NumberFormatter()
        percentFormatter.locale = Locale.current
        percentFormatter.numberStyle = .percent
        percentFormatter.negativePrefix = "- "
        percentFormatter.positivePrefix = "+ "
        percentFormatter.minimumFractionDigits = 2
        percentFormatter.maximumFractionDigits = 2

        return percentFormatter
    }()

    // MARK: - Outlets

    @IBOutlet weak var roundView: UIView! {
        didSet {
            roundView.layer.masksToBounds = true
            roundView.layer.borderWidth = 1.0
            roundView.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCurrentPriceLabel: UILabel!
    @IBOutlet weak var productDayChangeLabel: UILabel!

    // MARK: - Initialization

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update cornerRadius as the view gets resized to make sure it stays round
        roundView.layer.cornerRadius = roundView.bounds.size.height / 2.0
    }

    // MARK: - Utility methods

    /// Visually highlights the cell.
    func highlight() {
        UIView.animate(withDuration: 0.1) {
            self.overlayView.backgroundColor = UIColor.lightGray
        }
    }

    /// Visually unhighlights the cell.
    func unhighlight() {
        UIView.animate(withDuration: 0.1) {
            self.overlayView.backgroundColor = UIColor.clear
        }
    }

    /// Utility method that populates the cell UI based on product.
    ///
    /// - Parameter product: Product to populate the UI with
    func showData(product: Product) {
        // Creating a new currency formatter every time here because reusing it doesn't
        // seem to respect newly set minimumFractionDigits/maximumFractionDigits
        let currencyFormatter = createCurrencyFormatter(product: product)

        productNameLabel.text = product.displayName.uppercased()
        productCurrentPriceLabel.text = currencyFormatter.string(from: product.currentPrice.amount as NSNumber)

        let priceChange = (product.currentPrice - product.closingPrice)?.amount ?? 0.0
        let priceChangeInPercents = priceChange / product.closingPrice.amount
        productDayChangeLabel.text = percentFormatter.string(from: priceChangeInPercents as NSNumber)
    }

    // MARK: - Utility methods

    /// Creates a new NumberFormatter that is set to format currency numbers based on product.
    ///
    /// - Parameter product: Product to initialize formatter for
    /// - Returns: Newly created NumberFormatter that is set up based on product.
    private func createCurrencyFormatter(product: Product) -> NumberFormatter {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency

        currencyFormatter.currencyCode = product.quoteCurrency
        currencyFormatter.minimumFractionDigits = product.currentPrice.decimals
        currencyFormatter.maximumFractionDigits = product.currentPrice.decimals

        return currencyFormatter
    }

}
