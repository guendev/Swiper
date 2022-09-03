//
//  SwiftUIView.swift
//  
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

class SwiperViewModel: ObservableObject  {
    
    @Published
    var data: [Color]
    
    @Published
    var cloneData: [Color] = []
    
    var resource: [Color] {
        get {
            if options.loop {
                return data + cloneData
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
            
            return totalWidthElement() + totalSpaces()
        }
    }
    
    /// Size tối đa có thể cuộn theo chiều ngang
    /// Bằng tổng viewSize - 1 canvasSize
    var enableSize: CGFloat {
        get {
            return viewSize - canvasSize
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
            
            if widthPerElement() == .zero {
                return 0
            }
            
            if offset > 0 {
                return 0
            } else if offset < -viewSize {
                return data.count
            } else {
                let ratio = abs(offset / widthPerElement())
                return Int(ratio)
            }
        }
    }
    
    @Published
    var options: SwiperOptions
    
    // Auto Play
    var debounceNext:Timer?
    
    init(_ data: [Color], options: SwiperOptions) {
        self.data = data
        self.options = options
    }
    
}

/// Size
extension SwiperViewModel {
    func widthPerElement() -> CGFloat {
        return canvasSize / options.slidesPerView
    }
    
    func totalWidthElement() -> CGFloat {
        return CGFloat(data.count) * widthPerElement()
    }
    
    func totalSpaces() -> CGFloat {
        return CGFloat(data.count - 1) * options.spacing
    }
    
    func offsetForItem(_ index: Int) -> CGFloat {
        let _index = CGFloat(index)
        let tranfromX = widthPerElement() * _index
        let tranformSpace = (_index) * options.spacing
        return tranfromX + tranformSpace
    }
}

/// Drag
extension SwiperViewModel {
    func onDrag(x: CGFloat) -> Void {
        activeOffset = x
    }
    
    func afterDrag() -> Void {
        primaryOffet += activeOffset
        activeOffset = .zero
        
        // Kéo cuộn về phía leading
        if offset > 0 {
            toOffset(.zero)
        } else if offset < -enableSize {
            toOffset(-enableSize)
        } else {
            // Các trường hợp còn lại => cuộn về index gần nhất
            toIndex(currentIndex)
        }
    }
}

// Navigation
extension SwiperViewModel {
    func toOffset(_ to: CGFloat) {
        withAnimation {
            primaryOffet = to
        }
    }
    
    func toIndex(_ to: Int) -> Void {
        toOffset(-offsetForItem(to))
    }
    
    /// Tiến tới slide tiếp theo
    // Nếu offset < enableSize => true/false
    // true =>
    func toNext() -> Void {
        
    }
    
    func toPrev() -> Void {
        
    }
}

// AutoPlay
extension SwiperViewModel {
    func setAutoPlay() -> Void {
        debounceNext?.invalidate()
        debounceNext = nil
        debounceNext = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {  _ in
        }
    }
}

struct SwiperOptions {
    internal init(spacing: CGFloat = .zero, slidesPerView: CGFloat = 1, autoPlay: Bool = false, loop: Bool = false, initIndex: Int = 0) {
        self.spacing = spacing
        self.slidesPerView = slidesPerView
        self.autoPlay = autoPlay
        self.loop = loop
        self.initIndex = initIndex
    }
    
    var spacing: CGFloat = .zero
    var slidesPerView: CGFloat = 1
    
    var autoPlay: Bool = false
    var loop: Bool = false
    
    var initIndex: Int = 0
}

struct Sho2_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Swiper(
                [.blue, .gray, .orange, .green, .yellow],
                options: SwiperOptions(spacing: 20, slidesPerView: 1.5, loop: true)
            )
            .padding(.horizontal)
            // .frame(height: 250)
            
        }
        .frame(maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}

