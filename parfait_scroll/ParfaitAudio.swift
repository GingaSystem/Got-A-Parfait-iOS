//
//  ParfaitAudio.swift
//  parfait_scroll
//
//  Created by Kenichi Maehashi on 2019/09/17.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import AVFoundation

var players: [AVAudioPlayer] = []

func stopTrack() {
    for player in players {
        player.stop()
    }
    players.removeAll()
}

func previewTrack(parts: Dictionary<ParfaitPart.Kind, ParfaitPart>, loop: Bool = false) {
    stopTrack()
    
    for part in parts.values {
        var player : AVAudioPlayer
        do {
            try player = AVAudioPlayer(contentsOf: part.trackURL)
        } catch {
            print("Failed to play track: ", part.trackURL)
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

private func getPCM16() -> AVAudioFormat {
    return AVAudioFormat(
        commonFormat: AVAudioCommonFormat.pcmFormatInt16,
        sampleRate: 44100,
        channels: 2,
        interleaved: true)!
}

func getAudioURL() -> URL {
    return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("audio.wav")!
}

func renderTrack(parts: Dictionary<ParfaitPart.Kind, ParfaitPart>) -> (URL, Int64) {
    let audioFiles = parts.values.map({ try! AVAudioFile(forReading: $0.trackURL) })
    
    // Render audio track
    let engine = AVAudioEngine()
    let getPlayerNode = { (_ engine: AVAudioEngine, _ file: AVAudioFile) -> AVAudioPlayerNode in
        let playerNode = AVAudioPlayerNode()
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: file.processingFormat)
        playerNode.scheduleFile(file, at: nil, completionHandler: nil)
        return playerNode
    }
    let playerNodes = audioFiles.map({ getPlayerNode(engine, $0) })

    try! engine.enableManualRenderingMode(.offline,
                                          format: getPCM16(),
                                          maximumFrameCount: AVAudioFrameCount(8096))
    try! engine.start()
    playerNodes.forEach({ $0.play() })
    
    let url = getAudioURL()
    if FileManager.default.fileExists(atPath: url.path) {
        try! FileManager.default.removeItem(at: url)
    }

    var outputFile = try? AVAudioFile(forWriting: url, settings: getPCM16().settings, commonFormat: getPCM16().commonFormat, interleaved: true)
    let buffer = AVAudioPCMBuffer(pcmFormat: engine.manualRenderingFormat,
                                  frameCapacity: engine.manualRenderingMaximumFrameCount)!
    let audioLength = audioFiles.map({$0.length}).max()!
    while engine.manualRenderingSampleTime < audioLength {
        do {
            let framesToRender = min(buffer.frameCapacity, AVAudioFrameCount(audioLength))
            let status = try! engine.renderOffline(framesToRender, to: buffer)
            switch status {
            case .success:
                print("Write to file")
                try! outputFile!.write(from: buffer)
            case .error:
                fatalError()
            default:
                break
            }
        }
    }
    outputFile = nil
    print("Finish write")
    
    return (url, audioLength)
}
