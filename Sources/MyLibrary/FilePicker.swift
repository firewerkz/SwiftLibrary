//
//  FilePicker.swift
//  Landlord2
//
//  Created by Dick Johnson on 21/08/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//

import SwiftUI
#if os(macOS)
#else
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

public struct PickerView: View {
    @Binding var url: URL?

    public init(url: Binding<URL?>) {
        self._url = url
    }

    public var body: some View {
        FilePickerController(url: $url)
    }
}

@available(iOS 14, *)
struct PickerViewPreview: PreviewProvider {
    static var previews: some View {
        return PickerView(url: .constant(URL(string: "www.apple.com")))
            .aspectRatio(3/2, contentMode: .fit)
        .previewAsScreen()
    }
}
#endif
