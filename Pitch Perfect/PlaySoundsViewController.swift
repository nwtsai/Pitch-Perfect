//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nathan Tsai on 12/11/16.
//  Copyright © 2016 Nathan Tsai. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController
{
    
    // These outlets are mapped to a button in the storyboard, allows us to change properties from code
    @IBOutlet weak var slowButton : UIButton!
    @IBOutlet weak var fastButton : UIButton!
    @IBOutlet weak var highPitchButton : UIButton!
    @IBOutlet weak var lowPitchButton : UIButton!
    @IBOutlet weak var echoButton : UIButton!
    @IBOutlet weak var reverbButton : UIButton!
    @IBOutlet weak var stopButton : UIButton!
    
    // recordedAudioURL holds the recorded data sent from RecordSoundsViewController.swift
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    // maps each type of voice setting to the tag number we set for each button for distinction
    enum ButtonType: Int { case slow = 0, fast, chipmunk, vader, echo, reverb }
    
    // This function is called when one of the 6 buttons is pressed
    @IBAction func playSoundForButton(_ sender: UIButton)
    {
        // The switch statement decides which setting to apply based on the tag value
        switch(ButtonType(rawValue: sender.tag)!)
        {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    // This function gets called when the stop button is pressed
    @IBAction func stopButtonPressed(_ sender: AnyObject)
    {
        
        // stopAudio() comes from the playsoundsviewcontroller-audio.swift file
        stopAudio()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupAudio()
    }
    
    // Handles which buttons get disabled between every transition
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
}
