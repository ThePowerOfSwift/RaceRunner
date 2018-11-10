//
//  SoundManager.swift
//  RaceRunner
//
//  Created by Josh Adams on 11/18/15.
//  Copyright © 2015 Josh Adams. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
  private static let soundManager = SoundManager()
  private static let soundExtension = "mp3"

  private var sounds: [String: AVAudioPlayer]

  private init () {
    sounds = Dictionary()
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback) // was ambient
    } catch let error as NSError {
      print("\(error.localizedDescription)")
    }
  }
  
  static func play(_ sound: Sound) {
    if soundManager.sounds[sound.rawValue] == nil {
      if let audioUrl = Bundle.main.url(forResource: sound.rawValue, withExtension: soundExtension) {
        do {
          try soundManager.sounds[sound.rawValue] = AVAudioPlayer.init(contentsOf: audioUrl)
        } catch let error as NSError {
          print("\(error.localizedDescription)")
        }
      }

    }
    soundManager.sounds[sound.rawValue]?.play()
  }
  
  static func enableBackgroundAudio() {
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
    }
    catch let error as NSError {
      print("\(error.localizedDescription)")
    }
  }
}
