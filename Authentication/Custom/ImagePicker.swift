//
//  ImagePicker.swift
//  Authentication
//
//  Created by Mit Patel on 12/10/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            
            if let selectedImage = info[.editedImage] as? UIImage {
                // Crop the image to square
                let croppedImage = self.cropToSquare(image: selectedImage)
                
                // Compress the image if it's larger than 1 MB
                let compressedImage = self.compressImage(image: croppedImage, toSizeInMB: 1.0)
                
                DispatchQueue.main.async {
                    self.parent.image = compressedImage
                    self.parent.isPresented = false
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            DispatchQueue.main.async {
                self.parent.isPresented = false
            }
        }
        
        // Crop image to square
        private func cropToSquare(image: UIImage) -> UIImage {
            let contextSize = image.size
            let width = min(contextSize.width, contextSize.height)
            let rect = CGRect(x: (contextSize.width - width) / 2, y: (contextSize.height - width) / 2, width: width, height: width)
            guard let croppedCGImage = image.cgImage?.cropping(to: rect) else { return image }
            return UIImage(cgImage: croppedCGImage)
        }
        
        // Compress image to a specific size (in MB)
        private func compressImage(image: UIImage, toSizeInMB sizeInMB: Double) -> UIImage {
            var compression: CGFloat = 1.0
            let maxFileSize = sizeInMB * 1024 * 1024 // Convert MB to bytes
            
            guard var imageData = image.jpegData(compressionQuality: compression) else { return image }
            
            // Check if the image exceeds the maximum file size
            while Double(imageData.count) > maxFileSize && compression > 0.01 {
                compression -= 0.05
                if let compressedData = image.jpegData(compressionQuality: compression) {
                    imageData = compressedData
                }
            }
            return UIImage(data: imageData) ?? image
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true // Enables cropping
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct ImagePicker_Previews: PreviewProvider {
    @State static var image: UIImage? = nil
    @State static var isPresented: Bool = false
    static var previews: some View {
        ImagePicker(image: $image, isPresented: $isPresented)
    }
}
