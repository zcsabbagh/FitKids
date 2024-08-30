//
//  pdfView.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 8/23/24.
//

import SwiftUI
import PDFKit

struct SpecificPDFView: View {
    var pdfFilename: String
    
    var body: some View {
        PDFKitRepresentedView(pdfFilename: pdfFilename, pdfDirectoryPath: "")
            .edgesIgnoringSafeArea(.all)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdfFilename: String
    let pdfDirectoryPath: String

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        if let pdfURL = Bundle.main.url(forResource: pdfFilename, withExtension: nil, subdirectory: pdfDirectoryPath) {
            if let pdfDocument = PDFDocument(url: pdfURL) {
                pdfView.document = pdfDocument
            } else {
                print("Failed to load the PDF document from the URL: \(pdfURL)")
            }
        } else {
            print("Failed to find the PDF file URL in the bundle with filename: \(pdfFilename)")
        }
        
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // Update the view if needed
    }
}


