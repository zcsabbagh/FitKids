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
                LogoutButton(isLoggedIn: $isLoggedIn)
                LazyVGrid(columns: gridLayout, spacing: 15) {
                    ForEach(0..<resources.count, id: \.self) { i in
                        PerResourceView(resource: resources[i], baseColor: Color.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
    }

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
            .background(LinearGradient(gradient: Gradient(colors: [baseColor.opacity(0.4), baseColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
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


