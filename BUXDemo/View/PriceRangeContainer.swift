//
//  PriceRangeContainer.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 20/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import UIKit

/// A simple view container with rounded corners.
class PriceRangeContainer: UIView {

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = 5.0
    }

}
