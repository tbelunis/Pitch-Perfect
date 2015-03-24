//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by TOM BELUNIS on 3/4/15.
//  Copyright (c) 2015 TOM BELUNIS. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        recordingLabel.text = "Tap to Record"
        recordingLabel.hidden = false
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        // Show text to let user you recording is in progress and
        // display the stop button and disable the record button
        recordingLabel.text = "Recording"
        recordingLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        // Create the file name for the audio recording
        // Determine the directory where the file will reside
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Generate the file name from the current date and time
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        // Get a handle to the instance of the AVAudioSession and
        // set the category to allow recording and playback
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Create a new instance of the AVAudioRecorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        
        // Set the audioRecorder's delegate to self because we will implement
        // audioRecorderDidFinishRecording in this class
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        

    }
    
    // Delegate method that gets called when the recorder has finished recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        // If flag == true, then create a new instance of RecordedAudio and pass it as the sender
        // parameter in the call to perform the seque to RecordSoundsViewController
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            recordButton.enabled = true
            stopButton.hidden = true
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Make sure the seque is the one to the RecordSoundsViewController
        // If it is, get a handle to the view controller and set the receivedAudio instance 
        // variable to the data passed in the sender parameter
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    

    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
}

