//
//  SwiftUIView.swift
//  
//
//  Created by Yuan on 03/09/2022.
//

import SwiftUI

// Resource
extension SwiperViewModel {
    
    func cloneData() -> [Item] {
        return items.enumerated().map({ _item in
            return SlideItem(primaryID: _item.offset, item: _item.element)
        })
    }
    
    /// Thêm clone Items cho slide
    /// Kiểm xem có được phép clone hay không options.loop
    /// Kiểm tra xem có thoả mãn điều kiện hay ko
    /// Điều kiện:  Số phần tử theo sau currentIndex phải lớn hơn resource đầu vào
    func nextClone() -> Bool {
        
        if !options.loop {
            return false
        }
        if (currentIndex + 1) + data.count >= resource.count - 1 {
            nextData.append(contentsOf: cloneData())
            return true
        }
        return false
    }
    
    /// Thêm clone phía trước
    /// 1. Kiểm tra loop
    /// 2. Nếu phía trước currentIndex có ít hơn số data đầu vào => clone
    /// Khi clone insert phía trước sẽ làm
    /// Vì clone trước => thay đổi insert làm cho offset thay đổi
    /// Cần cập nhật lại offset mà ko sử dụng animation
    func prevClone() -> Bool {
        // Clone => push to clonePrev
        if !options.loop {
            return false
        }
        
        if currentIndex == data.count - 1 {
            prevData.append(contentsOf: cloneData())
            return true
        }
        
        return false
    }
}
