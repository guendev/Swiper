//
//  SwiftUIView.swift
//  
//
//  Created by Yuan on 03/09/2022.
//

import SwiftUI

struct SwiperOptions {
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
    var fitSize: Bool = true
    
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
