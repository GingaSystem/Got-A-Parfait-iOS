//
//  ParfaitAudio.swift
//  parfait_scroll
//
//  Created by Kenichi Maehashi on 2019/09/17.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import AVFoundation

private var previewPlayers: [AVAudioPlayer] = []
private var previewLength: TimeInterval = 0.0

private var countInPlayer: AVAudioPlayer?
private var audioRecorder: AVAudioRecorder?
private var isRecorded = false
private let recorderDelegate = RecorderDelegate()

/*
 * Preview
 */
func previewTrack(parts: Dictionary<ParfaitPart.Kind, ParfaitPart>, loop: Bool = false) {
    stopPreview()
    
    if parts.count == 0 {
        preparePreview(parts: parts, loop: loop)
        _ = startPreview()
    }
}

private func startPreview(delay: TimeInterval = 0.01) -> TimeInterval {
    if previewPlayers.count == 0 {
        return 0
    }
    let atTime = previewPlayers[0].deviceCurrentTime + delay
    _ = previewPlayers.map({ $0.play(atTime: atTime) })
    return atTime
}

private func stopPreview() {
    _ = previewPlayers.map({ $0.stop() })
    previewPlayers.removeAll()
}

private func preparePreview(parts: Dictionary<ParfaitPart.Kind, ParfaitPart>, loop: Bool) {
    previewPlayers.removeAll()
    previewLength = 0
    for part in parts.values {
        var player : AVAudioPlayer
        do {
            player = try AVAudioPlayer(contentsOf: part.trackURL)
        } catch {
            print("failed to play track")
            continue
        }
        player.prepareToPlay()
        player.numberOfLoops = loop ? -1 : 0
        previewPlayers.append(player)
        previewLength = player.duration < previewLength ? previewLength : player.duration
    }
    
    if isRecorded {
        var player : AVAudioPlayer
        do {
            player = try AVAudioPlayer(contentsOf: getTemporaryRecordingURL())
        } catch {
            print("failed to play recored track")
            return
        }
        player.prepareToPlay()
        player.numberOfLoops = loop ? -1 : 0
        previewPlayers.append(player)
    }
}

/*
 * Audio Rendering
 */
private func getTemporaryAudioURL() -> URL {
    return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("audio.wav")!
}

func renderTrack(parts: Dictionary<ParfaitPart.Kind, ParfaitPart>) -> (URL, Int64) {
    let engine = ParfaitAudioEngine()
    engine.setUp(parts, isRecorded ? getTemporaryRecordingURL() : nil)
    
    let url = getTemporaryAudioURL()
    if FileManager.default.fileExists(atPath: url.path) {
        try! FileManager.default.removeItem(at: url)
    }
    engine.renderOffline(url: url)
    
    return (url, engine.length())
}

/*
 * Voice Recording
 */
private func getCountInTrackURL() -> URL {
    return Bundle.main.bundleURL.appendingPathComponent("CountIn.mp3")
}

private func getTemporaryRecordingURL() -> URL {
    return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("voice.mp4")!
}

func recordVoice(parts: Dictionary<ParfaitPart.Kind, ParfaitPart>, callback: @escaping () -> Void) {
    isRecorded = false

    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSession.Category.playAndRecord)
    try! session.setActive(true)
    
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    if audioRecorder != nil {
        audioRecorder!.stop()
    }
    audioRecorder = try! AVAudioRecorder(url: getTemporaryRecordingURL(), settings: settings)
    recorderDelegate.callback = callback
    audioRecorder!.delegate = recorderDelegate
    audioRecorder!.prepareToRecord()
    
    // start recording
    stopPreview()
    preparePreview(parts: parts, loop: false)
    print("recording session started for", previewLength, "seconds")
    playCountIn()
    let recordAt = startPreview(delay: 2.00)
    if !audioRecorder!.record(atTime: recordAt, forDuration: previewLength) {
        fatalError()
    }
}

func discardRecording() {
    isRecorded = false
}

private func finalizeRecording() {
    print("finalize recoriding")
    isRecorded = true
}

private func playCountIn() {
    if countInPlayer == nil {
        countInPlayer = try! AVAudioPlayer(contentsOf: getCountInTrackURL())
    }
    countInPlayer!.play()
}

private class RecorderDelegate : NSObject, AVAudioRecorderDelegate {
    var callback: (() -> Void)?
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            fatalError()
        }
        finalizeRecording()
        if callback != nil {
            callback!()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        fatalError()
    }
}
