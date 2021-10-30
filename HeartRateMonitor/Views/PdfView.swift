//
//  PdfView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

import SwiftUI
import PDFKit

struct PdfView: View {
    @Environment(\.presentationMode) var presentationMode

    let url: URL?
    let data: Data?

    var body: some View {
        NavigationView {
            PDFKitRepresentedView(url: url, data: data)
                .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
                .navigationTitle("Your report")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView(url: MockUtils.pdfUrl, data: nil)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL?
    let data: Data?

    init(url: URL?, data: Data?) {
        self.url = url
        self.data = data
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        if let url = url {
            pdfView.document = PDFDocument(url: url)
        } else if let data = data {
            pdfView.document = PDFDocument(data: data)
        } else {
            Logger.d("No pdf data")
        }
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
    }
}
