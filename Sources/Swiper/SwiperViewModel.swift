//
//  SwiftUIView.swift
//  
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

class SwiperViewModel: ObservableObject  {
    @Published
    var items: [Color]
    
    @Published
    var data: [SlideItem] = []
    
    @Published
    var nextData: [SlideItem] = []
    
    @Published
    var prevData: [SlideItem] = []
    
    var resource: [SlideItem] {
        get {
            if options.loop {
                return prevData + data + nextData
            }
            return data
        }
    }
    
    /// Độ rộng khung chứa
    @Published
    var canvasSize: CGFloat = .zero
    
    /// Độ rộng của toàn bộ slider
    /// Total = Total Card + Spacing
    var viewSize: CGFloat {
        get {
            if canvasSize == .zero {
                return .zero
            }
            
            return totalWidthElement() + totalSpacing()
        }
    }
    
    /// Size tối đa có thể cuộn theo chiều ngang
    /// Bằng tổng viewSize - 1 canvasSize
    var enableSize: CGFloat {
        get {
            return viewSize - widthPerSlide()
        }
    }
    
    /// Offset của slide
    @Published
    var primaryOffet: CGFloat = .zero
    
    /// Offset khi cuộn Drag...
    @Published
    var activeOffset: CGFloat = .zero
    
    var offset: CGFloat {
        get {
            return primaryOffet + activeOffset
        }
    }
    
    /// Index hiện tại của slide
    /// Nếu có nhiều hơn 1 element trên view => Lấy element phía leading
    var currentIndex: Int {
        get {
            
            if widthPerSlide() == .zero {
                return 0
            }
            
            if offset > 0 {
                return 0
            } else if offset < -viewSize {
                return resource.count
            } else {
                /// Mỗi element sẽ đi kèm với một padding, ngoại trừ element đầu tiên
                let ratio = abs((offset - options.spaceBetween) / (widthPerSlide() + options.spaceBetween))
                return Int(round(ratio))
            }
        }
    }
    
    @Published
    var options: SwiperOptions
    
    // Auto Play
    var debounceNext:Timer?
    
    init(_ data: [Color], options: SwiperOptions) {
        self.items = data
        self.options = options
    }
    
    /// Setup after render container
    func setup() -> Void {
        data = cloneData()
        
        setFitSize()
        
        if options.loop {
            prevData.append(contentsOf: data)
            let newIndex = data.count + currentIndex
            primaryOffet = -offsetForSlide(newIndex)
        }
        
        if options.autoPlay {
            enableAutoPlay()
        }
    }
    
}

struct Sho2_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Swiper(
                [.blue, .gray, .orange],
                options: SwiperOptions(spaceBetween: 10, slidesPerView: 4)
            )
            .padding(.horizontal)
            // .frame(height: 250)
            
        }
        .frame(maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}

