//
//  THAppSettings.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THAppSettings: NSObject {
    
    let TRANSITIONS_ENABLED_KEY = "transitionsEnabled"
    let VOLUME_FADES_ENABLED_KEY = "volumeFadesEnabled"
    let VOLUME_DUCKING_ENABLED_KEY = "volumeDuckingEnabled"
    let TITLES_ENABLED_KEY = "titlesEnabled"
    
    dynamic var transitionsEnabled:Bool {
        get {
            return UserDefaults.standard.bool(forKey: TRANSITIONS_ENABLED_KEY)
        }
        set(transitionsEnabled) {
            UserDefaults.standard.set(transitionsEnabled, forKey: TRANSITIONS_ENABLED_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    dynamic var volumenFadesEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: VOLUME_FADES_ENABLED_KEY)
        }
        set(volumenFadesEnabled) {
            UserDefaults.standard.set(volumenFadesEnabled, forKey: VOLUME_FADES_ENABLED_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    dynamic var volumeDuckingEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: VOLUME_DUCKING_ENABLED_KEY)
        }
        set(volumeDuckingEnabled) {
            UserDefaults.standard.set(volumeDuckingEnabled, forKey: VOLUME_DUCKING_ENABLED_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    dynamic var titlesEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: TITLES_ENABLED_KEY)
        }
        set(titlesEnabled) {
            UserDefaults.standard.set(titlesEnabled, forKey: TITLES_ENABLED_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var sharedSettings:THAppSettings = THAppSettings()
}
