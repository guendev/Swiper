//
//  SwiftUIView.swift
//
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

/// Size
extension SwiperViewModel {
    
    func setFitSize() -> Void {
        if options.fitSize {
            
            if CGFloat(data.count) < options.slidesPerView {
                options.slidesPerView = CGFloat(data.count)
            }
            
        }
    }
    
    /// Độ rộng của mỗi slide
    func widthPerSlide() -> CGFloat {
        let _width = canvasSize / options.slidesPerView
        let _spaces = (options.slidesPerView - 1) * options.spaceBetween
        return _width - _spaces / options.slidesPerView
    }
    
    // Offset cho ZStack
    func offsetForSlide(_ index: Int) -> CGFloat {
        let _index = CGFloat(index)
        let tranfromX = widthPerSlide() * _index
        let tranformSpace = (_index) * options.spaceBetween
        return tranfromX + tranformSpace
    }
}
