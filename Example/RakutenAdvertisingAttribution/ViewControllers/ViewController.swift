//
//  ViewController.swift
//  RakutenAdvertisingAttribution
//
//  Created by Andrii Durbalo on 03/31/2020.
//  Copyright (c) 2020 Andrii Durbalo. All rights reserved.
//

import UIKit
import RakutenAdvertisingAttribution

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var tableHandler: TableHandler = {
        let handler = TableHandler()
        tableView.delegate = handler
        tableView.dataSource = handler
        return handler
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableHandler.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        prepareDataSource()
        tableView.reloadData()
    }

    func prepareDataSource() {

        let linkAction = TableAction.resolve(link: "https://rakutenadvertising.app.link/vpgd5mKFV5?%243p=a_custom_781200801305432596&id=lMh2Xiq9xN0&offerid=725768.2&type=3&subid=0&mid=44066&u1=aaron")
        tableHandler.actions.append(linkAction)

        let simpleEvent = TableAction.send(event: purchaseEvent())
        tableHandler.actions.append(simpleEvent)
    }

    func purchaseEvent() -> Event {

        let revenue: Decimal = 10
        let description: String = "Description"

        let eventData = EventData(transactionId: UUID().uuidString,
                                  currency: "USD",
                                  revenue: Double(truncating: revenue as NSNumber),
                                  shipping: Double.random(in: 10.0 ..< 20.0).percentStyle,
                                  tax: Double.random(in: 5.0 ..< 15.0).percentStyle,
                                  coupon: "coupon_text",
                                  affiliation: "affiliation",
                                  description: description,
                                  searchQuery: description)

        let customData: EventCustomData = ["Key3": "Value3",
                                           "Key4": "Value4"]

        let contentItems: [EventContentItem] = [
            [.price: 8,
             .quantity: 2,
             .sku: UUID().uuidString,
             .productName: "Test Name"]
        ]

        let event = Event(name: "PURCHASE",
                          eventData: eventData,
                          customData: customData,
                          contentItems: contentItems)
        return event
    }
}

extension ViewController: TableHandlerDelegate {

    func didSelect(tableAction: TableAction) {

        switch tableAction {
        case .resolve(let link):
            RakutenAdvertisingAttribution.shared.linkResolver.resolveLink(url: link)
        case .send(let event):
            RakutenAdvertisingAttribution.shared.eventSender.send(event: event)
        }
    }
}

fileprivate extension Double {

    var percentStyle: Double {

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2

        guard let stringValue = formatter.string(from: self as NSNumber),
            let value = Double(stringValue) else {
                return 0
        }
        return value
    }
}
