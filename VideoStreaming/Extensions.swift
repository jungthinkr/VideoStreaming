//
//  Extensions.swift
//  VideoStreaming
//
//  Created by Aaron Liu on 4/30/17.
//  Copyright © 2017 Aaron Liu. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIViewController {
    func isPortrait() -> Bool {
        if UIDevice.current.orientation.isLandscape {
            return false
        } else {
            return true
        }
    }
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
