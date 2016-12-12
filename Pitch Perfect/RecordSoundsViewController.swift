//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nathan Tsai on 12/11/16.
//  Copyright © 2016 Nathan Tsai. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate
{

    var audioRecorder: AVAudioRecorder!
    
    // Outlets allows us to go from code to UI
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    // This function runs after content is loaded but before the screen shows up to the user
    override func viewDidLoad()
    {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    // Actions allow us to from UI to code
    
    // This function runs everytime the record audio button is pressed
    @IBAction func recordAudio(_ sender: AnyObject)
    {
        recordingLabel.text = "Recording in Progress..."
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // This function runs everytime the stop recording buttons is pressed
    @IBAction func stopRecording(_ sender: AnyObject)
    {
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // This function runs after the recording is processed and saved to memory
    // Once the recording is saved successfully, the ViewController will transition to the next screen
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if flag
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else
        {
            print("Recording was not successful")
        }
    }
    
    // This function sends the recorded data to the next ViewController to use
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "stopRecording"
        {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL as URL!
        }
    }
}

