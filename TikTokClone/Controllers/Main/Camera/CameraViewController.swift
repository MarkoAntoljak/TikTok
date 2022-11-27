//
//  CameraViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit
import AVFoundation

/// video camera view controller
class CameraViewController: UIViewController {
    
    // MARK: Attributes
    
    // av foundation, for setting up video view
    // capture session
    private lazy var captureSession = AVCaptureSession()
    // capture device
    private var captureVideoDevice: AVCaptureDevice?
    // capture output
    private lazy var captureOutput = AVCaptureMovieFileOutput()
    // capture layer
    private var previewLayer: AVCaptureVideoPreviewLayer?
    // video preview layer
    private var previewPlayerLayer: AVPlayerLayer?
    
    private var recordedVideoURL: URL?
    
    // MARK: UI Elements
    
    private lazy var cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var btnRecord = TikTokRecordingButton(frame: .zero)
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationItem.title = "My video"
        tabBarItem.title = ""
        
        // add navigation close item
        let btnClose = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        btnClose.tintColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = btnClose
        
        // configuration
        addSubviews()
        addActions()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // remove tab bar on camera
        tabBarController?.tabBar.isHidden = true
        
        // setting up and starting video
        setUpCamera()
        
    }
    
    // MARK: Functions
    
    private func addSubviews() {
        
        view.addSubview(cameraView)
        view.addSubview(btnRecord)
    }
    
    private func setFrames() {
        
        cameraView.frame = view.bounds
        
        // rec button
        btnRecord.frame = CGRect(x: 0, y: view.bottom - 160, width: 80, height: 80)
        btnRecord.center.x = view.center.x
    }
    
    private func addActions() {
        
        btnRecord.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
        
    }
    
    private func setUpCamera() {
    
        // add devices
        
        // microphone
        guard let audioDevice = AVCaptureDevice.default(for: .audio),
              let audioInput = try? AVCaptureDeviceInput(device: audioDevice) else {return}
            
        
            if captureSession.canAddInput(audioInput) {
                
                captureSession.addInput(audioInput)
                
            }
        
        // video
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        
            if captureSession.canAddInput(videoInput) {
                
                captureSession.addInput(videoInput)
                
            }
        
        // set video quality
        captureSession.sessionPreset = .hd1280x720
        
        // add output
        if captureSession.canAddOutput(captureOutput) {
            
            captureSession.addOutput(captureOutput)

        }
        
        // setup preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
        previewLayer?.frame = view.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        
        if previewLayer != nil {
            cameraView.layer.addSublayer(previewLayer!)
        }
        
        // start capture session on background thread for performance
        DispatchQueue.global().async {
            
            self.captureSession.startRunning()
        }
    
    }
    
    // MARK: Button Actions
    
    @objc
    private func didTapClose() {
        
        navigationItem.rightBarButtonItem = nil
        btnRecord.isHidden = false
        
        if previewPlayerLayer != nil {
            
            previewPlayerLayer = nil
            previewPlayerLayer?.removeFromSuperlayer()
            
        } else {
            
            captureSession.stopRunning()
            tabBarController?.selectedIndex = 0
            tabBarController?.tabBar.isHidden = false
            
        }
    }
    
    // recording
    @objc
    private func didTapRecord() {
        
        if captureOutput.isRecording {
            btnRecord.toggle(for: .notRecording)
            captureOutput.stopRecording()
        } else {
            
            btnRecord.toggle(for: .recording)
            
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            
            url.appendPathComponent("_video.mp4")
            
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    
    @objc
    private func didTapNext() {
        
        guard let url = recordedVideoURL else {return}
        
        DispatchQueue.main.async {
        
            let vc = RecordingCaptionViewController(videoURL: url)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

// MARK: AVCaptureFileOutputRecordingDelegate

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    
    // finished recording
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        guard error == nil else {
            // show error to the user
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Error", message: "Something went wrong when recording.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true)
                
            }
            return
        }
        
        btnRecord.isHidden = true
        
        recordedVideoURL = outputFileURL
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        // playing recorded video
        let player = AVPlayer(url: outputFileURL)
        previewPlayerLayer = AVPlayerLayer(player: player)
        previewPlayerLayer?.videoGravity = .resizeAspectFill
        previewPlayerLayer?.frame = cameraView.bounds
        
        
        // add layer to view
        guard let layer = previewPlayerLayer else {return}
    
        cameraView.layer.addSublayer(layer)
        
        layer.player?.play() // play it 
        
    }
    
    
}

