//
//  ViewController.swift
//  RecSample
//
//  Created by 古川信行 on 2015/12/13.
//  Copyright © 2015年 tf-web. All rights reserved.
//

import UIKit

import AVFoundation

class ViewController: UIViewController {

    var recUtil:RecUtil!
    var recordingsURL:NSURL!
    
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        recUtil = RecUtil().initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func clickBtnStart(sender: AnyObject) {
        recordingsURL = recUtil.start("rec.caf")
        print("recordingsURL:\(recordingsURL)")
    }
    
    @IBAction func clickBtnStop(sender: AnyObject) {
        recUtil.stop()
        print("stop()")
    }
    
    @IBAction func clickPlay(sender: AnyObject) {
        //再生
        //let url:NSURL = NSBundle.mainBundle().URLForResource("out", withExtension: "caf")!
        //play(url)
        
        play(recordingsURL)
    }
    
    @IBAction func clickPlayA2DP(sender: AnyObject) {
        //再生
        
        //A2DPに設定
        recUtil.sessionA2DP();
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("out", withExtension: "caf")!
        play(url)
    }
    
    @IBAction func clickPlayLocal(sender: AnyObject) {
        //再生
        
        //HSPに設定
        recUtil.sessionHSP();
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("out", withExtension: "caf")!
        play(url)
    }
    
    @IBAction func clickPlayLocalVolume2(sender: AnyObject) {
        //再生
        
        //HSPに設定
        recUtil.sessionHSP();
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("out", withExtension: "caf")!
        play(url,volume:0.1)
    }
    
    @IBAction func clickPlayLocal100(sender: AnyObject) {
        //再生
        
        //HSPに設定
        recUtil.sessionHSP();
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("sin_440_100", withExtension: "caf")!
        self.play(url)
    }
    
    @IBAction func clickPlayLocal75(sender: AnyObject) {
        //再生
        
        //HSPに設定
        recUtil.sessionHSP();
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("sin_440_75", withExtension: "caf")!
        play(url)
    }
    
    @IBAction func clickPlayLocal50(sender: AnyObject) {
        //再生
        
        //HSPに設定
        recUtil.sessionHSP();
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("sin_440_50", withExtension: "caf")!
        play(url)
    }
    
    @IBAction func clickPlayLocal25(sender: AnyObject) {
        //再生

        //HSPに設定
        recUtil.sessionHSP();
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("sin_440_25", withExtension: "caf")!
        play(url)
    }
    
    //再生
    func play(audioPath:NSURL){
        self.play(audioPath,volume:1.0)
    }
    
    func play(audioPath:NSURL,volume:Float){
        do {
            print("audioPath:\(audioPath)")

            if(audioPlayer != nil){
                audioPlayer.stop()
                audioPlayer = nil;
            }
            
            audioPlayer = try AVAudioPlayer (contentsOfURL: audioPath)
            audioPlayer.prepareToPlay()
            //出力 音量を下げる
            audioPlayer.volume = volume
            audioPlayer.play()
            
            print("audioPlayer volume:\(audioPlayer.volume)")
        }
        catch let error as NSError{
            print("error \(error.localizedDescription)")
        }
    }
}

