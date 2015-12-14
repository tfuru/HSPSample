//
//  RecUtil.swift
//  RecSample
//
//  Created by 古川信行 on 2015/12/13.
//  Copyright © 2015年 tf-web. All rights reserved.
//

import AVFoundation

class RecUtil:NSObject,AVAudioRecorderDelegate{
    var audioRecorder: AVAudioRecorder!
        
    func initialize() -> RecUtil {
        
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                print("Permission to record granted")
                self.sessionHSP();
            }
            else {
                print("Permission to record not granted")
            }
        })
        
        return self
    }
    
    func sessionHSP(){
        
        /// 録音可能カテゴリに設定する
        let session = AVAudioSession.sharedInstance()
        do {
            //try session.setActive(false)
            
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord,
                withOptions:[AVAudioSessionCategoryOptions.AllowBluetooth,
                    AVAudioSessionCategoryOptions.DefaultToSpeaker])
            
            //try session.setCategory(AVAudioSessionCategoryMultiRoute)
            //A2DP利用可能デバイスを接続中に下を設定するとA2DP接続の出力になる
            //try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            
            //カテゴリー
            //AVAudioSessionCategoryPlayAndRecord VOIPアプリ向け 録音,再生
            //AVAudioSessionCategoryMultiRoute  複数のデバイスへ出力するなど特殊な処理向け。 録音,再生
            
            //オプション
            //AVAudioSessionCategoryOptions.AllowBluetooth   Bluetooth機器を利用
            //AVAudioSessionCategoryOptions.DefaultToSpeaker スピーカーから音出力
 
            print("outputVolume:\(session.outputVolume)")
        }
        catch let error as NSError {
            print("error:\(error.localizedDescription)")
            fatalError("カテゴリ設定失敗")
        }
        
        // sessionのアクティブ化
        do {
            try session.setActive(true)
        }
        catch let error as NSError {
            print("error:\(error.localizedDescription)")
            // audio session有効化失敗時の処理
            // (ここではエラーとして停止している）
            fatalError("session有効化失敗")
        }
        //入力,出力情報を取得
        self.routeDescription()
    }
    
    func sessionA2DP(){
        
        /// 録音可能カテゴリに設定する
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            
            /*
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord,
                withOptions:[AVAudioSessionCategoryOptions.AllowBluetooth,
                    AVAudioSessionCategoryOptions.DefaultToSpeaker])
            */
            try session.setCategory(AVAudioSessionCategoryMultiRoute)
            //A2DP利用可能デバイスを接続中に下を設定するとA2DP接続の出力になる
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            
            //カテゴリー
            //AVAudioSessionCategoryPlayAndRecord VOIPアプリ向け 録音,再生
            //AVAudioSessionCategoryMultiRoute  複数のデバイスへ出力するなど特殊な処理向け。 録音,再生
            
            //オプション
            //AVAudioSessionCategoryOptions.AllowBluetooth   Bluetooth機器を利用
            //AVAudioSessionCategoryOptions.DefaultToSpeaker スピーカーから音出力
        }
        catch let error as NSError {
            print("error:\(error.localizedDescription)")
            fatalError("カテゴリ設定失敗")
        }
        
        // sessionのアクティブ化
        do {
            try session.setActive(true)
        }
        catch let error as NSError {
            print("error:\(error.localizedDescription)")
            // audio session有効化失敗時の処理
            // (ここではエラーとして停止している）
            fatalError("session有効化失敗")
        }
        //入力,出力情報を取得
        self.routeDescription()
    }
    
    func documentsDirectoryURL() -> NSURL{
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        if urls.isEmpty {
            //
            fatalError("URLs for directory are empty.")
        }
        return urls[0]
    }
    
    /** 録音開始
    *
    */
    func start(fileName:String) -> NSURL {
        let dirURL = documentsDirectoryURL()
        let recordingsURL = dirURL.URLByAppendingPathComponent(fileName)
        
        // 録音設定
        //https://developer.apple.com/library/mac/documentation/AVFoundation/Reference/AVFoundationAudioSettings_Constants/index.html
        //caf
        let recordSettings: [String: AnyObject] = [
            AVFormatIDKey:NSNumber(unsignedInt: kAudioFormatLinearPCM),
            AVSampleRateKey: 16000.0,
            /*AVSampleRateKey: 44100.0,*/
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey:32,
            /* AVLinearPCMIsBigEndianKey:false,
            AVLinearPCMIsFloatKey:false */
            AVSampleRateConverterAudioQualityKey:AVAudioQuality.Max.rawValue,
            AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue,
            AVEncoderBitRateStrategyKey:AVAudioBitRateStrategy_Constant]

        do {
            audioRecorder = try AVAudioRecorder(URL: recordingsURL, settings: recordSettings)
            audioRecorder.meteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        catch let error as NSError {
           print("error:\(error.localizedDescription)")
        }
        
        return recordingsURL
    }
    
    /** 録音停止
    *
    */
    func stop(){
        if audioRecorder == nil {
            return
        }
        
        audioRecorder.stop()
        audioRecorder = nil
        //audioRecorder.deleteRecording()
    }
    
    /** 音量取得
    */
    func getVolume(){
        audioRecorder.updateMeters()
        
        // 0番目のチャンネルの音を取得
        print("peakPowerForChannel:\( audioRecorder.peakPowerForChannel(0) )")
        print("averagePowerForChannel:\(audioRecorder.averagePowerForChannel(0))")
    }

    //出力の情報を取得
    func routeDescription(){
        let routeDesc = AVAudioSession.sharedInstance().currentRoute        
        print("currentRoute")
        
        // 入力の情報を取得する
        let inputs = routeDesc.inputs
        for portDesc in inputs {
            //AVAudioSessionPortHeadphones
            print("inputs\n portType:\(portDesc.portType)\n portName:\(portDesc.portName)\n channels:\(portDesc.channels)")
        }
        
        // 出力の情報を取得する
        let outputs = routeDesc.outputs
        for portDesc in outputs {
            //AVAudioSessionPortHeadphones
            print("outputs\n portType:\(portDesc.portType)\n portName:\(portDesc.portName)\n channels:\(portDesc.channels)")
        }
        
        //入力ソース一覧？
        let inputDataSources = AVAudioSession.sharedInstance().inputDataSources
        if(inputDataSources != nil){
            for src in inputDataSources! {
                print("inputDataSources\n dataSourceID:\(src.dataSourceID)\n dataSourceName:\(src.dataSourceName)\n location:\(src.location)\n orientation:\(src.orientation)")
            }
        }
        
        //出力ソース一覧？
        let outputDataSources = AVAudioSession.sharedInstance().outputDataSources
        if(outputDataSources != nil){
            for src in outputDataSources! {
                print("outputDataSource\n dataSourceID:\(src.dataSourceID)\n dataSourceName:\(src.dataSourceName)\n location:\(src.location)\n orientation:\(src.orientation)")
            }
        }
    }
    
    // --------
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording")
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
            if let e = error {
                print("\(e.localizedDescription)")
            }
    }
}
