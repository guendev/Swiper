//
//  SwiftUIView.swift
//  
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

class SwiperViewModel<Data>: ObservableObject where Data: RandomAccessCollection {
    typealias Item = SlideItem<Data>
    
    @Published
    var items: Data
    
    @Published
    var data: [Item] = []
    
    @Published
    var nextData: [Item] = []
    
    @Published
    var prevData: [Item] = []
    
    var resource: [Item] {
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
            
            return slidesWidth + slidesSpacing
        }
    }
    
    /// Size tối đa có thể cuộn theo chiều ngang
    /// Bằng tổng viewSize - 1 canvasSize
    var enableSize: CGFloat {
        get {
            return viewSize - slideWidth
        }
    }
    
    /// Offset của slide
    @Published
    var primaryOffet: CGFloat = .zero
    
    /// Offset khi cuộn Drag...
    @Published
    var activeOffset: CGFloat = .zero
    
    // Offset thực tế
    var offset: CGFloat {
        get {
            return primaryOffet + activeOffset
        }
    }
    
    /// Size
    var slideWidth: CGFloat {
        get {
            
            if canvasSize == .zero {
                return .zero
            }
            
            let _width = canvasSize / options.slidesPerView
            let _spaces = (options.slidesPerView - 1) * options.spaceBetween
            return _width - _spaces / options.slidesPerView
        }
    }
    
    var slidesWidth: CGFloat {
        get {
            return CGFloat(resource.count) * slideWidth
        }
    }
    
    var slidesSpacing: CGFloat {
        get {
            return CGFloat(resource.count - 1) * options.spaceBetween
        }
    }
    
    /// Index hiện tại của slide
    /// Nếu có nhiều hơn 1 element trên view => Lấy element phía leading
    var currentIndex: Int {
        get {
            
            if slideWidth == .zero {
                return 0
            }
            
            if offset > 0 {
                return 0
            } else if offset < -viewSize {
                return resource.count
            } else {
                /// Mỗi element sẽ đi kèm với một padding, ngoại trừ element đầu tiên
                let ratio = abs((offset - options.spaceBetween) / (slideWidth + options.spaceBetween))
                return Int(round(ratio))
            }
        }
    }
    
    @Published
    var options: SwiperOptions
    
    // Auto Play
    var debounceNext:Timer?
    
    init(_ data: Data, options: SwiperOptions) {
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
        
        toSlide(options.initialSlide)
    }
    
}
