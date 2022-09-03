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
    
    @State var arr: [String] = Array<String>(repeating: String("A"), count: 3)
    
    var body: some View {
        VStack {
            Swiper(
                arr,
                options: SwiperOptions(
                    spaceBetween: 10,
                    slidesPerView: 2,
                    loop: true
                )
            ) { data, resource, _ in
                Color.blue
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
        }
    }
}

struct Sho_Previews: PreviewProvider {
    static var previews: some View {
        SwiperCanvas()
    }
}
