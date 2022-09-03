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
    var nextData: [Color] = []
    
    @Published
    var prevData: [Color] = []
    
    var resource: [Color] {
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
                return resource.count
            } else {
                /// Mỗi element sẽ đi kèm với một padding, ngoại trừ element đầu tiên
                let ratio = abs((offset - options.spacing) / (widthPerElement() + options.spacing))
                return Int(round(ratio))
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
    
    func setup() -> Void {
        if options.loop {
            prevData.append(contentsOf: data)
            let newIndex = data.count + currentIndex
            primaryOffet = -offsetForItem(newIndex)
        }
        
        if options.autoPlay {
            enableAutoPlay()
        }
    }
    
}

/// Size
extension SwiperViewModel {
    func widthPerElement() -> CGFloat {
        let _width = canvasSize / options.slidesPerView
        let _spaces = (options.slidesPerView - 1) * options.spacing
        return _width - _spaces / options.slidesPerView
    }
    
    func totalWidthElement() -> CGFloat {
        return CGFloat(resource.count) * widthPerElement()
    }
    
    func totalSpaces() -> CGFloat {
        return CGFloat(resource.count - 1) * options.spacing
    }
    
    func offsetForItem(_ index: Int) -> CGFloat {
        let _index = CGFloat(index)
        let tranfromX = widthPerElement() * _index
        let tranformSpace = (_index) * options.spacing
        return tranfromX + tranformSpace
    }
}

// Navigation
extension SwiperViewModel {
    func onDrag(x: CGFloat) -> Void {
        
        // if options.bounce {
            activeOffset = x
//        } else {
//            //
//        }
        
        cloneNext()
        clonePrev(step: 1)
        
        if options.autoPlay {
            disableAutoPlay()
        }
        
    }
    
    func afterDrag() -> Void {
        primaryOffet += activeOffset
        activeOffset = .zero
        
        if options.loop {
            toIndex(currentIndex)
        } else {
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
        
        if options.autoPlay {
            enableAutoPlay()
        }
    }
    
    func toOffset(_ to: CGFloat) {
        withAnimation {
            primaryOffet = to
        }
    }
    
    func toIndex(_ to: Int) -> Void {
        toOffset(-offsetForItem(to))
    }
    
    func cloneNext() -> Void {
        if options.loop {
            if (currentIndex + 1) + data.count >= resource.count - 1 {
                nextData.append(contentsOf: data)
            }
            
        }
    }
    
    /// Tiến tới slide tiếp theo
    func toNext() -> Void {
        // Nếu Clone => cloneNext
        cloneNext()
        
        // Nằm trong khoảng có thể next
        if currentIndex < resource.count - 1 {
            return toIndex(currentIndex + 1)
        } else {
            toIndex(0)
        }
    }
    
    func clonePrev(step: Int = 0) {
        // Clone => push to clonePrev
        if options.loop {
            if currentIndex == data.count - 1 {
                prevData.append(contentsOf: data)
                
                // khi append => làm thay đổi currentIndex => toIndex sẽ bị sai
                // Thay đổi offset mà ko dùng animation
                let newIndex = data.count + currentIndex
                primaryOffet = -offsetForItem(newIndex + step)
            }
        }
    }
    
    func toPrev() -> Void {
        
        // Kiểm tra và clone Prev
        clonePrev()

        if currentIndex > 0 {
            return toIndex(currentIndex - 1)
        }
    }
}

// AutoPlay
extension SwiperViewModel {
    func enableAutoPlay() -> Void {
        disableAutoPlay()
        debounceNext = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self]  _ in
            self?.toNext()
        }
    }
    
    func disableAutoPlay() -> Void {
        debounceNext?.invalidate()
        debounceNext = nil
    }
}

struct SwiperOptions {
    // Khoảng cách giữa các element
    var spacing: CGFloat = .zero
    // Số slide/màn hình
    var slidesPerView: CGFloat = 1
    
    // Tự động play
    var autoPlay: Bool = false
    // Tự động clone. Infinity
    var loop: Bool = false
    
    // Slide bắt đầu
    var initIndex: Int = 0
}

struct Sho2_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Swiper(
                [.blue, .gray, .orange, .yellow],
                options: SwiperOptions(spacing: 10, slidesPerView: 2.5, autoPlay: false, loop: true)
            )
            .padding(.horizontal)
            // .frame(height: 250)
            
        }
        .frame(maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}

