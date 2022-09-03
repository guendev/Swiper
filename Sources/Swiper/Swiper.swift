//
//  SwiftUIView.swift
//
//
//  Created by Yuan on 02/09/2022.
//

import SwiftUI

struct Swiper: View {
    
    @ObservedObject
    var viewModel: SwiperViewModel
    
    init(_ data: [Color], options: SwiperOptions = SwiperOptions()) {
        self.viewModel = SwiperViewModel(data, options: options)
    }
    @GestureState
    var isDragging = false
    
    @State
    var logs: [String] = []

    var body: some View {
        
        /// Canvas
        ScrollView {
            VStack {
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            viewModel.toPrev()
                        } label: {
                            Text("Prev")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        
                        Button {
                            viewModel.toNext()
                        } label: {
                            Text("Next")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        
                        Button {
                            logs = []
                        } label: {
                            Text("Clean")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    
                    Group {
                        Text("Active: \(isDragging ? "true" : "false")")
                        Text("Offset: \(viewModel.offset)")
                        Text("Canvas Size: \(viewModel.canvasSize)")
                        Text("Width Element: \(viewModel.widthPerElement())")
                        Text("Padding: \(viewModel.totalSpaces())")
                        Text("Init Count: \(viewModel.data.count)")
                        Text("Deep Count: \(viewModel.resource.count)")
                        Text("View Size: \(viewModel.viewSize)")
                        Text("Enable Size: \(viewModel.enableSize)")
                        Text("Current Index: \(viewModel.currentIndex)")
                    }

                    
                }
                .padding(.bottom)

                   
                /// Cards
                ZStack(alignment: .topLeading) {
                    // Primary
                    ForEach(Array(zip(viewModel.resource.indices, viewModel.resource)), id: \.0) { index, item in
                      
                        item
                            .overlay(
                                VStack {
                                    
                                    Text("Offset: \(viewModel.offsetForItem(index))")
                                    
                                    Text("Index: \(index)")
                                    
                                    Text(viewModel.currentIndex == index ? "Active" : "")
                                    
                                }
                            )
                            .frame(width: viewModel.widthPerElement())
                            .offset(x: viewModel.offsetForItem(index))
                        
                    }
                }
                .frame(height: 200)
                .frame(width: viewModel.canvasSize, alignment: .leading)
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
                
                VStack {
                    
                    ForEach(Array(zip(logs.indices, logs)), id: \.0) { index, item in
                      
                        Text("\(item)")
                        
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
}

struct Sho_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Swiper(
                [.blue, .gray, .orange, .green],
                options: SwiperOptions(spacing: 10, slidesPerView: 1.5, loop: false)
            )
            .padding(.horizontal)
            // .frame(height: 250)
            
        }
        .frame(maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}
