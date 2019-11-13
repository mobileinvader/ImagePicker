//
//  ContentView.swift
//  ImagePicker
//
//  Created by Kristijan Kralj on 04/11/2019.
//  Copyright © 2019 Kristijan Kralj. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  //1
  @State var showImagePicker: Bool = false
  //2
  @State var pickerImage: UIImage? = nil
  
  var body: some View {
    VStack(alignment: .leading) {
      //3
      Image(uiImage: pickerImage ?? UIImage())
        .resizable()
        .scaledToFill()
        .overlay(
          Rectangle()
            .strokeBorder(style: StrokeStyle(lineWidth: 1))
            .foregroundColor(Color.black))
        .clipped()
      Button(action: {
        //4
        self.showImagePicker.toggle()
      }, label: {
        HStack {
          Spacer()
          Text("Pick Image")
          Spacer()
        }
      })
    }
      //5
      .sheet(isPresented: $showImagePicker, onDismiss: {
        self.showImagePicker = false
      }, content: {
        ImagePicker(image: self.$pickerImage, isShown: self.$showImagePicker)
      })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct ImagePicker: UIViewControllerRepresentable {
  
  @Binding var image: UIImage?
  @Binding var isShown: Bool
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(isShown: $isShown, image: $image)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController,
                              context: UIViewControllerRepresentableContext<ImagePicker>) {
    
  }
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    
    init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
      _isShown = isShown
      _image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      isShown.toggle()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      isShown.toggle()
    }
  }
}
