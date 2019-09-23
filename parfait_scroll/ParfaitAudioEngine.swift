//
//  ParfaitAudioEngine.swift
//  parfait_scroll
//
//  Created by Kenichi Maehashi on 2019/09/24.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import AVFoundation

private func getPCM16() -> AVAudioFormat {
    return AVAudioFormat(
        commonFormat: AVAudioCommonFormat.pcmFormatInt16,
        sampleRate: 44100,
        channels: 2,
        interleaved: true)!
}

class ParfaitAudioEngine {
    
    private var engine: AVAudioEngine?
    private var enginePlayerNodes: [AVAudioPlayerNode] = []
    private var audioLength: Int64 = -1
    /*
     private var isRecording: Bool = false
     private var recordingOutref: ExtAudioFileRef?
     */
    
    func setUp(_ parts: Dictionary<ParfaitPart.Kind, ParfaitPart>, _ recordingFile: URL? = nil) {
        let audioFiles = parts.values.map({ try! AVAudioFile(forReading: $0.trackURL) })
        self.audioLength = audioFiles.map({ $0.length }).max()!
        let keyAudioFile = audioFiles.filter({ $0.length == self.audioLength })[0]
        
        self.engine = AVAudioEngine()
        self.enginePlayerNodes = audioFiles.map({
            connectAudioPlayerNode(self.engine!, $0, $0 == keyAudioFile)
        })
        
        if recordingFile != nil {
            let recordingAudioFile = try! AVAudioFile(forReading: recordingFile!)
            self.enginePlayerNodes.append(
                connectAudioPlayerNode(self.engine!, recordingAudioFile, false)
            )
        }
    }
    
    private func connectAudioPlayerNode(
        _ engine: AVAudioEngine,
        _ file: AVAudioFile,
        _ installCompletionHandler: Bool = false) -> AVAudioPlayerNode {
        let playerNode = AVAudioPlayerNode()
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: file.processingFormat)
        playerNode.scheduleFile(
            file,
            at: nil,
            completionHandler: installCompletionHandler ? self.completed : nil)
        return playerNode
    }
    
    private func completed() {
        // called when key player node completed playing
    }
    
    func length() -> Int64 {
        return self.audioLength
    }
    
    func render() {
        try! AVAudioSession.sharedInstance().setActive(true)
        self.engine!.prepare()
        try! self.engine!.start()
        self.enginePlayerNodes.forEach({ $0.play() })
    }
    
    func renderOffline(url: URL) {
        let pcm16 = getPCM16()
        try! engine!.enableManualRenderingMode(.offline,
                                               format: pcm16,
                                               maximumFrameCount: AVAudioFrameCount(8096))
        var outputFile = try? AVAudioFile(forWriting: url, settings: pcm16.settings, commonFormat: pcm16.commonFormat, interleaved: true)
        let buffer = AVAudioPCMBuffer(pcmFormat: engine!.manualRenderingFormat,
                                      frameCapacity: engine!.manualRenderingMaximumFrameCount)!
        render()
        while engine!.manualRenderingSampleTime < audioLength {
            do {
                let framesToRender = min(buffer.frameCapacity, AVAudioFrameCount(audioLength))
                let status = try! engine!.renderOffline(framesToRender, to: buffer)
                switch status {
                case .success:
                    try! outputFile!.write(from: buffer)
                case .error:
                    fatalError()
                default:
                    break
                }
            }
        }
        outputFile = nil
    }
    
    /*
    func renderAndRecord(url: URL, callback: @escaping () -> Void) {
        let format = getPCM16()
        
        ExtAudioFileCreateWithURL(url as CFURL,
                                  kAudioFileWAVEType,
                                  format.streamDescription,
                                  nil,
                                  AudioFileFlags.eraseFile.rawValue,
                                  &self.recordingOutref)
        self.engine!.mainMixerNode.installTap(
            onBus: 0,
            bufferSize: AVAudioFrameCount((format.sampleRate) * 0.4),
            format: format,
            block: {
                (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
                
                let audioBuffer : AVAudioBuffer = buffer
                _ = ExtAudioFileWrite(self.recordingOutref!, buffer.frameLength, audioBuffer.audioBufferList)
        })
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        render()
    }
    
    func finalizeRecording() {
        ExtAudioFileDispose(self.recordingOutref!)
    }
 
    func stop() {
        self.engine!.stop()
    }
    */
 }
