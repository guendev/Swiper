//
//  SwiftUIView.swift
//
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

/// Size
extension SwiperViewModel {
    func widthPerSlide() -> CGFloat {
        let _width = canvasSize / options.slidesPerView
        let _spaces = (options.slidesPerView - 1) * options.spaceBetween
        return _width - _spaces / options.slidesPerView
    }
    
    func totalWidthElement() -> CGFloat {
        return CGFloat(resource.count) * widthPerSlide()
    }
    
    func totalSpacing() -> CGFloat {
        return CGFloat(resource.count - 1) * options.spaceBetween
    }
    
    func offsetForSlide(_ index: Int) -> CGFloat {
        let _index = CGFloat(index)
        let tranfromX = widthPerSlide() * _index
        let tranformSpace = (_index) * options.spaceBetween
        return tranfromX + tranformSpace
    }
}

struct Sho6_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Swiper(
                [.blue, .gray, .orange, .yellow],
                options: SwiperOptions(spaceBetween: 10, slidesPerView: 1)
            )
            .padding(.horizontal)
            // .frame(height: 250)
            
        }
        .frame(maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}

