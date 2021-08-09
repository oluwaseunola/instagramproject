//
//  CameraViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//
import SDWebImage
import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    
    private var output = AVCapturePhotoOutput()
    
    private var captureSession : AVCaptureSession?
    
    let cameraView = UIView()
    
    let captureButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.backgroundColor = UIColor.white
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureNavBar()
        checkCameraPermission()
        view.addSubview(cameraView)
        view.addSubview(captureButton)
        captureButton.addTarget(self, action: #selector(didTapCapture), for: .touchUpInside)

       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        if let session = captureSession, !session.isRunning{
            session.startRunning()
        }
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
    
    private func configureNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didCloseCamera))
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func checkCameraPermission(){
        
        switch AVCaptureDevice.authorizationStatus(for: .video){
       
        case .authorized:
            setUpCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {[weak self] granted in
                if granted{
                    DispatchQueue.main.async {
                        self?.setUpCamera()

                    }
                }
            }
        case .restricted:
            break
        case .denied:
            break
        
        @unknown default:
            break
        }
        
    }
    
    private func setUpCamera(){
        
        let captureSession = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video){
            do{
                if let videoInput = try? AVCaptureDeviceInput(device: device){
                    
                    if captureSession.canAddInput(videoInput){
                        captureSession.addInput(videoInput)
                    }
                }
                
            }
            catch{
                print(error)
            }
            
            if captureSession.canAddOutput(output){
                captureSession.addOutput(output)
            }
            
            let layer = AVCaptureVideoPreviewLayer()
            
            layer.session = captureSession
            layer.videoGravity = .resizeAspectFill
            layer.frame = view.layer.bounds
            
            cameraView.layer.addSublayer(layer)
            
            captureSession.startRunning()
            

            
        }
    }

    
    @objc func didCloseCamera(){
        
        tabBarController?.tabBar.isHidden = false
        
        tabBarController?.selectedIndex = 0
    }
    
    @objc func didTapCapture(){
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraView.frame = view.bounds
        let buttonSize : CGFloat = view.width/4
        captureButton.frame = CGRect(x:(view.width-buttonSize)/2, y: (view.height-200), width: buttonSize, height: buttonSize)
        captureButton.layer.cornerRadius = buttonSize/2
        
    }
    
    

}

extension CameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let photoData = photo.fileDataRepresentation() else{return}
        guard let image = UIImage(data: photoData) else{return}
        
        guard let editedPhoto = image.sd_resizedImage(with: CGSize(width: 640, height: 640), scaleMode: .aspectFill) else{return}
        let editor = PhotoEditViewController(image: editedPhoto)
        navigationController?.pushViewController(editor, animated: false)
    }
}
 
