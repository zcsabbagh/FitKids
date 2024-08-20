//
//  GetStartedTab.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 3/1/24.
//

import Foundation
import SwiftUI
import PDFKit
import AmplitudeSwift

/* Firebase integration needed
    - 

    Amplitude integration needed
    - 
*/

struct ClassItem: Identifiable {
    let id: UUID
    let title: String
    let imageName: String
    let pdfFilenames: [String]
    let videos: [VideoItem]?

    init(title: String, imageName: String, pdfFilenames: [String], videos: [VideoItem]? = nil) {
        self.id = UUID()
        self.title = title
        self.imageName = imageName
        self.pdfFilenames = pdfFilenames
        self.videos = videos
    }
}

// Updated sample database with all associated PDFs from the image and their paths
let sampleClasses: [ClassItem] = [
    ClassItem(title: "Program         Resources", imageName: "placeholder Cardio", pdfFilenames: ["Fitness Testing.pdf", "Leading Fit Kids Indoors.pdf", "Equipment List.pdf"]),
    ClassItem(title: "Brain                       Breaks", imageName: "placeholder Cardio", pdfFilenames: ["Brain Breaks.pdf", "Morning Movement.pdf", "Monthly Mindfulness.pdf", "Yoga Flows.pdf" ]),
    ClassItem(title: "Coaching Resources (PCA)", imageName: "placeholder Strength", pdfFilenames: [
        "Age Appropriate Coaching.pdf",
        "Behavior Guidance Intervention.pdf",
        "ELM Tree of Mastery.pdf",
        "FKF CDC Body Chart.pdf",
        "Game Plan For Girls in Sports.pdf",
        "Healing Centered Coaching.pdf",
        "How Kids Learn Best.pdf",
        "Positive Behavior Guidance Prevention.pdf",
        "Role of a Coach.pdf",
        "Safety Tips.pdf",
        "Tips for the First Time Coach.pdf",
        "Tricks of the Trade.pdf",
        "Understanding Traumas Impact on Behavior.pdf"
    ]),
    ClassItem(title: "Fitness Games & Challenges", imageName: "placeholder Strength", pdfFilenames: [
        "Classroom Fitness Games.pdf",
        "Plank Challenge.pdf",
        "Before Breakfast Cardio.pdf",
        "Build Your Own Snowman Workout.pdf",
        "Spell Your Name Fitness Activity.pdf",
        "Roll into Fitness.pdf",
        "A November Stuffed With Fitness.pdf",
        "Word Search.pdf",
        "February Fitness.pdf",
        "Fitness-Bingo.pdf",
        "Mindful Movement Calendar.pdf",
        "31 Day Squat Challenge.pdf",
        "Tic Tac Toe Fitness.pdf"
    ]),
]

// Define the grid layout
let gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 2)


// Updated GetStartedTab with conditional navigation
struct GetStartedTab: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 15) {
                    ForEach(sampleClasses) { classItem in
                        // Check if there is only one PDF
                        if classItem.pdfFilenames.count == 1, let pdfFilename = classItem.pdfFilenames.first {
                            // Direct navigation to SpecificPDFView
                            NavigationLink(destination: SpecificPDFView(pdfFilename: pdfFilename).navigationBarTitle("", displayMode: .inline)) {
                                ClassItemView(classItem: classItem, baseColor: Color.orange)
                            }
                        } else {
                            // Navigate to ClassItemPDFListView for multiple PDFs
                            NavigationLink(destination: ClassItemPDFListView(classItem: classItem).navigationBarTitle("", displayMode: .inline)) {
                                ClassItemView(classItem: classItem, baseColor: Color.orange)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            // .navigationBarTitle("Get Started", displayMode: .inline)
        }
        
    }
}

// Refactored ClassItem view component for reuse with dynamic color gradient
struct ClassItemView: View {
    let classItem: ClassItem
    let baseColor: Color

    var body: some View {
        VStack(spacing: 0) {
            Image(classItem.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .clipped()
            
            Text(classItem.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .background(LinearGradient(gradient: Gradient(colors: [baseColor.opacity(0.2), baseColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}

struct ClassItemPDFListView: View {
    var classItem: ClassItem

    var body: some View {
        List(classItem.pdfFilenames, id: \.self) { pdfFilename in
            NavigationLink(destination: SpecificPDFView(pdfFilename: pdfFilename)) {
                Text(pdfFilename)
            }
            .onTapGesture {
                let filenameWithoutExtension = pdfFilename.replacingOccurrences(of: ".pdf", with: "")
                AmplitudeManager.shared.track("Clicked Class Plan", properties: ["filename": filenameWithoutExtension])
            }
        }
        .navigationTitle(classItem.title)
    }
}



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

// Preview for SwiftUI Canvas
struct GetStartedTab_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedTab()
    }
}
