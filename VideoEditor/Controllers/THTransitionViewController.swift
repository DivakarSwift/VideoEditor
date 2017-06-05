//
//  THTransitionViewController.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
protocol THTransitionViewControllerDelegate {
    func transitionSelected()
}
class THTransitionViewController: UITableViewController {

    var delegate: THTransitionViewControllerDelegate?
    var transition: THVideoTransition?
    var transitionTypes: [String]?
    
    static func controllerWithTransition(transition: THVideoTransition) -> THTransitionViewController {
        return THTransitionViewController(withTransition: transition)
    }
    
    init(withTransition transition: THVideoTransition) {
        super.init(style: .plain)
        self.transition = transition
        self.transitionTypes = ["None", "Dissolve", "Push"]
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.isScrollEnabled = false
        self.tableView.contentSize = CGSize(width: 200, height: 140)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transitionTypeFromString(type: String) -> THVideoTransitionType {
        if type == "Disolve" {
            return THVideoTransitionType.dissolve
        }
        else if type == "Push" {
            return THVideoTransitionType.push
        }
        else {
            return THVideoTransitionType.none
        }
    }
}

// TableView DataSource
extension THTransitionViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.transitionTypes?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
//            cell.selectionStyle = .none
//        }
        
        let type = self.transitionTypes![indexPath.row]
        cell.textLabel?.text = type
        if self.transition?.type == self.transitionTypeFromString(type: type) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
}


// TableView Delegate
extension THTransitionViewController {
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let currentIndexPath = tableView.indexPathForSelectedRow
        if currentIndexPath == indexPath {
            self.tableView.deselectRow(at: currentIndexPath!, animated: true)
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.transitionTypes![indexPath.row]
        self.transition?.type = self.transitionTypeFromString(type: type)
        self.tableView.reloadData()
        self.delegate?.transitionSelected()
    }
    
    
}
