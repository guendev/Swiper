//
//  SwiftUIView.swift
//
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

// Darg
extension SwiperViewModel {
    func onDrag(x: CGFloat) -> Void {
        guard !resource.isEmpty else {
            return
        }
        
        activeOffset = x
        
        _ = nextClone()
        _ = prevClone()
        
        if options.autoPlay {
            destroyAutoPlay()
        }
        
    }
    
    func afterDrag() -> Void {
        guard !resource.isEmpty else {
            return
        }
        
        primaryOffet += activeOffset
        activeOffset = .zero
        
        if options.loop {
            toSlide(currentIndex)
        } else {
            if offset > 0 {
                // Kéo cuộn về phía vượt leading
                toOffset(.zero)
            } else if offset < -enableSize {
                // Cuộn về phía traiding, vượt element cuối
                toSlide(resource.count - 1)
            } else {
                // Các trường hợp còn lại => cuộn về index gần nhất
                toSlide(currentIndex)
            }
        }
        
        if options.autoPlay {
            enableAutoPlay()
        }
    }
}

// Navigation
extension SwiperViewModel {
    private func toOffset(_ to: CGFloat) {
        withAnimation {
            primaryOffet = to
        }
    }
    
    func toSlide(_ to: Int) -> Void {
        toOffset(-offsetForSlide(to))
    }
    
    /// Tiến tới slide tiếp theo
    func slideNext() -> Void {
        
        guard !resource.isEmpty else {
            return
        }
        
        // Nếu Clone => cloneNext
        _ = nextClone()
        
        // Nằm trong khoảng có thể next
        if currentIndex < resource.count - 1 {
            return toSlide(currentIndex + 1)
        } else {
            toSlide(0)
        }
    }
    
    func toPrev() -> Void {
        
        guard !resource.isEmpty else {
            return
        }
        
        // Kiểm tra và clone Prev
        let hasPrevClone = prevClone()
        
        if hasPrevClone {
            // khi append => làm thay đổi currentIndex => toIndex sẽ bị sai
            // Thay đổi offset mà ko dùng animation
            let newIndex = data.count + currentIndex
            primaryOffet = -offsetForSlide(newIndex)
        }

        if currentIndex > 0 {
            return toSlide(currentIndex - 1)
        }
    }
}

