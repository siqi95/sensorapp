//
//  ViewController.swift
//  SensorAppp
//
//  Created by Siqi Wei on 12/10/2019.
//  Copyright © 2019 Siqi Wei. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var motionManager: CMMotionManager!
    
    let filename = "Assignment2.csv"
    var csvText = "AccelerationX,AccelerationY,AccelerationZ,RotationX,RotationY,RotationZ,Latitude,Longtitude,Altitude End\n"
    
    @IBOutlet weak var accelerationXLabel: UILabel!
    @IBOutlet weak var accelerationYLabel: UILabel!
    @IBOutlet weak var accelerationZLabel: UILabel!
    @IBOutlet weak var rotationXLabel: UILabel!
    @IBOutlet weak var rotationYLabel: UILabel!
    @IBOutlet weak var rotationZLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func startTapped(_ sender: UIButton) {
        messageLabel.text = "Sensor started."
        startButton.isEnabled = false
        stopButton.isEnabled = true
        sendButton.isEnabled = true
    }
    @IBAction func stopTapped(_ sender: UIButton) {
        stopMotionUpdates()
        messageLabel.text = "Sensor stopped."
        startButton.isEnabled = true
        stopButton.isEnabled = false
        sendButton.isEnabled = false
    }
    @IBAction func sendTapped(_ sender: UIButton) {
        startMotionUpdates()
        messageLabel.text = "Sending data..."
        sendButton.isEnabled = false
        sendData()
        
    }
    func sendData(){
        messageLabel.text = "Data sent."
        sendButton.isEnabled = true
    }

    func initializeMotion(){
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.1 //seconds
        
    }
    
    func startMotionUpdates(){
        motionManager.startDeviceMotionUpdates(
            to: OperationQueue.main, withHandler: motionHandler)
        
    }
    func motionHandler(deviceMotion: CMDeviceMotion?,error: Error?){
        if let err = error{
            print("motionHandler error: \(err.localizedDescription)")
        }else{
            if let dm = deviceMotion {
                self.processMotionData(dm)
            }else {
                print("motionHandler: deviceMotion = nil")
            }
        }
        
    }
    
    func processMotionData (_ dm: CMDeviceMotion){
        let accX = dm.userAcceleration.x
        let accY = dm.userAcceleration.y
        let accZ = dm.userAcceleration.z
        let rotX = dm.attitude.pitch
        let rotY = dm.attitude.roll
        let rotZ = dm.attitude.yaw
        accelerationXLabel.text = "Acceleration X = \(accX)"
        accelerationYLabel.text = "Acceleration Y = \(accY)"
        accelerationZLabel.text = "Acceleration Z = \(accZ)"
        rotationXLabel.text = "Rotation X (pitch) = \(rotX)"
        rotationYLabel.text = "Rotation Y (roll) = \(rotY)"
        rotationZLabel.text = "Rotation Z (yaw) = \(rotZ)"
        let newLine = "\(accX),\(accY),\(accZ),\(rotX),\(rotY),\(rotZ)\n"
        csvText.append(contentsOf: newLine)
        print(csvText)
    }
    func stopMotionUpdates(){
        motionManager.stopDeviceMotionUpdates()

        let path = NSURL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent(filename)!

        do {
            try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            vc.excludedActivityTypes = [
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo,
                UIActivityType.postToTwitter,
                UIActivityType.postToFacebook,
                UIActivityType.openInIBooks
            ]
            present(vc, animated: true, completion: nil)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeMotion()
        messageLabel.text = "Press start to begin"
        startButton.isEnabled = true
        stopButton.isEnabled = false
        sendButton.isEnabled = false
        
        //let path = NSURL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent(filename)
        var csvText = "AccelerationX,AccelerationY,AccelerationZ,RotationX,RotationY,RotationZ,Latitude,Longtitude,Altitude End\n"
        
        //print(path)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

