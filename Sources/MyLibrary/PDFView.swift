//
//  PDFView.swift
//  Landlord2
//
//  Created by Dick Johnson on 30/07/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
// Some help from this https://stackoverflow.com/questions/56219261/how-to-tell-if-a-pdfdocument-has-loaded-in-to-a-pdfview
//

import SwiftUI
import PDFKit

#if os(macOS)
#else
public struct PDFKitView: View {
    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        PDFKitRepresentedView(url)
    }
}

struct PDFKitView_Previews: PreviewProvider {
    static var previews: some View {
        PDFKitView(url: Bundle.main.url(forResource: "Test", withExtension: "pdf")!)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        DispatchQueue.global(qos: .background).async {
            if let document = PDFDocument(url: self.url) {
                DispatchQueue.main.async {
                    pdfView.document = document
                    pdfView.autoScales = true
                }
            }
        }
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
    }
}
#endif
