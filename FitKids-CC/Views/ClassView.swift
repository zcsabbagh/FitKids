//
//  PageView.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 8/23/24.
//

import SwiftUI

let gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

struct ClassView: View {

    @AppStorage("isLoggedIn") private var isLoggedIn = true

    var body: some View {
        NavigationView {
            ScrollView {
                LogoutButton(isLoggedIn: $isLoggedIn)
                LazyVGrid(columns: gridLayout, spacing: 15) {
                    ForEach(0..<classTypes.count, id: \.self) { i in
                        PerClassView(className: classes[i], classType: classTypes[i], classNum: i + 1, baseColor: Color.orange)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }

    }

    let classTypes = [
        "Upper Body", "Core", "Lower Body", "Agility", "Upper Body",
        "Core", "Lower Body", "Agility", "Upper Body", "Core",
        "Lower Body", "Agility", "Upper Body", "Core", "Lower Body",
        "Agility", "Upper Body", "Core", "Lower Body", "Agility",
        "Upper Body", "Core", "Lower Body", "Agility", "Upper Body",
        "Core", "Lower Body", "Agility", "Upper Body", "Core",
        "Lower Body", "Agility", "Upper Body", "Core", "Lower Body",
        "Agility", "Upper Body", "Core", "Lower Body", "Agility",
        "Upper Body", "Core", "Lower Body", "Agility", "Upper Body",
        "Core", "Lower Body", "Agility", "Upper Body", "Core"
    ]

    let classes = [ "K-8-Class-1.pdf",
                "K-8-Class-2.pdf",
                "K-8-Class-3.pdf",
                "K-8-Class-4.pdf",
                "K-8-Class-5.pdf",
                "K-8-Class-6.pdf",
                "K-8-Class-7.pdf",
                "K-8-Class-8.pdf",
                "K-8-Class-9.pdf",
                "K-8-Class-10.pdf",
                "K-8-Class-11.pdf",
                "K-8-Class-12.pdf",
                "K-8-Class-13.pdf",
                "K-8-Class-14.pdf",
                "K-8-Class-15.pdf",
                "K-8-Class-16.pdf",
                "K-8-Class-17.pdf",
                "K-8-Class-18.pdf",
                "K-8-Class-19.pdf",
                "K-8-Class-20.pdf",
                "K-8-Class-21.pdf",
                "K-8-Class-22.pdf",
                "K-8-Class-23.pdf",
                "K-8-Class-24.pdf",
                "K-8-Class-25.pdf",
                "K-8-Class-26.pdf",
                "K-8-Class-27.pdf",
                "K-8-Class-28.pdf",
                "K-8-Class-29.pdf",
                "K-8-Class-30.pdf",
                "K-8-Class-31.pdf",
                "K-8-Class-32.pdf",
                "K-8-Class-33.pdf",
                "K-8-Class-34.pdf",
                "K-8-Class-35.pdf",
                "K-8-Class-36.pdf",
                "K-8-Class-37.pdf",
                "K-8-Class-38.pdf",
                "K-8-Class-39.pdf",
                "K-8-Class-40.pdf",
                "K-8-Class-41.pdf",
                "K-8-Class-42.pdf",
                "K-8-Class-43.pdf",
                "K-8-Class-44.pdf",
                "K-8-Class-45.pdf",
                "K-8-Class-46.pdf",
                "K-8-Class-47.pdf",
                "K-8-Class-48.pdf",
                "K-8-Class-49.pdf",
                "K-8-Class-50.pdf" ]



}

struct PerClassView: View {
    let className: String
    let classType: String
    let classNum: Int
    let baseColor: Color

    var body: some View {
        NavigationLink(destination: SpecificPDFView(pdfFilename: className ?? "")) {
            VStack(spacing: 0) {                
                Text("Class \(classNum): \n \(classType)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 150)
            .background(LinearGradient(gradient: Gradient(colors: [baseColor.opacity(0.2), baseColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 2)
        }
        
        .onTapGesture {
            let filenameWithoutExtension = className.replacingOccurrences(of: ".pdf", with: "")
            AmplitudeManager.shared.track("Clicked Class Plan", properties: ["filename": filenameWithoutExtension])
        }
    }
}

