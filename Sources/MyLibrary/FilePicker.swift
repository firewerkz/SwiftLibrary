//
//  FilePicker.swift
//  Landlord2
//
//  Created by Dick Johnson on 21/08/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct FilePickerController: UIViewControllerRepresentable {
    @Binding var url: URL?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FilePickerController>) {
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // ["public.data"]
        let controller = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        
        controller.delegate = context.coordinator
        
        return controller
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerController
        
        init(_ pickerController: FilePickerController) {
            self.parent = pickerController
        }
       
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.url = urls.first
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.url = nil
        }
        
        deinit {
        }
    }
}

struct PickerView: View {
    @Binding var url: URL?
    
    var body: some View {
        FilePickerController(url: $url)
    }
}

#if DEBUG
struct PickerView_Preview: PreviewProvider {
    static var previews: some View {
        
        return PickerView(url: .constant(nil))
            .aspectRatio(3/2, contentMode: .fit)
    }
}
#endif