//
//  MoviePlayer.swift
//  VideoStreaming
//
//  Created by Aaron Liu on 4/29/17.
//  Copyright © 2017 Aaron Liu. All rights reserved.
//

import UIKit
import AVFoundation

class MoviePlayer: AVPlayer {
    func configure() {
        self.automaticallyWaitsToMinimizeStalling = true
    }
    
}
