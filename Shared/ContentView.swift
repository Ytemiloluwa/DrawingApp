//
//  ContentView.swift
//  Shared
//
//  Created by Temiloluwa on 06/10/2020.
//

import SwiftUI

import PencilKit

struct ContentView: View {
    var body: some View {
        
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var canvas = PKCanvasView()
    @State var isdraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    @State var colorPicker = false
    
    // default is pen
    
    var body: some View {
        
        NavigationView {
            
            // Drawing View......
            
            DrawingView(canvas: $canvas, isdraw: $isdraw, type: $type, color: $color)
                .navigationTitle("Canvas")
                .font(.system(size: 35))
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color.purple)
                .navigationBarItems(leading: Button(action: {
                    
                    // Saving Image.......
                    
                    saveImage()
                    
                }, label: {
                    Image(systemName: "square.and.arrow.down.fill")
                        .font(.title)
                        .foregroundColor(Color.orange)
                }), trailing: HStack(spacing: 15) {
                    
                    Button(action: {
                        
                        // erase tool
                        
                        isdraw = false
                        
                        isdraw.toggle()
                        
                    }) {
                        
                        Image(systemName: "pencil.slash")
                            .font(.title)
                            .foregroundColor(Color.orange)
                    }
                    
                    Menu {
                        
                        // ColorPicker
                        
                        ColorPicker(selection: $color) {
                            
                            Button(action: {
                                
                                colorPicker.toggle()
                            }) {
                                Label {
                                    
                                    Text("Color")
                                } icon: {
                                    
                                    Image(systemName: "eyedropper.full")
                                        .foregroundColor(Color.orange)
                                }
                                
                            }
                            
                        }
                        
                        
                        Button(action: {
                            
                            // changing type
                            
                            isdraw = true
                            type = .pencil
                        }) {
                            
                            Label {
                                
                                Text("Pencil")
                            } icon: {
                                
                                Image(systemName: "pencil")
                            }
                            
                        }
                        
                        Button(action: {
                            isdraw = true
                            type = .pen
                        }) {
                            
                            Label {
                                
                                Text("Pen")
                            } icon: {
                                
                                Image(systemName: "pencil.tip")
                            }
                            
                        }
                        Button(action: {
                            isdraw = true
                            type = .marker
                        }) {
                            
                            Label {
                                
                                Text("Marker")
                            } icon: {
                                
                                Image(systemName: "highlighter")
                            }
                            
                        }
                        
                        
                    } label: {
                        Image(systemName: "menubar.dock.rectangle")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(Color.orange)
                    }
                    
                    
                })
                .sheet(isPresented: $colorPicker) {
                    
                   ColorPicker("Pick Color", selection: $color)
                    .padding()
                }
            
            
        }
    }
    
    func saveImage() {
        
        // getting image from Canvas
        
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        
        // saving to album
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        
    }
}

struct DrawingView: UIViewRepresentable {
    // to capture drawings for saving into albums
    @Binding var canvas: PKCanvasView
    @Binding var isdraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    
    
    // Updating inktype
    
     var ink : PKInkingTool {
        
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.drawingPolicy = .anyInput
        canvas.tool = isdraw ? ink : eraser
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // updating the tool whenever the view updates
        
        uiView.tool = isdraw ? ink : eraser
        
    }
}
