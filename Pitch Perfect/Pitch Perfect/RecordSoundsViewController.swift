//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//  View Controller for Recording Sounds
//
//  Created by Ransom Barber on 4/4/15.
//  Copyright (c) 2015 Hart Book. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Set up UX.
        recordingInProgress.text = "Tap & Record"
        recordButton.enabled = true
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        // Adjust UX.
        recordingInProgress.hidden = false
        recordingInProgress.text = "Recording"
        stopButton.hidden = false
        recordButton.enabled = false
        
        // Prepare to record; use the date as the title.
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMddyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        
        // Set the filePath used for saving the recording data.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Create a session to handle system events: phone calls, etc.
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Record the user's voice.
        // Not sure if settings are correct. Just added to get it working as nil is no longer acceptable.
        // Had trouble, so eliminated all except the first one in the dictionary. It seems to be OK.
        let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0))]

        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: recordSettings)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        // Deactivate session.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        // Segue to PlaySoundsViewController.
        if flag {
            recordedAudio = RecordedAudio(fromFilePathURL: recorder.url, fromTitle: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass recording-data to PlaySoundsViewController.
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

}

