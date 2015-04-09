//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//  View Controller for Playing Recordings of Sounds with Effects
//
//  Created by Ransom Barber on 4/6/15.
//  Copyright (c) 2015 Hart Book. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up audio equipment.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        // Convert the url of a filepath to AVAudioFile type
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtVariableSpeed(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtVariableSpeed(1.5)
    }
    
    func stopPlayingAudio() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }
    
    // This handles recording-data playback rates.
    func playAudioAtVariableSpeed(speed:Float) {
        stopPlayingAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopPlayingAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitchEffect(1000)
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitchEffect(-1000)
    }
    
    // This handles recording-data playback pitch effects.
    func playAudioWithVariablePitchEffect(pitch: Float) {
        stopPlayingAudio()
        
        // Prepare and attach nodes to AVAudioEngine.
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect nodes to AVAudioEngine for play.
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Prepare system for playing.
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
