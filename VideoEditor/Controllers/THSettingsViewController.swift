//
//  THSettingsViewController.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THSettingsViewController: UITableViewController {
    
    let VIDEO_SECTION = 0
    let EXPORT_ROW = 2
    let DEMO_SECTION = 2
    let DEMO_ROW = 0
    let HEADER_HEIGHT:CGFloat = 38.0
    
    @IBOutlet weak var transitionsSwitch: UISwitch!
    @IBOutlet weak var volumeFadesSwitch: UISwitch!
    @IBOutlet weak var volumeDuckingSwitch: UISwitch!
    @IBOutlet weak var showTitlesSwitch: UISwitch!
    
    var popover: UIPopoverPresentationController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.backgroundColor = UIColor.white
        self.transitionsSwitch.isOn = THAppSettings.sharedSettings.transitionsEnabled
        self.volumeFadesSwitch.isOn = THAppSettings.sharedSettings.volumenFadesEnabled
        self.volumeDuckingSwitch.isOn = THAppSettings.sharedSettings.volumeDuckingEnabled
        self.showTitlesSwitch.isOn = THAppSettings.sharedSettings.titlesEnabled
    }

//    func contentSizeForViewInPopover() -> CGSize {
//        return CGSize(width: 300, height: 320)
//    }
    
    // MARK: Actions
    @IBAction func toggleTransitionsEnabledState(_ sender: UISwitch?) {
        THAppSettings.sharedSettings.transitionsEnabled = (sender?.isOn)!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: THTransitionsEnabledStateChangeNotification), object: sender?.isOn)
    }
    
    @IBAction func toggleVolumeFadesEnabledState(_ sender: UISwitch?) {
        THAppSettings.sharedSettings.volumenFadesEnabled = (sender?.isOn)!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: THVolumeFadesEnabledStateChangeNotification), object: sender?.isOn)
    }
    
    @IBAction func toggleVolumeDuckingEnabledState(_ sender: UISwitch?) {
        THAppSettings.sharedSettings.volumeDuckingEnabled = (sender?.isOn)!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: THVolumeDuckingEnabledStateChangeNotification), object: sender?.isOn)
    }
    
    @IBAction func toggleShowTitlesEnabledState(_ sender: UISwitch?) {
        THAppSettings.sharedSettings.titlesEnabled = (sender?.isOn)!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: THShowTitlesEnabledStateChangeNotification), object: sender?.isOn)
    }
}

extension THSettingsViewController {
    // UITableView DataSource
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = THTableSectionHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frameWidth(), height: HEADER_HEIGHT))
        view.setTitle(title: self.tableView(tableView, titleForHeaderInSection: section)!)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    
    // UITableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == VIDEO_SECTION && indexPath.row == EXPORT_ROW {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THExportRequestedNotification), object: nil)
        }
        else if indexPath.section == DEMO_SECTION && indexPath.row == DEMO_ROW {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: THLoadDemoCompositionNotification), object: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        self.popover?.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    
}


