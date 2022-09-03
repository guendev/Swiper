//
//  SwiftUIView.swift
//
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

// Paginate
extension SwiperViewModel {
    
}

struct Sho5_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Swiper(
                [.blue, .gray, .orange, .yellow],
                options: SwiperOptions(
                    spaceBetween: 10,
                    slidesPerView: 1.5,
                    autoPlay: true,
                    paginate: .dot
                )
            )
            .padding(.horizontal)
            // .frame(height: 250)
            
        }
        .frame(maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}

