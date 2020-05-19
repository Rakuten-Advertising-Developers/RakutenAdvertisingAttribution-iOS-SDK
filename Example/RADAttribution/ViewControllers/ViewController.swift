//
//  ViewController.swift
//  RADAttribution
//
//  Created by Andrii Durbalo on 03/31/2020.
//  Copyright (c) 2020 Andrii Durbalo. All rights reserved.
//

import UIKit
import RADAttribution

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

        let simpleEvent = TableAction.send(event: Event(name: "VIEW_ITEM"))
        tableHandler.actions.append(simpleEvent)

        let event = TableAction.send(event: randomEvent())
        tableHandler.actions.append(event)
    }

    func randomEvent() -> Event {

        let eventData = EventData(transactionId: UUID().uuidString,
                                         currency: "USD",
                                         revenue: 10,
                                         shipping: Double.random(in: 10.0 ..< 20.0),
                                         tax: Double.random(in: 5.0 ..< 15.0),
                                         coupon: "coupon_text",
                                         affiliation: "affiliation",
                                         description: "description",
                                         searchQuery: "search_query")

        let customData: EventCustomData = ["purchase_loc": "Palo Alto",
                                           "store_pickup": "unavailable"]

        let content1: EventContentItem = [.price: 100,
                                          .quantity: 1,
                                          .sku: "SomeSKU",
                                          .productName: "Product name 1"]

        let content2: EventContentItem = [.price: 200,
                                          .quantity: 2,
                                          .sku: "Some another SKU",
                                          .productName: "Product name 2"]

        let event = Event(name: "ADD_TO_CART",
                          eventData: eventData, //Bool.random() ? eventData : nil,
                          customData: customData, //Bool.random() ? customData : nil,
                          contentItems: [content1, content2]) //Bool.random() ? contentItems : nil)
        return event
    }
}

extension ViewController: TableHandlerDelegate {

    func didSelect(tableAction: TableAction) {

        switch tableAction {
        case .resolve(let link):
            RADAttribution.shared.linkResolver.resolveLink(url: link)
        case .send(let event):
            RADAttribution.shared.eventSender.send(event: event)
        }
    }
}
