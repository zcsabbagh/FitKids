//
//  ResourcesView.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 8/23/24.
//
import SwiftUI

struct ResourcesView: View {

    @AppStorage("isLoggedIn") private var isLoggedIn = true

    var body: some View {
        NavigationView {
            ScrollView {
                TitleView(isLoggedIn: $isLoggedIn, title: "resources")
                
                LazyVGrid(columns: gridLayout, spacing: 15) {
                    ForEach(0..<program.count, id: \.self) { i in
                        PerResourceView(resource: program[i], baseColor: Color(hex: "F04E23"))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                

                HStack {
                    Image("pca")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    VStack (alignment: .leading) {
                        
                        Text("Coaching Resources")
                            .font(.title2)
                        Text("powered by Positive Coaching Alliance")
                            .font(.subheadline)
                            .fontWeight(.regular)
                        
                    }

                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                
                LazyVGrid(columns: gridLayout, spacing: 15) {
                    ForEach(0..<resources.count, id: \.self) { i in
                        PerResourceView(resource: resources[i], baseColor: Color(hex: "F99D1C"))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
    }

    let program: [String] = ["Leading Fit Kids Indoors",
    "Equipment List", "Fitness Testing", "Class Guide & Tips" ]
    
    let resources: [String] = [ "Age Appropriate Coaching.pdf",
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
                     "Understanding Traumas Impact on Behavior.pdf" ]
    
    

}

struct PerResourceView: View {
    let resource: String
    let baseColor: Color

    var body: some View {
        NavigationLink(destination: SpecificPDFView(pdfFilename: resource)) {
            VStack(spacing: 0) {
                Text(resource.replacingOccurrences(of: ".pdf", with: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 150)
            .background(baseColor)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 2)
        }
        .onTapGesture {
            print("Tapped on \(resource)")
            let filenameWithoutExtension = resource.replacingOccurrences(of: ".pdf", with: "")
            AmplitudeManager.shared.track("Clicked Class Plan", properties: ["filename": filenameWithoutExtension])
        }
    }

    
}

// Add this extension at the bottom of the file
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


