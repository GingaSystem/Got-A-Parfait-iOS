//
//  ParfaitMix.swift
//  parfait_scroll
//
//  Created by Kenichi Maehashi on 2019/09/22.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import AVFoundation

private var _assetExport: AVAssetExportSession!

func getMixedVideoURL() -> URL {
    return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("mixed.mp4")!
}

func renderMixed(_ audioURL: URL, _ videoURL: URL, _ callback: @escaping (AVAssetExportSession) -> Void) {
    
    let mixComposition : AVMutableComposition = AVMutableComposition()
    let compositionVideoTrack: AVMutableCompositionTrack! = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
    let compositionAudioTrack: AVMutableCompositionTrack! = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
    
    let videoAsset = AVURLAsset(url: videoURL, options: nil)
    let audioAsset = AVURLAsset(url: audioURL, options: nil)
    let videoTrack = videoAsset.tracks(withMediaType: .video)[0]
    let audioTrack = audioAsset.tracks(withMediaType: .audio)[0]
    try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: audioAsset.duration), of: videoTrack, at: CMTime.zero)
    try! compositionAudioTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: audioAsset.duration), of: audioTrack, at: CMTime.zero)
    
    compositionVideoTrack.preferredTransform = videoAsset.tracks(withMediaType: AVMediaType.video)[0].preferredTransform
    
    let videoSize: CGSize = videoTrack.naturalSize
    
    let videoComp: AVMutableVideoComposition = AVMutableVideoComposition()
    videoComp.renderSize = videoSize
    videoComp.frameDuration = CMTimeMake(value: 1, timescale: 30)
    
    // インストラクションを合成用コンポジションに設定
    let instruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: audioAsset.duration)
    let layerInstruction: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: compositionVideoTrack)
    instruction.layerInstructions = [layerInstruction]
    videoComp.instructions = [instruction]
    
    // 動画のコンポジションをベースにAVAssetExportを生成
    _assetExport = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
    // 合成用コンポジションを設定
    _assetExport?.videoComposition = videoComp
    
    // エクスポートファイルの設定
    let exportUrl = getMixedVideoURL()
    _assetExport?.outputFileType = AVFileType.mov
    _assetExport?.outputURL = exportUrl
    _assetExport?.shouldOptimizeForNetworkUse = true
    
    // ファイルが存在している場合は削除
    if FileManager.default.fileExists(atPath: exportUrl.path) {
        try! FileManager.default.removeItem(at: exportUrl)
    }
    
    // エクスポート実行
    _assetExport?.exportAsynchronously(completionHandler: { () -> Void in
        callback(_assetExport)
    })
}
