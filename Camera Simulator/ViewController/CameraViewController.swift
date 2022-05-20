//
//  CameraViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 11/05/22.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate & UIPickerViewDelegate & UIPickerViewDataSource {
    
    
    @IBOutlet weak var trianglePicker: UIPickerView!
    @IBOutlet weak var apertureSlider: UISlider!
    
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var apertureButton: UIButton!
    @IBOutlet weak var isoButton: UIButton!

    @IBOutlet weak var shutterControl: UISegmentedControl!
    @IBOutlet weak var isoControl: UISegmentedControl!
    @IBOutlet weak var apertureControl: UISegmentedControl!
    
    @IBOutlet weak var isoLabel: UILabel!
    @IBOutlet weak var apertureLabel: UILabel!
    @IBOutlet weak var shutterLabel: UILabel!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var zoomLabel: UILabel!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var camera: ManualCamera!
    var guideRulerLayer: CAShapeLayer!
    var focusLayer: CAShapeLayer!
    var authorized: Bool!
    var isShowGuideRuller = false
    var isHiddenShutteer = true
    var isHiddenIso = true
    var isHiddenAperture = true
    
    var isoData: [Float] = [Float]()
    var shutterData: [CMTime] = [CMTime]()
    
    private func authorizeCameraUsage(_ completionHandler: @escaping((_ success: Bool) -> Void)) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            DispatchQueue.main.async {
                completionHandler(granted)
            }
        }
    }
    private func authorizePhotoLibraryUsage(_ completionHandler: @escaping((_ success: Bool) -> Void)) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                completionHandler(status == .authorized)
            }
        }
    }
    private func failAndExit(message: String) {
        let alert = UIAlertController(title: "Initialization Error!", message: message, preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(exitAction)
        present(alert, animated: true, completion: nil)
    }
}


//ovveride function
extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let showOnboarding = UserDefaults.standard.bool(forKey: showOnBoard)
        if !showOnboarding {
            let onBoardingVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: onBoardVCId) as! OnBoardingViewController
            
            onBoardingVC.modalPresentationStyle = .overCurrentContext
            present(onBoardingVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if camera != nil {
            camera.start()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if camera != nil {
            camera.stop()
        }
    }
}


//Custom Function
extension CameraViewController: UIGestureRecognizerDelegate {
    
    private func initCamera() {
        authorized = (AVCaptureDevice.authorizationStatus(for: .video) == .authorized) && (PHPhotoLibrary.authorizationStatus() == .authorized)
        
        if !authorized {
            authorizeCameraUsage { (success) in
                if success {
                    self.authorizePhotoLibraryUsage({ (success) in
                        if success {
                            self.authorized = true
                        } else {
                            self.authorized = false
                            self.failAndExit(message: "Failed to authorize photo library usage.\nPlease quit application.")
                        }
                    })
                } else {
                    self.authorized = false
                    self.failAndExit(message: "Failed to authorize camera usage.\nPlease quit application.")
                }
            }
        } else {
            camera = ManualCamera()
            camera.setDelegate(self)
            setupSubViews()
            setupPreviewLayer()
        }
    }
    
