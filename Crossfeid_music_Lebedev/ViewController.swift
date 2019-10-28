//
//  ViewController.swift
//  Crossfeid_music_Lebedev
//
//  Created by Владимир on 25/10/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var crossfeidLabel: UILabel!
    @IBOutlet weak var crossfeidSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var albomPic: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var leftTimerLabel: UILabel!
    @IBOutlet weak var rightTimerLabel: UILabel!
    
    @IBAction func changeFade(_ sender: UISlider) {
        crossfeidLabel.text = "Величина кроссфейда \(Int(crossfeidSlider.value)) cек."
    }
    @IBAction func changeVolume(_ sender: UISlider) {
        correctTrack.volume = volumeSlider.value
    }
    @IBAction func btnPlay(_ sender: UIButton) {
        if songNameLabel.text == "Название трека"{
            let alert = UIAlertController(title: "Внимание!", message: "Выберите трек.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            correctTrack.play()
            playFunc()
            crossfeidSlider.isEnabled = false
        }
    }
    @IBAction func btnPause(_ sender: UIButton) {
        if correctTrack.isPlaying{
            correctTrack.pause()
            pauseFunc()
        }
        crossfeidSlider.isEnabled = true
    }
    @IBAction func firstTrack(_ sender: UIButton) {
        volumeSlider.isEnabled = true
        counter = 0
        songNameLabel.text = "Fields of Verdun - Sabaton"
        albomPic.image = UIImage(named: "FildsOfVerdunImage")
        playAudioFile(counter)
        pauseFunc()
        correctTrack.stop()
    }
    @IBAction func secondTrack(_ sender: UIButton) {
        volumeSlider.isEnabled = true
        counter = 1
        songNameLabel.text = "The attack of dead men - Sabaton"
        albomPic.image = UIImage(named: "DeadManImage")
        playAudioFile(counter)
        pauseFunc()
        correctTrack.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
    }
    
    func playAudioFile(_ index: Int){
        do {
            correctTrack = try AVAudioPlayer(contentsOf: arrayTrack[index] as! URL )
            correctTrack.numberOfLoops = 0
            correctTrack.delegate = self
            correctTrack.prepareToPlay()
            correctTrack.play()
            playFunc()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fadeTime), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerMinus), userInfo: nil, repeats: true)
        }catch{print(error)}
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        pauseFunc()
        if counter == 0{
            counter = counter + 1
            playAudioFile(counter)
            songNameLabel.text = "The attack of dead men - Sabaton"
            albomPic.image = UIImage(named: "DeadManImage")
        }else{
            counter = 0
            playAudioFile(counter)
            songNameLabel.text = "Fields of Verdun - Sabaton"
            albomPic.image = UIImage(named: "FildsOfVerdunImage")
        }
    }
    
    @objc func fadeTime(){
        if correctTrack.isPlaying{
            let fadeTime = Int(correctTrack.duration - Double(crossfeidSlider.value))
            if Int(correctTrack.currentTime) == fadeTime{
                correctTrack.setVolume(0, fadeDuration: TimeInterval(Int(crossfeidSlider.value)))
            }
        }
    }
    @objc func updateAudioProgressView(){
        if correctTrack.isPlaying{
            progressView.setProgress(Float(correctTrack.currentTime/correctTrack.duration), animated: true)
        }
    }
    func playFunc() {
        play.isHidden = true
        pause.isHidden = false
    }
    func pauseFunc() {
        play.isHidden = false
        pause.isHidden = true
    }
    func timerCounter(currentDecimalMinutes: Double){
        let secCorrect = currentDecimalMinutes.truncatingRemainder(dividingBy: 1)
        let secCorrectFormatted = String(format: "%.2f", secCorrect)
        let secundes = Int(Float(secCorrectFormatted)! * Float(60))
        if secundes <= 9{
            leftTimerLabel.text = "\(Int(currentDecimalMinutes)):0\(secundes)"
        }else{
            leftTimerLabel.text = "\(Int(currentDecimalMinutes)):\(secundes)"
        }
    }
    func timerMinusCounter(currentDecimalMinutes: Double){
        let secCorrect = currentDecimalMinutes.truncatingRemainder(dividingBy: 1)
        let secCorrectFormatted = String(format: "%.2f", secCorrect)
        let secundes = Int(Float(secCorrectFormatted)! * Float(60)) * -1
        if secundes <= 9 && currentDecimalMinutes != 0{
            rightTimerLabel.text = "\(Int(currentDecimalMinutes)):0\(secundes)"
        }else if secundes <= 60 && Int(currentDecimalMinutes) == 0{
            rightTimerLabel.text = "-\(Int(currentDecimalMinutes)):\(secundes)"
        }else if secundes <= 9 && Int(currentDecimalMinutes) == 0{
            rightTimerLabel.text = "-\(Int(currentDecimalMinutes)):0\(secundes)"
        }else {
            rightTimerLabel.text = "\(Int(currentDecimalMinutes)):\(secundes)"
        }
    }
    @objc func timer(){
        if correctTrack.isPlaying{
            let decimalMinute = correctTrack.currentTime / 60
            timerCounter(currentDecimalMinutes: decimalMinute)
        }
    }
    @objc func timerMinus(){
        if correctTrack.isPlaying{
            let decimalMinutes = (correctTrack.currentTime / 60) - (correctTrack.duration/60)
            timerMinusCounter(currentDecimalMinutes: decimalMinutes)
        }
    }
}
