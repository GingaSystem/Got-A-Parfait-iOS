//
//  ParfaitVideo.swift
//  parfait_scroll
//
//  Created by Kenichi Maehashi on 2019/09/21.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import AVFoundation
import UIKit

func getVideoURL() -> URL {
    return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mp4")!
}

class MovieCreator {
    
    //保存先のURL
    var url:URL?
    
    //フレーム数
    var frameCount = 0
    
    // FPS
    let fps: __int32_t = 60
    var time:Int = 60    // (time / fps)   VCからいじる
    
    var videoWriter:AVAssetWriter?
    var writerInput:AVAssetWriterInput?
    var adaptor:AVAssetWriterInputPixelBufferAdaptor!
    
    //イチバン最初はこれを呼び出す
    func createFirst(image:UIImage, size:CGSize){
        
        //保存先のURL
        url = getVideoURL()
        // ファイルが存在している場合は削除
        if FileManager.default.fileExists(atPath: url!.path) {
            try! FileManager.default.removeItem(at: url!)
        }
        // AVAssetWriter
        guard let firstVideoWriter = try? AVAssetWriter(outputURL: url!, fileType: .mov) else {
            fatalError("AVAssetWriter error")
        }
        videoWriter = firstVideoWriter
        
        //画像サイズ
        let width = size.width
        let height = size.height
        
        // AVAssetWriterInput
        let outputSettings = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height
            ] as [String : Any]
        writerInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings as [String : AnyObject])
        videoWriter!.add(writerInput!)
        
        // AVAssetWriterInputPixelBufferAdaptor
        adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: writerInput!,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: width,
                kCVPixelBufferHeightKey as String: height,
            ]
        )
        
        writerInput?.expectsMediaDataInRealTime = true
        
        // 動画の生成開始
        
        // 生成できるか確認
        if (!videoWriter!.startWriting()) {
            // error
            print("error videoWriter startWriting")
        }
        
        // 動画生成開始
        videoWriter!.startSession(atSourceTime: CMTime.zero)
        
        // pixel bufferを宣言
        var buffer: CVPixelBuffer? = nil
        
        // 現在のフレームカウント
        frameCount = 0
        
        if (!adaptor.assetWriterInput.isReadyForMoreMediaData) {
            return
        }
        
        // 動画の時間を生成(その画像の表示する時間/開始時点と表示時間を渡す)
        let frameTime: CMTime = CMTimeMake(value: Int64(__int32_t(frameCount) * __int32_t(time)), timescale: fps)
        //時間経過を確認(確認用)
        let second = CMTimeGetSeconds(frameTime)
        print(second)
        
        // CGImageからBufferを生成
        buffer = self.pixelBufferFromCGImage(cgImage: image.cgImage!)
        
        // 生成したBufferを追加
        if (!adaptor.append(buffer!, withPresentationTime: frameTime)) {
            // Error!
            print("adaptError")
            print(videoWriter!.error!)
        }
        
        
        frameCount += 1
        
    }
    
    //２回め以降はこれを呼び出す
    func createSecond(image:UIImage){
        //videoWriterがなければ終了
        if videoWriter == nil{
            return
        }
        
        // pixel bufferを宣言
        var buffer: CVPixelBuffer? = nil
        
        if (!adaptor.assetWriterInput.isReadyForMoreMediaData) {
            return
        }
        
        // 動画の時間を生成(その画像の表示する時間/開始時点と表示時間を渡す)
        let frameTime: CMTime = CMTimeMake(value: Int64(__int32_t(frameCount) * __int32_t(time)), timescale: fps)
        //時間経過を確認(確認用)
        let second = CMTimeGetSeconds(frameTime)
        print(second)
        
        // CGImageからBufferを生成
        buffer = self.pixelBufferFromCGImage(cgImage: image.cgImage!)
        
        // 生成したBufferを追加
        if (!adaptor.append(buffer!, withPresentationTime: frameTime)) {
            // Error!
            print(videoWriter!.error!)
        }
        
        print("frameCount :\(frameCount)")
        frameCount += 1
    }
    
    //終わったら後始末をしてURLを返す
    func finished(_ completion:@escaping (URL)->()){
        // 動画生成終了
        if writerInput == nil || videoWriter == nil{
            return
        }
        writerInput!.markAsFinished()
        videoWriter!.endSession(atSourceTime: CMTimeMake(value: Int64((__int32_t(frameCount)) *  __int32_t(time)), timescale: fps))
        
        videoWriter!.finishWriting(completionHandler: {
            // Finish!
            print("movie created.")
            self.writerInput = nil
            self.videoWriter = nil
            if self.url != nil {
                completion(self.url!)
            }
        })
        
    }
    
    //ピクセルバッファへの変換
    func pixelBufferFromCGImage(cgImage: CGImage) -> CVPixelBuffer {
        
        let options = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        
        var pxBuffer: CVPixelBuffer? = nil
        
        let width = cgImage.width
        let height = cgImage.height
        
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32ARGB,
                            options as CFDictionary?,
                            &pxBuffer)
        
        CVPixelBufferLockBaseAddress(pxBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pxdata = CVPixelBufferGetBaseAddress(pxBuffer!)
        
        let bitsPerComponent: size_t = 8
        let bytesPerRow: size_t = 4 * width
        
        let rgbColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pxdata,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(cgImage, in: CGRect(x:0, y:0, width:CGFloat(width),height:CGFloat(height)))
        
        CVPixelBufferUnlockBaseAddress(pxBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pxBuffer!
    }
}

func renderVideo(image img: UIImage, length: Int64, cb: @escaping(URL)->()) {
    let mc = MovieCreator()
    
    mc.time = Int(Double(length) / 44100.0 / 2 * 60) + 1 // TODO
    print("track length is", length, mc.time)
    mc.createFirst(image: img, size: img.size)
    mc.createSecond(image: img)
    mc.finished(cb)
}
