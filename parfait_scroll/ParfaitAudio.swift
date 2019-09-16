//
//  ParfaitAudio.swift
//  parfait_scroll
//
//  Created by Kenichi Maehashi on 2019/09/17.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import AVFoundation

var players: [AVAudioPlayer] = []

func stopTracks() {
    for player in players {
        player.stop()
    }
    players.removeAll()
}

func previewTrack(parts: Dictionary<ParfaitPart.Kind, ParfaitPart>, loop: Bool = false) {
    stopTracks()
    
    for part in parts.values {
        let url = Bundle.main.bundleURL.appendingPathComponent(part.trackName)
        var player : AVAudioPlayer
        do {
            try player = AVAudioPlayer(contentsOf: url)
        } catch {
            print("Failed to play track: ", url)
            continue
        }
        player.prepareToPlay()
        player.numberOfLoops = loop ? -1 : 0
        players.append(player)
    }
    
    for player in players {
        player.play()
    }
}
