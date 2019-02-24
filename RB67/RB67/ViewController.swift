//
//  ViewController.swift
//  RB67
//
//  Created by Jiayun Li on 2/21/19.
//  Copyright © 2019 Jiayun Li. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera:AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    var filterSelected = "Vintage"
    let filterArray = ["Vintage","Modern","B&W"]
    
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var filterPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterPicker.dataSource = self
        filterPicker.delegate = self
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
// picker view func
    

    
//    func initPreviewViewfinder() {
//        previewView.frame = CGRect(x: 20, y: 200, width: 100, height: 100)
//    }
    
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
            for device in devices {
                if device.position == AVCaptureDevice.Position.back{
                    backCamera = device
                } else if device.position == AVCaptureDevice.Position.front {
                    frontCamera = device }
                }
        
        currentCamera = backCamera
    }
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        
// vvv resize camera preview to view element vvv
        previewView.layer.addSublayer(cameraPreviewLayer!)
        self.cameraPreviewLayer?.frame = self.previewView.bounds

//        previous line
//        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }

    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
//        performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto_Segue" {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
            previewVC.filterSelectedForDevelop = filterSelected
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterSelected = filterArray[row]
        print("\(filterSelected)")
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterArray[row]
    }
    
}
