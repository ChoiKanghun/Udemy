//
//  FilterService.swift
//  CameraFilterRxSwift
//
//  Created by 최강훈 on 2021/05/19.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { (observer) in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
                
            }
            return Disposables.create()
        }
    }
    
    // escaping is called after applyingFilter
    private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            if let cgImage = self.context.createCGImage(
                filter.outputImage!,
                from: filter.outputImage!.extent) {
                
                let processdImage
                    = UIImage(cgImage: cgImage,
                              scale: inputImage.scale,
                              orientation: inputImage.imageOrientation)
                completion(processdImage)
            }
        }
    }
}
