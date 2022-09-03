//
//  SwiftUIView.swift
//
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

struct Swiper<Data, Content> : View where Data : RandomAccessCollection, Content : View {
    
    typealias SwiperElement = Data.Element
    typealias Dragging = Bool
    
    @ObservedObject
    var viewModel: SwiperViewModel<Data>
    private let content: (SwiperElement, SwiperItemResource, Dragging) -> Content
    
    /// optional slot
    // private let action: (() -> Content)?
    
    @GestureState
    var isDragging = false
    var body: some View {
        
        VStack {
            /// Cards
            if viewModel.canvasSize > 0 {
                ZStack {
                    // Primary
                    ForEach(Array(zip(viewModel.resource.indices, viewModel.resource)), id: \.0) { index, item in
                        
                        VStack {
                            
                            content(
                                item.item,
                                SwiperItemResource(
                                    index: index,
                                    active: index == viewModel.currentIndex,
                                    offset: viewModel.offsetForSlide(index)
                                ),
                                isDragging
                            )
                            
                        }
                        .frame(width: viewModel.widthPerSlide())
                        .offset(x: viewModel.offsetForSlide(index))
                        
                    }
                }
                .frame(width: viewModel.canvasSize, alignment: viewModel.options.alignment)
                .offset(x: viewModel.offset)
                .background(Color.gray.opacity(0.1))
                .gesture(
                    DragGesture(minimumDistance: 10, coordinateSpace: .global)
                        .onChanged({ value in
                            viewModel.onDrag(x: value.translation.width)
                        })
                        .updating($isDragging, body: { (value, state, trans) in
                            state = true
                        })
                        .onEnded({ value in
                            
                            viewModel.afterDrag()
                        })
                )
                .animation(.default, value: viewModel.offset)
                .onAppear {
                    viewModel.setup()
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .overlay(
            
            GeometryReader { proxy -> Color in
                
                let _width = proxy.size.width
                DispatchQueue.main.async {
                    viewModel.canvasSize = _width
                }
                return Color.clear
            }
            
        )
        .clipped()
        
    }
}

// MARK: - Initializers
extension Swiper {
    init(
        _ data: Data,
        options: SwiperOptions = SwiperOptions(),
        // @ViewBuilder action: @escaping () -> Content = nil,
        @ViewBuilder content: @escaping (SwiperElement, SwiperItemResource, Dragging) -> Content
    ) {
        self.viewModel = SwiperViewModel(data, options: options)
        self.content = content
    }
}

extension Swiper {
    
    /// Init with ViewModel
    /// You can control slide outside Swiper() via ViewModel
    init(
        _ viewModel: SwiperViewModel<Data>,
        @ViewBuilder content: @escaping (SwiperElement, SwiperItemResource, Dragging) -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }
}

struct SwiperCanvas: View {
    
    @State var arr: [String] = ["#A460ED", "#0F3460", "#42855B"]
    
    @State var options: SwiperOptions = SwiperOptions()
    
    var body: some View {
        VStack {
            Swiper(arr, options: options) { data, resource, _ in
                Color.init(hex: data)
                    .overlay(
                        
                        VStack {
                            
                            Text("Index: \(resource.index)")
                            
                            Text("Active: \(resource.active ? "true" : "false")")
                            
                            Text("Offset: \(resource.offset)")
                            
                        }.foregroundColor(.white)
                        
                    )
                    .scaleEffect(resource.active ? 1 : 0.8)
                    .rotationEffect(resource.active ? .degrees(0) : .degrees(10))
                    .animation(.linear, value: resource.active)
            }
            .frame(height: 200)
            .padding(.horizontal)
            
            VStack {
                
                Text("Settup")
                    .font(.title)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading) {
                    Text("slidesPerView")
                    Slider(value: $options.slidesPerView, in: 1...4)
                }
                .padding(.top, 30)
                
                VStack(alignment: .leading) {
                    Text("spaceBetween")
                    Slider(value: $options.spaceBetween, in: 0...100)
                }
                .padding(.top, 30)
                
            }
            .padding(.top, 30)
            .padding()
            
        }
    }
}

fileprivate extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct Sho_Previews: PreviewProvider {
    static var previews: some View {
        SwiperCanvas()
    }
}
