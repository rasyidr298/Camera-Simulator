//
//  CameraViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 11/05/22.
//

import UIKit
import Photos

class CameraViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var afSlider: UISlider!
    @IBOutlet weak var isoSlider: UISlider!
    
    private var listBackgroundImage = [UIImage(named: "bg_test1"), UIImage(named: "bg_test2"), UIImage(named: "bg_test3")]
    private var listObjectImage = [UIImage(named: "bg_test2"), UIImage(named: "bg_test1"), UIImage(named: "bg_test2")]
    private var indexImage = 0
    private var transition = CATransition()
    
    private let colorFilter = CIFilter(name: "CIColorControls")!
    private let blurFilter = CIFilter(name: "CIGaussianBlur")!
    var context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateImageView(type: "next")
        setupView()
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
}

extension CameraViewController {
    
    func animateImageView(type: String) {
        switch type {
        case "next" :
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
        case "previous" :
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
        default:
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
        }
        
        backgroundImage.layer.add(transition, forKey: kCATransition)
        objectImage.layer.add(transition, forKey: kCATransition)
        
        if listBackgroundImage.count != 0 {
            backgroundImage.image = listBackgroundImage[indexImage]
            objectImage.image = listObjectImage[indexImage]
        }
        CATransaction.commit()
        indexImage = indexImage < listBackgroundImage.count - 1 ? indexImage + 1 : 0
    }
    
    func setTriangleExpose(_ image: UIImage) -> UIImage? {
        guard let colorControls = CIFilter(name: "CIColorControls"), let blurControls = CIFilter(name: "CIGaussianBlur") else {return nil}
        
        guard let cgImage = image.cgImage else {return image}
        let ciImage = CIImage(cgImage: cgImage)
        
        //brightness
        colorControls.setValue(ciImage, forKey: "inputImage")
        colorControls.setValue(isoSlider.value, forKey: "inputBrightness")
        guard let imageWithFirstFilter = colorControls.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        //blurr
        blurControls.setValue(imageWithFirstFilter, forKey: kCIInputImageKey)
        blurControls.setValue(afSlider.value, forKey: kCIInputRadiusKey)
        guard let imageWithSecondFilter = blurControls.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        let bounds = CGRect(origin: CGPoint.zero, size: image.size)
        guard let outputCGImage = context.createCGImage(imageWithSecondFilter, from: bounds) else {return image}
        
        return UIImage(cgImage: outputCGImage)
    }
    
    
    private func savePhoto(){
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else{
                return
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: self.listBackgroundImage[self.indexImage]!)
            }) { (success, error) in
                if let error = error {
                    print("Error saving photo \(error)")
                    return
                }
                print("Saved photo successfully")
            }
        }
    }
    
    private func setupView() {
        afSlider.value = 2
        afSlider.minimumValue = 2
        afSlider.maximumValue = 10
        
        isoSlider.value = 0.0
        isoSlider.minimumValue = 0.0
        isoSlider.maximumValue = 0.6
    }
    
    private func updateView(){
        if let originalImage = listBackgroundImage[indexImage] {
            backgroundImage.image = setTriangleExpose(originalImage)
        } else {
            backgroundImage.image = nil
        }
    }
}


extension CameraViewController {
    
    @IBAction func btnNext(_ sender: Any) {
        animateImageView(type: "next")
        setupView()
    }
    
    @IBAction func btnPrevious(_ sender: Any) {
        animateImageView(type: "previous")
        setupView()
    }
    
    @IBAction func btnLearning(_ sender: Any) {
        let destinationVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: learningVcId) as! LearningViewController
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func afSlider(_ sender: Any) {
        updateView()
        print("af slider -> \(afSlider.value)")
    }
    
    @IBAction func isoSlider(_ sender: Any) {
        updateView()
        print("iso slider -> \(isoSlider.value)")
    }
}
