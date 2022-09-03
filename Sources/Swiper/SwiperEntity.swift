//
//  SwiftUIView.swift
//  
//
//  Created by Yuan on 03/09/2022.
//

import SwiftUI

struct SwiperOptions {
    internal init(
        initialSlide: Int = 0,
        spaceBetween: CGFloat = .zero,
        slidesPerView: CGFloat = 1,
        loop: Bool = false, autoPlay: Bool = false, speed: CGFloat = 3, delay: CGFloat = 5, fitSize: Bool = false, paginate: SwiperPaginate = .hidden) {
            
            // validate
            guard slidesPerView > 0 else {
                fatalError("Property slidesPerView should be more than 0")
            }
            
            guard speed > 0 else {
                fatalError("Property more should be more than 0")
            }
            
            guard delay > 0 else {
                fatalError("Property deplay should be more than 0")
            }
            
            self.initialSlide = initialSlide
            self.spaceBetween = spaceBetween
            self.slidesPerView = slidesPerView
            self.loop = loop
            self.autoPlay = autoPlay
            self.speed = speed
            self.delay = delay
            self.fitSize = fitSize
            self.paginate = paginate
        }
    
    // Index number of initial slide
    var initialSlide: Int = 0
    
    // Khoảng cách giữa các element
    var spaceBetween: CGFloat = .zero
    // Số slide/màn hình
    var slidesPerView: CGFloat = 1
    
    // Tự động clone. Infinity
    var loop: Bool = false
    
    // Tự động play
    var autoPlay: Bool = false
    // Duration animation
    var speed: CGFloat = 3
    // Delay
    var delay: CGFloat = 5
    
    // Tự động loại trừ khoảng trắng dư thừa
    var fitSize: Bool = false
    
    var paginate: SwiperPaginate = .hidden
}

enum SwiperPaginate {
    case hidden
    case dot
    case line
}

struct SlideItem: Identifiable {
    var id = UUID().uuidString
    var primaryID: Int
    
    var item: Color
    
    var active: Bool = false
}