    private func setupSubViews() {
        apertureSlider.isHidden = isHiddenAperture
        
        apertureControl.isHidden = true
        isoControl.isHidden = true
        shutterControl.isHidden = true
        
        trianglePicker.isHidden = true
        trianglePicker.isUserInteractionEnabled = false
        
        if previewLayer != nil {
            layoutPreviewLayer()
        }
        
        zoomLabel.text = "x".appendingFormat("%.1f", camera.zoomFactor())
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doFocus(_:)))
        tapGesture.delegate = self
        previewView.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(doZoom(_:)))
        pinchGesture.delegate = self
        previewView.addGestureRecognizer(pinchGesture)
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: camera.captureSession)
        previewLayer.backgroundColor = UIColor.black.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer)
    }
    
    private func layoutPreviewLayer() {
        previewLayer.frame = previewView.bounds

        if let conn = previewLayer.connection {
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                conn.videoOrientation = .landscapeRight
                break
            case .landscapeRight:
                conn.videoOrientation = .landscapeLeft
                break
            case .portrait:
                conn.videoOrientation = .portrait
                break
            case .portraitUpsideDown:
                conn.videoOrientation = .portraitUpsideDown
                break
            default: break
            }
        }
    }
    
    private func showGuideRuler(isShow: Bool, previewLayer: AVCaptureVideoPreviewLayer) {
        if !isShow {
            if guideRulerLayer != nil {
                guideRulerLayer.removeFromSuperlayer()
                guideRulerLayer = nil
            }
        } else {
            
            guideRulerLayer = CAShapeLayer()
            guideRulerLayer.frame = previewLayer.superlayer!.bounds
            previewLayer.superlayer!.insertSublayer(guideRulerLayer, above: previewLayer)
            let rect = previewLayer.frame
            let linePath = UIBezierPath()
            linePath.lineWidth = 1.0
            
            linePath.move(to: CGPoint(x: 0, y: rect.height / 3))
            linePath.addLine(to: CGPoint(x: rect.width, y: rect.height / 3))
            
            linePath.move(to: CGPoint(x: 0, y: rect.height / 1.5))
            linePath.addLine(to: CGPoint(x: rect.width, y: rect.height / 1.5))
            
            linePath.move(to: CGPoint(x: rect.width / 3, y: 40))
            linePath.addLine(to: CGPoint(x: rect.width / 3, y: rect.height - 50))
            
            linePath.move(to: CGPoint(x: rect.width / 1.5, y: 40))
            linePath.addLine(to: CGPoint(x: rect.width / 1.5, y: rect.height - 50))
            
            guideRulerLayer.path = linePath.cgPath
            guideRulerLayer.strokeColor = UIColor(named: "blue")?.cgColor
        }
    }
    
    private func photosLib() {
    //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
             imagePicker.delegate = self
             imagePicker.sourceType = .photoLibrary;
             imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
         }
    }
    
    private func showFocus(at point: CGPoint) {
        if focusLayer == nil {
            focusLayer = CAShapeLayer()
            focusLayer.frame = previewLayer.bounds
            focusLayer.strokeColor = UIColor.orange.cgColor
            
            let rectPath = UIBezierPath()
            rectPath.lineWidth = 1.0
            rectPath.move(to: CGPoint(x: point.x - 30, y: point.y - 30))
            rectPath.addLine(to: CGPoint(x: point.x + 30, y: point.y - 30))
            rectPath.move(to: CGPoint(x: point.x + 30, y: point.y - 30))
            rectPath.addLine(to: CGPoint(x: point.x + 30, y: point.y + 30))
            rectPath.move(to: CGPoint(x: point.x + 30, y: point.y + 30))
            rectPath.addLine(to: CGPoint(x: point.x - 30, y: point.y + 30))
            rectPath.move(to: CGPoint(x: point.x - 30, y: point.y + 30))
            rectPath.addLine(to: CGPoint(x: point.x - 30, y: point.y - 30))
            focusLayer.path = rectPath.cgPath
            
            let baseLayer = guideRulerLayer == nil ? previewLayer : guideRulerLayer
            baseLayer?.superlayer!.insertSublayer(focusLayer, above: baseLayer)
        }
    }
    
    private func doAutoFocus(at point: CGPoint) {
        camera.autoFocus(at: point)
    }
    
    private func hideFocus() {
        if focusLayer != nil {
            focusLayer.removeFromSuperlayer()
            focusLayer = nil
        }
    }
    
    @objc func doFocus(_ gestureRecognizer: UITapGestureRecognizer) {
        if camera.focusMode == .auto {
            let touchPoint = gestureRecognizer.location(ofTouch: 0, in: previewView)
            if touchPoint.x < 30 || touchPoint.x > (previewView.frame.size.width - 30) || touchPoint.y < 30 || touchPoint.y > (previewView.frame.size.height - 30) {
                return
            }
            let point = CGPoint(x: touchPoint.x / previewView.frame.size.width, y: touchPoint.y / previewView.frame.size.width)
            showFocus(at: touchPoint)
            doAutoFocus(at: point)
        }
    }
    
    @objc func doZoom(_ gestureRecognizer: UIPinchGestureRecognizer) {
        let pinchZoomScale = gestureRecognizer.scale
        camera.zoom(pinchZoomScale, end: gestureRecognizer.state == .ended) { (zoomFactor) -> (Void) in
            self.zoomLabel.text = "x".appendingFormat("%.1f", Float(zoomFactor))
        }
    }
    
    private func setupIsoPicker() {
        if !isHiddenShutteer {
            setupShutterPicker()
        }else if (!isHiddenAperture) {
            setupApertureSlider()
        }
        
        shutterData.removeAll()
        self.trianglePicker.delegate = self
        self.trianglePicker.dataSource = self
        isoData = (CameraConstants.IsoValues)
        
        isHiddenIso.toggle()
        trianglePicker.isHidden = isHiddenIso
        isoControl.isHidden = isHiddenIso
        isoButton.setImage(UIImage(named: isHiddenIso ? "ic_iso" : "ic_iso_selected"), for: .normal)
    }
    
    private func setupApertureSlider() {
        if !isHiddenIso {
            setupIsoPicker()
        }else if (!isHiddenShutteer) {
            setupShutterPicker()
        }
        
        isHiddenAperture.toggle()
        apertureSlider.isHidden = isHiddenAperture
        apertureControl.isHidden = isHiddenAperture
        apertureButton.setImage(UIImage(named: isHiddenAperture ? "ic_aperture" : "ic_aperture_selected"), for: .normal)
        
        apertureSlider.isEnabled = camera.focusMode == .manual
        apertureSlider.minimumTrackTintColor = apertureSlider.isEnabled ? UIColor.orange : UIColor.gray
        apertureSlider.maximumTrackTintColor = apertureSlider.isEnabled ? UIColor.orange : UIColor.gray
        apertureSlider.thumbTintColor = apertureSlider.isEnabled ? UIColor.orange : UIColor.gray
        apertureSlider.value = camera.lensPosition()
    }
    
    private func setupShutterPicker() {
        if !isHiddenIso {
            setupIsoPicker()
        }else if (!isHiddenAperture) {
            setupApertureSlider()
        }
        
        isoData.removeAll()
        self.trianglePicker.delegate = self
        self.trianglePicker.dataSource = self
        shutterData = CameraConstants.ExposureDurationValues
        
        isHiddenShutteer.toggle()
        trianglePicker.isHidden = isHiddenShutteer
        shutterControl.isHidden = isHiddenShutteer
        shutterButton.setImage(UIImage(named: isHiddenShutteer ? "ic_shutter" : "ic_shutter_selected"), for: .normal)
    }
}


