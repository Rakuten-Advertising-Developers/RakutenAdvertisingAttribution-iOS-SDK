//
//  ProductDetailsViewController.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var product: Product?
    weak var orderModifier: OrderModifier? = OrderManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        updateContent()
    }
    
    func configureNavBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.title = "Product Details"
    }
    
    @objc func cancelButtonPressed() {
        
        dismiss(animated: true)
    }
    
    func updateContent() {
        
        guard let product = product else { return }
        
        productNameLabel.text = product.name
        priceLabel.text = NumberFormatter.string(decimal: product.price)
        
        if let url = product.imageURLString.flatMap({ URL(string: $0) }) {
            productImageView.load(url: url)
        }
    }
    
    @IBAction func addToCartButtonPressed(_ sender: Any) {
        
        guard let product = product else { return }
        orderModifier?.add(product: product)
        
        dismiss(animated: true)
    }
}
