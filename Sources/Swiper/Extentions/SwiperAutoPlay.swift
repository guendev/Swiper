//
//  SwiftUIView.swift
//
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

// AutoPlay
extension SwiperViewModel {
    func enableAutoPlay() -> Void {
        destroyAutoPlay()
        debounceNext = Timer.scheduledTimer(withTimeInterval: options.delay, repeats: true) { [weak self]  _ in
            self?.slideNext()
        }
    }
    
    func destroyAutoPlay() -> Void {
        debounceNext?.invalidate()
        debounceNext = nil
    }
}

