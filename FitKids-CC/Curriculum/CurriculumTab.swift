//
//  Curriculum.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 3/1/24.
//

import Foundation
import SwiftUI


let k8: [ClassItem] = [
    ClassItem(title: "Guides & Tips", imageName: "placeholder Strength", pdfFilenames: [
        "FKF Class Guide and Tips 8.31.2023 EVersion2.pdf"
    ]),
    ClassItem(title: "Class Plans", imageName: "placeholder Strength", pdfFilenames: [
        "K-8-Class-1.pdf",
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
        "K-8-Class-50.pdf"
    ])
//    , ClassItem(title: "Fitness Cooldowns", imageName: "placeholder Cardio", pdfFilenames: [
//        "FKF Fitness Movement Station Sheets 8.19.23F.pdf"
//    ]),
//    ClassItem(title: "Fitness Movements", imageName: "placeholder Strength", pdfFilenames: [
//        "FKF Fitness Movement Station Sheets 8.19.23F.pdf"
//    ]),
//    ClassItem(title: "Fitness Warmups", imageName: "placeholder Cardio", pdfFilenames: [
//        "FKF Fitness Warmups Station Sheets 8.19.23F.pdf"
//    ])
]

let leadingIndoors: [ClassItem] = [
    ClassItem(title: "Class Guide and Tips", imageName: "placeholder Strength", pdfFilenames: [
        "Leading-Fit-Kids-Indoors.pdf"
    ]),
]

let gamesAndChallenges: [ClassItem] = [
    ClassItem(title: "Games & Challenges", imageName: "placeholder Strength", pdfFilenames: [
        "FKF-Fitness-Activity-Sept-Plank-Final-9.8.2023B-1.pdf",
        "FKF-Fitness-Activity-Oct-JJSJ-9.13.2023-Final.pdf",
        "FKF-Fitness-Activity-December-2023-Final.pdf",
        "FKF-SYN-Challenge-Calendar-4.3.23F.pdf",
        "FKF-January-2024-Fitness-Activity-Final-1.12.24Final.pdf",
        "FKF-Fitness-Activity-November-11.7.2023-Final.pdf",
        "FKF-Word-Search-6.8.2023-Final.pdf",
        "FKF-February-2.7.2024B-Fitness-Activity.pdf",
        "Fitness-Bingo.pdf",
        "FKF-MM-Challenge-Calendar-8.14.2023F.pdf",
        "FKF-Month-Workout-Calendar-March-2023.pdf",
        "FKF-Aug-7.26.2023-Fitness-Activity-TicTacToeF.pdf"
    ])
]

let classroomFitness: [ClassItem] = [
    ClassItem(title: "Classroom Fitness", imageName: "placeholder Strength", pdfFilenames: [
        "FKF-Classroom-Fitness-Sheet-11.23-Final.pdf"
    ]),
]


struct CurriculumCategory {
    let name: String
    let imageName: String
    let classItems: [ClassItem]
}

struct CurriculumDictionary {
    var curriculum: [CurriculumCategory] = [
        CurriculumCategory(name: "K-8 Curriculum", imageName: "k8Image", classItems: k8),
        CurriculumCategory(name: "Leading Indoors", imageName: "leadingIndoorsImage", classItems: leadingIndoors),
        CurriculumCategory(name: "Games & Challenges", imageName: "gamesAndChallengesImage", classItems: gamesAndChallenges),
        CurriculumCategory(name: "Classroom Fitness", imageName: "classroomFitnessImage", classItems: classroomFitness),
    ]
}




/* initial layer of depth that can navigate either directly to PDFs / lists of PDFs or to subTab*/ 
struct CurriculumTab: View {
    // Use CurriculumDictionary to get the array of CurriculumCategory
    private let curriculumDictionary = CurriculumDictionary()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 15) {
                    ForEach(curriculumDictionary.curriculum, id: \.name) { category in
                        NavigationLink(destination: destinationView(for: category)) {
                            categoryView(category: category)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            // .navigationBarTitle("Curriculum", displayMode: .inline)
        }
    }
    
    @ViewBuilder
    private func destinationView(for category: CurriculumCategory) -> some View {
        if category.classItems.count == 1, let pdfFilename = category.classItems.first?.pdfFilenames.first, category.classItems.first?.pdfFilenames.count == 1 {
            SpecificPDFView(pdfFilename: pdfFilename)
        } else if category.classItems.count == 1 {
            ClassItemPDFListView(classItem: category.classItems.first!)
        } else {
            CurriculumSubTab(classItems: category.classItems)
        }
    }
    
    @ViewBuilder
    private func categoryView(category: CurriculumCategory) -> some View {
        VStack {
            Image(category.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            Text(category.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, -30)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.black.opacity(0.7))
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.2), Color.yellow.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}

// Refactored ClassItem view component for reuse
private struct CurriculumItemView: View {
    let curriculumItem: ClassItem
    let backgroundColor: Color

    var body: some View {
        VStack {
            Image(curriculumItem.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            Text(curriculumItem.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, -30)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.black.opacity(0.7))
        }
        .background(LinearGradient(gradient: Gradient(colors: [backgroundColor.opacity(0.2), backgroundColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}




/* second layer deep, when there are multiple folders like in the K-8 curriculum */
struct CurriculumSubTab: View {
    var classItems: [ClassItem]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 15) {
                ForEach(classItems, id: \.title) { classItem in
                    // Check if there is only one PDF
                    if classItem.pdfFilenames.count == 1, let pdfFilename = classItem.pdfFilenames.first {
                        // Direct navigation to SpecificPDFView
                        NavigationLink(destination: SpecificPDFView(pdfFilename: pdfFilename)) {
                            ClassItemView(classItem: classItem, baseColor: Color.blue)
                                               }
                    } else {
                        // Navigate to ClassItemPDFListView for multiple PDFs
                        NavigationLink(destination: ClassItemPDFListView(classItem: classItem)) {
                            ClassItemView(classItem: classItem, baseColor: Color.blue)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
//        .navigationBarTitle("K-8 Curriculum", displayMode: .inline)
    }
}




// Preview for SwiftUI Canvas
struct CurriculumdTab_Previews: PreviewProvider {
    static var previews: some View {
        CurriculumTab()
    }
}