//view Click
extension CameraViewController {
    @IBAction func btnLearning(_ sender: Any) {
        let destinationVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: learningVcId) as! LearningViewController
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func takeButton(_ sender: Any) {
        let orientation = previewLayer.connection?.videoOrientation
        camera.takePhoto(orientation: orientation!)
    }
    
    @IBAction func showGuideRuller(_ sender: Any) {
        isShowGuideRuller.toggle()
        showGuideRuler(isShow: isShowGuideRuller, previewLayer: previewLayer)
    }
    
    @IBAction func photosLibButton(_ sender: Any) {
        photosLib()
    }
    
    
    @IBAction func shutterButton(_ sender: Any) {
        setupShutterPicker()
    }
    
    @IBAction func isoButton(_ sender: Any) {
        setupIsoPicker()
    }
    
    @IBAction func apertureButton(_ sender: Any) {
        setupApertureSlider()
    }
    
    
    @IBAction func apertureSlider(_ sender: Any) {
        hapticButton(type: 4)

        camera.manualFocus(lensPosition: apertureSlider.value) { () -> (Void) in
            self.apertureLabel.text = "".appendingFormat("f %.2f", self.camera.lensPosition())
        }
    }
    
    
    @IBAction func apertureControl(_ sender: Any) {
        hapticButton(type: 5)
        
        camera.focusMode = CameraFocusMode(rawValue: apertureControl.selectedSegmentIndex)!
        apertureSlider.isEnabled = camera.focusMode == .manual
        apertureSlider.thumbTintColor = apertureSlider.isEnabled ? UIColor(named: "blue") : UIColor.gray
        apertureSlider.value = camera.lensPosition()
        if camera.focusMode == .auto {
            doAutoFocus(at: CGPoint(x: 0.5, y: 0.5))
        }
    }
    
