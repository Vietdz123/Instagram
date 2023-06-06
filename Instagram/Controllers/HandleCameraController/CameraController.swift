//
//  CameraController.swift
//  Instagram
//
//  Created by Long Bảo on 15/05/2023.
//

import UIKit
import AVFoundation

protocol CameraDelegate: AnyObject {
    func didCapturePhoto(image: UIImage?)
}

class CameraController: UIViewController {
    //MARK: - Properties
    var captureSession: AVCaptureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var frontInput: AVCaptureInput!
    var videoOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isCapurePhoto = false
    var beingBackCamera = true
    var onFlash: Bool = false
    let type: UsingPickPhotoType
    weak var delegate: CameraDelegate?
    
    
    private lazy var switchCamImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "arrow.triangle.2.circlepath.camera"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleSwitchImageTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    private lazy var backImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "xmark"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleBackImageTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
        
    private lazy var flashImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "bolt.slash"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFlashButtonTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private lazy var capturePhotoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "circle.circle.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCaptureButtonTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    //MARK: - View Lifecycle
    init(type: UsingPickPhotoType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: CameraController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.setupCaptureSession()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(switchCamImageView)
        view.addSubview(flashImageView)
        view.addSubview(capturePhotoImageView)
        view.addSubview(backImageView)
        
        NSLayoutConstraint.activate([
            flashImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            flashImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            
            capturePhotoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -13),
            capturePhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            switchCamImageView.centerYAnchor.constraint(equalTo: capturePhotoImageView.centerYAnchor),
            switchCamImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -13),
            
            backImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            backImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
        flashImageView.setDimensions(width: 35, height: 30)
        capturePhotoImageView.setDimensions(width: 100, height: 100)
        switchCamImageView.setDimensions(width: 35, height: 40)
        backImageView.setDimensions(width: 30, height: 30)

    }
    
    func setupCaptureSession() {
        DispatchQueue.main.async {
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.setupInputs()
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
            self.setupOutput()
            
            self.captureSession.automaticallyConfiguresApplicationAudioSession = true
            self.captureSession.connections.first?.videoOrientation = .portrait
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    func setupInputs() {
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        self.backCamera = backCamera
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return
        }
        self.frontCamera = frontCamera
        
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            return
        }
        self.backInput = bInput
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            return
        }
        self.frontInput = fInput
        
        if captureSession.canAddInput(self.backInput) {
            captureSession.addInput(self.backInput)
        }
        
    }
    
    func setupOutput() {
        self.videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if self.captureSession.canAddOutput(videoOutput) {
            self.captureSession.addOutput(videoOutput)
        }
    }
    
    func setupPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
        previewLayer.frame = self.view.layer.frame
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    //MARK: - Selectors
    @objc func handleFlashButtonTapped() {
        
        self.captureSession.beginConfiguration()
        guard let _ = try? self.backCamera.lockForConfiguration() else {
            return
        }
        
        if !self.onFlash {
            self.flashImageView.image = UIImage(systemName: "bolt.fill")
            if self.backCamera.isTorchModeSupported(.on) && self.backCamera.isTorchAvailable && self.beingBackCamera {
                self.backCamera.torchMode = .on
                self.onFlash = true

            }
        
        } else {
            self.flashImageView.image = UIImage(systemName: "bolt.slash")

            if self.backCamera.isTorchModeSupported(.off) && self.backCamera.isTorchAvailable && self.backCamera.hasTorch {
                self.backCamera.torchMode = .off
                self.onFlash = false
            }

        }
        
        if !self.beingBackCamera {
            self.captureSession.removeInput(self.frontInput)
            if self.captureSession.canAddInput(self.backInput) {
                self.flashImageView.image = UIImage(systemName: "bolt.slash")
                self.captureSession.addInput(self.backInput)
                self.onFlash = false
            }
        }

        self.backCamera.unlockForConfiguration()
        self.beingBackCamera = true
        self.captureSession.commitConfiguration()
        
    }
    
    @objc func handleSwitchImageTapped() {
        self.captureSession.beginConfiguration()
        
        if self.beingBackCamera && self.onFlash {
            guard let _ = try? self.backCamera.lockForConfiguration() else {
                return
            }
            if self.backCamera.isTorchModeSupported(.off) {
                self.backCamera.torchMode = .off
            }
            self.flashImageView.image = UIImage(systemName: "bolt.slash")
            self.onFlash = false
            self.backCamera.unlockForConfiguration()
        }

        if self.beingBackCamera {
            self.captureSession.removeInput(self.backInput)
            if self.captureSession.canAddInput(self.frontInput) {
                self.captureSession.addInput(self.frontInput)
            }
            
        } else {
            self.captureSession.removeInput(self.frontInput)
            if self.captureSession.canAddInput(self.backInput) {
                self.captureSession.addInput(self.backInput)
            }
        }
        
        self.beingBackCamera = !self.beingBackCamera
        //Khi switch camera cần gắn lại
        self.captureSession.connections.first?.videoOrientation = .portrait
        self.captureSession.commitConfiguration()
        

    }
    
    @objc func handleCaptureButtonTapped() {
        self.isCapurePhoto = true
    }
    
    @objc func handleBackImageTapped() {
        navigationController?.popViewController(animated: true)

    }
    
}
//MARK: - delegate
extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !self.isCapurePhoto {
            return 
        }
        self.isCapurePhoto = false
        
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return}
        let uiImage = UIImage(cgImage: cgImage)
        
        DispatchQueue.main.async {
            let captureVC = CapturePhotoController(image: uiImage, type: self.type)
            captureVC.delegate = self
            self.navigationController?.pushViewController(captureVC, animated: false)
        }
  
    }
}

extension CameraController: CapturePhotoDelegate {
    func didSlectSaveButton(image: UIImage?) {
        self.delegate?.didCapturePhoto(image: image)
    }
}
