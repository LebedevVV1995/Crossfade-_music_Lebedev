//
//  Item.swift
//  Crossfeid_music_Lebedev
//
//  Created by Владимир on 27/10/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

import Foundation
import AVFoundation

var correctTrack = AVAudioPlayer()
let path = Bundle.main.path(forResource: "Fields_of_Verdun.mp3", ofType: nil)!
let path2 = Bundle.main.path(forResource: "TheAttack_of_theDeadMen.mp3", ofType: nil)!
let url = URL(fileURLWithPath: path)
let url2 = URL(fileURLWithPath: path2)
let arrayTrack = NSMutableArray(array: [url, url2])
var counter = 0
