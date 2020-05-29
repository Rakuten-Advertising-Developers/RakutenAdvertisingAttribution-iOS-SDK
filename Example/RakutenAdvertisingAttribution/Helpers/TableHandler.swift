//
//  ExampleDatasource.swift
//  RADAttribution_Example
//
//  Created by Durbalo, Andrii on 08.05.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import UIKit
import RADAttribution

protocol TableHandlerDelegate: class {

    func didSelect(tableAction: TableAction)
}

enum TableAction {

    case resolve(link: URL)
    case send(event: Event)

    var title: String {

        switch self {
        case .resolve(let url):
            return "Resolve \(url.host ?? "")"
        case .send:
            return "Send event"
        }
    }

    var subtitle: String? {

        switch self {
        case .resolve(let url):
            return url.absoluteString
        case .send(let event):
            return event.name
        }
    }
}

class TableHandler: NSObject {

    weak var delegate: TableHandlerDelegate?
    var actions: [TableAction] = []
}

extension TableHandler: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")

        let action = actions[indexPath.row]

        cell.textLabel?.text = action.title
        cell.detailTextLabel?.text = action.subtitle
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension TableHandler: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let action = actions[indexPath.row]
        delegate?.didSelect(tableAction: action)
    }
}
