//
//  PreviewViewController.swift
//  RB67
//
//  Created by Jiayun Li on 2/22/19.
//  Copyright © 2019 Jiayun Li. All rights reserved.
//

import UIKit
import CoreImage

class PreviewViewController: UIViewController {

    struct Filter {
        let filterName: String
        var filterEffectValue: Any?
        var filterEffectValueName: String?
        
        init(filterName: String, fliterEffectValue: Any?, filterEffectValueName: String? ){
            self.filterName = filterName
            self.filterEffectValue = fliterEffectValue
            self.filterEffectValueName = filterEffectValueName
        }
    }
    
    @IBOutlet weak var photo: UIImageView!
    
    var filterSelectedForDevelop = "Vintage" // <<-- default filter to avoid error
    
    var image: UIImage!
    var originalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        originalImage = image
        
        print("Initing \(filterSelectedForDevelop) as filter")
        autoApplyFilter()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let savedAlert = UIAlertController(title: "Image Saved", message: "Image Saved Successfully", preferredStyle: .alert)
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .default) {(UIAlertAction) in self.dismiss(animated: true, completion: nil)
        }
        
        savedAlert.addAction(cancelAlertAction)
        present(savedAlert,animated: true, completion: nil)
        
    }
    
    private func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        
        guard let cgImage = image.cgImage, let openGLContext = EAGLContext(api: .openGLES3) else {
            return nil
        }
        
        let context = CIContext(eaglContext: openGLContext)
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filterEffectValue = filterEffect.filterEffectValue,
            let filterEffterValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffterValueName)
        }
        
        var filteredImage: UIImage?
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
            let cgiImageResult = context.createCGImage(output, from: output.extent){
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        
        return filteredImage
        
    }
    
    
    
    func autoApplyFilter(){
        
        if filterSelectedForDevelop == "Vintage"{
            
            image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CISepiaTone", fliterEffectValue: 0.70, filterEffectValueName: kCIInputIntensityKey))
            photo.image = image
            
        } else if filterSelectedForDevelop == "Modern"{
            
            image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectProcess", fliterEffectValue: nil, filterEffectValueName: nil))
            photo.image = image
            
        } else if filterSelectedForDevelop == "B&W" {
            
            image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectNoir", fliterEffectValue: nil, filterEffectValueName: nil))
            photo.image = image
            
        }
        
    }
    
    
    
    @IBAction func applySepiaButtonPressed(_ sender: Any) {
        
        image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CISepiaTone", fliterEffectValue: 0.70, filterEffectValueName: kCIInputIntensityKey))
        photo.image = image
        
    }
    
    @IBAction func applyBlurButtonPresed(_ sender: Any) {
        
    }
    
    @IBAction func applyNoirButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func applyProcessEffectButtonPressed(_ sender: Any) {
        
        image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectProcess", fliterEffectValue: nil, filterEffectValueName: nil))
        photo.image = image
        
    }
    
    @IBAction func clearFilter(_ sender: Any) {
        
        image = originalImage
        photo.image = image
        
    }
    
    
    
    /* 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
