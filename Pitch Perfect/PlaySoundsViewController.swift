//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by TOM BELUNIS on 3/15/15.
//  Copyright (c) 2015 TOM BELUNIS. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize new instances AVAudioPlayer and AVAudioEngine
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        
        // Create a new instance of AVAudioFile from the filePathUrl from receivedAudio
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // When the slow button is clicked play audio at half speed
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    // When the fast button is clicked play audio at double speed
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(2.0)
    }

    // Stop the audio player and audio engine
    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetAudio()
    }
    
    // When the chipmunk button is clicked play the audio with 
    // pitch set to 1000
    @IBAction func playChipmunkAduio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    // When the Darth Vader button is clicked play the audio with
    // pitch set to -1000
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Play the audio with an echo effect
    @IBAction func playEchoAudio(sender: UIButton) {
        stopAndResetAudio()
        
        // Create an AVAudioPlayerNode instance to play the file
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Create an instance of AVAudioUnitDelay, the delay will
        // create the echo effect
        var echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.4)
        audioEngine.attachNode(echoNode)
        
        // Connect the nodes so that the audioPlayerNode sends the audio
        // file through the echoNode which will apply the delay and
        // send the audio to the engine's outputNode
        audioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        
        // Tell audioPlayerNode to schedule playing the file as soon as 
        // possible
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // Start the audio engine and play the file
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    // Plays the audio with the reverb effect
    @IBAction func playReverbAudio(sender: UIButton) {
        stopAndResetAudio()
 
        // Create an AVAudioPlayerNode instance to play the file
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        // Create an instance of a AVAudioUnitReverb to create
        // the reverb effect. Set the wetDryMix to .75 (75% wet signals)
        var reverbNode = AVAudioUnitReverb()
        reverbNode.wetDryMix = 75
        audioEngine.attachNode(reverbNode)
        
        // Connect the nodes so the audio gets sent through the reverb node 
        // before being output
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)

        // Tell audioPlayerNode to schedule playing the file as soon as
        // possible
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // Start the audio engine and play the file
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func stopAndResetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // Change the playback rate on the audio player
    // and then have the player play the audio
    func playAudioWithVariableRate(rate: Float) {
        stopAndResetAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    // Play the audio with the specified pitch
    func playAudioWithVariablePitch(pitch: Float){
        stopAndResetAudio()
        
        // Create an AVAudioPlayerNode instance to play the file
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Create an instance on AVAudioUnitTimePitch to 
        // change the pitch of the audio
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect the nodes so that the audio is sent through the change pitch 
        // effect before being output
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Tell audioPlayerNode to schedule playing the file as soon as
        // possible
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // Start the audio engine and play the file
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
}
