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

struct Sho4_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Swiper(
                [.blue, .gray, .orange, .yellow],
                options: SwiperOptions(
                    spaceBetween: 10,
                    slidesPerView: 1.5,
                    autoPlay: true
                )
            )
            .padding(.horizontal)
            // .frame(height: 250)
            
        }
        .frame(maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}