    @IBAction func isoControl(_ sender: Any) {
        hapticButton(type: 5)
        
        if isoControl.selectedSegmentIndex == 0 {
            camera.isoMode = .auto
            trianglePicker.isUserInteractionEnabled = false
        }else {
            camera.isoMode = .manual
            trianglePicker.isUserInteractionEnabled = true
        }
        
        isoLabel.text = "".appendingFormat("%.0f", camera.iso())
    }
    
    @IBAction func shutterControl(_ sender: Any) {
        hapticButton(type: 5)
        
        if shutterControl.selectedSegmentIndex == 0 {
            camera.shutterMode = .auto
            trianglePicker.isUserInteractionEnabled = false
        }else {
            camera.shutterMode = .manual
            trianglePicker.isUserInteractionEnabled = true
        }
        
        shutterLabel.text = camera.exposureDurationLabel()
    }
}


//camera
extension CameraViewController: CameraDelegate {
    
    func cameraDidFinishFocusing(_ camera: Camera, device: AVCaptureDevice) {
        hideFocus()
        apertureSlider.value = device.lensPosition
        apertureLabel.text = "".appendingFormat("f %.2f", device.lensPosition)
    }
    
    func cameraDidFinishExposing(_ camera: Camera, device: AVCaptureDevice) {
        if self.camera.shutterMode == .auto {
            shutterLabel.text = self.camera.exposureDurationLabel()
            self.camera.shutterSpeedValue = self.camera.exposureDuration()
        }
        if self.camera.isoMode == .auto {
            isoLabel.text = "".appendingFormat("%.0f", self.camera.iso())
            self.camera.isoValue = self.camera.iso()
        }
        
        if !isoData.isEmpty {
            let selecIndex = isoData.firstIndex(of: camera.iso())
            trianglePicker.selectRow(selecIndex ?? 4, inComponent: 0, animated: true)
        } else if !shutterData.isEmpty {
            let selecIndex = shutterData.firstIndex(of: self.camera.exposureDuration())
            trianglePicker.selectRow(selecIndex ?? 4, inComponent: 0, animated: true)
        }
    }
    
    func cameraWillSavePhoto(_ camera: Camera, photo: AVCapturePhoto) -> Data? {
        return photo.fileDataRepresentation()
    }
}


//uipickerview
extension CameraViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return !isoData.isEmpty ? isoData.count : shutterData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return !isoData.isEmpty ? isoData[row].clean : CameraConstants.ExposureDurationLabels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !isoData.isEmpty {
            camera.isoValue = isoData[row]
        } else if !shutterData.isEmpty {
            camera.shutterSpeedValue = shutterData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "", size: 6)
            pickerLabel?.textAlignment = .center
        }
        
        if !isoData.isEmpty {
            pickerLabel?.text = isoData[row].clean
        } else if !shutterData.isEmpty {
            pickerLabel?.text = CameraConstants.ExposureDurationLabels[row]
        }
        
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }
}
