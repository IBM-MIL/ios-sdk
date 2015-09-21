//
//  ViewController.swift
//  SpeechRecognition
//
//  Created by Glenn R. Fisher on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import UIKit
import AVFoundation
import WatsonSpeechToText

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var startStopRecordingButton: UIButton!
    @IBOutlet weak var playRecordingButton: UIButton!
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var transcriptionField: UITextView!
    
    var player: AVAudioPlayer? = nil
    var recorder: AVAudioRecorder? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create file to store recordings
        let filePath = NSURL(fileURLWithPath: "\(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])/SpeechToTextRecording.wav")
        
        print(filePath) // debugging
        
        // set up session and recorder
        let session = AVAudioSession.sharedInstance()
        var settings = [String: AnyObject]()
        // settings[AVFormatIDKey] = NSNumber(unsignedInt: kAudioFormatMPEG4AAC)
        settings[AVSampleRateKey] = NSNumber(float: 44100.0)
        settings[AVNumberOfChannelsKey] = NSNumber(int: 2)
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            recorder = try AVAudioRecorder(URL: filePath, settings: settings)
        } catch {
            print("Error setting up session or recorder.")
        }
        
        // ensure recorder is set up
        guard let recorder = recorder else {
            print("Could not set up recorder.")
            return
        }
        
        // prepare recorder to record
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
        
        // disable play and transcribe buttons
        playRecordingButton.enabled = false
        transcribeButton.enabled = false
        
    }
    
    @IBAction func startStopRecording() {
        
        guard let recorder = recorder else {
            print("Recorder not properly set up.")
            return
        }
        
        if let player = player {
            if (player.playing) {
                player.stop()
            }
        }
        
        if (!recorder.recording) {
            do {
                print("Starting recording...")
                let session = AVAudioSession.sharedInstance()
                try session.setActive(true)
                recorder.record()
                startStopRecordingButton.setTitle("Stop Recording", forState: .Normal)
                playRecordingButton.enabled = false
                transcribeButton.enabled = false
            } catch {
                print("Error setting session active.")
            }
        } else {
            do {
                print("Stopping recording...")
                recorder.stop()
                let session = AVAudioSession.sharedInstance()
                try session.setActive(false)
                startStopRecordingButton.setTitle("Start Recording", forState: .Normal)
                playRecordingButton.enabled = true
                transcribeButton.enabled = true
            } catch {
                print("Error setting session inactive.")
            }
        }

    }

    @IBAction func playRecording() {
        
        guard let recorder = recorder else {
            print("Recorder not properly set up")
            return
        }
        
        if (!recorder.recording) {
            do {
                player = try AVAudioPlayer(contentsOfURL: recorder.url)
                player?.play()
            } catch {
                print("Error creating audio player with recorded file.")
            }
        }
        
    }

    @IBAction func transcribe() {
        
        guard let recorder = recorder else {
            print("Recorder not properly set up.")
            return
        }
        
        print("Transcribing recording...")
        let stt = WatsonSpeechToText(username: "004db54a-c5e0-472b-a6eb-7b106fd31370", password: "o55eeuCST9YU")
        stt.transcribeFile(recorder.url) {
            string, error in
            if let transcription = string {
                self.transcriptionField.text = transcription
            } else if let error = error {
                self.transcriptionField.text = "\(error)"
            } else {
                self.transcriptionField.text = "Error transcribing audio. No response from the server."
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

