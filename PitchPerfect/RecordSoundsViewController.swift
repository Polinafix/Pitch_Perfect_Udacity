//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Polina Fiksson on 13/06/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordingLabel.text = "Tap to record"
    }

   
    @IBAction func recordAudio(_ sender: UIButton) {
        configureUI(recordingState: true)
        
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
    @IBAction func stopRecording(_ sender: UIButton) {
        configureUI(recordingState: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func configureUI(recordingState:Bool){
            recordButton.isEnabled = !recordingState
            stopRecordingButton.isEnabled = recordingState
            recordingLabel.text = recordingState ? "Recording in progress" : "Tap to Record"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as? PlaySoundsViewController
            let recordedAudioURL = sender as? URL
            playSoundsVC?.recordedAudioURL = recordedAudioURL
    }
    }

}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            let alertMessage = UIAlertController(title: "Error", message: "Recording was not successful", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertMessage.addAction(OKAction)
            present(alertMessage, animated: true, completion:nil)
            
        }
    }
}

