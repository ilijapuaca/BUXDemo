//
//  ProductListViewController.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import UIKit
import HGPlaceholders
import Alamofire

/// View controller in which a complete list of available products is being shown.
class ProductListViewController: UIViewController {

    // MARK: - Properties

    /// Network manager used for BUX related API calls.
    private let buxNetworkManager = BUXNetworkManager()

    /// Array of products shown by the view controller.
    private var products: [Product]?

    /// Cached currently pending products request that we store so that we could cancel it.
    private var pendingProductsLoadRequest: DataRequest?

    // MARK: - Segue identifiers

    private let productSelectedSegue = "productSelected"

    // MARK: - Outlets

    @IBOutlet weak var productCollectionView: CollectionView! {
        didSet {
            productCollectionView.placeholderDelegate = self
        }
    }

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white

        productCollectionView.refreshControl = refreshControl

        return refreshControl
    }()

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // There seems to be a bug where collection view scroll does not play nicely
        // with navigation bar that has large title. This seems to be the workaround
        // @link: https://stackoverflow.com/a/46383305/2734193
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.largeTitleDisplayMode = .always

        // Fetch the product data and show it in a collection
        loadProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Triggering reload data here in case we got new price data while on product details screen
        if let products = products, !products.isEmpty {
            productCollectionView.reloadData()
        }
    }

    // MARK: - Utility methods

    private func loadProducts() {
        // Use HGPlaceholders to show loading placeholder for collection view
        productCollectionView.showLoadingPlaceholder()

        // Try and fetch the list of products
        pendingProductsLoadRequest = buxNetworkManager.fetchProducts { [weak self] (products, error) in
            self?.refreshControl.endRefreshing()
            self?.products = products

            guard error == nil else {
                // Based on type of error, present the user with appropriate feedback
                if let error = error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
                    self?.productCollectionView.showNoConnectionPlaceholder()
                } else {
                    self?.productCollectionView.showErrorPlaceholder()
                }
                return
            }

            DispatchQueue.main.async {
                // Finally, reload the collection view data
                self?.productCollectionView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == productSelectedSegue {
            if let destination = segue.destination as? ProductDetailsViewController,
               let productCell = sender as? UICollectionViewCell,
               let indexPath = productCollectionView.indexPath(for: productCell),
               let product = products?[indexPath.row] {
                destination.product = product
            }
        }
    }

}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - UICollectionViewDataSource implementation

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath)
        guard let products = products, let productCell = cell as? ProductCollectionViewCell else {
            return cell
        }

        let product = products[indexPath.row]
        productCell.showData(product: product)

        return productCell
    }

    // MARK: - UICollectionViewDelegate implementation

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let productCell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell {
            productCell.highlight()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let productCell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell {
            productCell.unhighlight()
        }
    }

}

extension ProductListViewController: PlaceholderDelegate {

    // MARK: - PlaceholderDelegate implementation

    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        switch placeholder.key.value {
        case "loading":
            // This placeholder has 'Cancel' as its action
            pendingProductsLoadRequest?.cancel()
            productCollectionView.reloadData()
        default:
            // All the other placeholders we use show a 'Try Again' button, retry
            loadProducts()
        }
    }

}

extension ProductListViewController: UIScrollViewDelegate {

    // MARK: - UIScrollViewDelegate implementation

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // HGPlaceholders doesn't seem to be playing nice with UIRefreshControl
        // Here's one try at trying to patch the issue, revisit
        if refreshControl.isRefreshing {
            loadProducts()
        }
    }

}
