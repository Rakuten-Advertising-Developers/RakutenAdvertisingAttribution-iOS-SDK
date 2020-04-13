//
//  CartViewController.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    weak var orderModifier: OrderModifier? = OrderManager.shared
    weak var orderDescriber: OrderDescriber? = OrderManager.shared
    
    var notificationCenter = NotificationCenter.default
    
    @IBOutlet weak var emptyCartLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        notificationCenter.addObserver(self, selector: #selector(orderStateDidChange), name: .orderStateDidChange, object: nil)
    }
    
    deinit {
        
        notificationCenter.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        updateContent()
    }
    
    @objc func orderStateDidChange() {
        
        updateContent()
    }
    
    func updateContent() {
        
        let productsCount = orderDescriber?.productsCount ?? 0
        
        navigationController?.tabBarItem.badgeValue = productsCount > 0 ? String(productsCount) : nil
        
        guard isViewLoaded else { return }
        
        emptyCartLabel.isHidden = productsCount != 0
        contentView.isHidden = productsCount == 0
        
        tableView.reloadData()
    }
    
    @IBAction func purchaseButtonPressed(_ sender: Any) {
   
        orderModifier?.purchase()
    }
}

extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderDescriber?.productsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        
        guard let orderDescriber = orderDescriber else { return cell }
        
        let product = orderDescriber.product(at: indexPath.row)
        
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = NumberFormatter.string(decimal: product.price)
        
        return cell
    }
}
