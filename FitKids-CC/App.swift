//
//  FitKids_CCApp.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 3/1/24.
//

import SwiftUI
import AmplitudeSwift

@main
struct FitKids_CCApp: App {

    @AppStorage("isLoggedIn") private var isLoggedIn = false

    init() {
        // Set the overall theme of the app to dark mode
        UITabBar.appearance().backgroundColor = UIColor.black
        UINavigationBar.appearance().backgroundColor = UIColor.black
        UITableView.appearance().backgroundColor = UIColor.black
        UITableViewCell.appearance().backgroundColor = UIColor.black
        UISwitch.appearance().onTintColor = UIColor.darkGray
        UITabBar.appearance().tintColor = UIColor.white // Ensure selected tab item color is white
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray // Set unselected tab items to gray for better contrast
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabView {
                    ClassView()
                    .tabItem {
                        Label("Class Plans", systemImage: "books.vertical")
                    }

                    ResourcesView()
                    .tabItem {
                        Label("Resources", systemImage: "figure.walk")
                    }
                }
                .accentColor(.white)
                .preferredColorScheme(.light)
            } else {
                WebKitView()
                    .preferredColorScheme(.light)
                    // .background(Color.blue.opacity(0.8))
                    .edgesIgnoringSafeArea(.all)
            }
        }
        
        }
    }







/* Note for future developers:
 
 It's incredibly likely that they will ask for the structure to become "Get Started", "Curriculum", "Videos",
 which makes WAY more sense and is a LOT more comprehensive. For those cases, simply replace the body of
 WindowGroup with the code below:
 
 TabView {
     GetStartedTab()
         .tabItem {
             Label("Get started", systemImage: "figure.walk")
         }
         
    
    CurriculumTab()
        .tabItem {
            Label("Curriculum", systemImage: "books.vertical")
        }
       
    
     VideosTab()
         .tabItem {
             Label("Videos", systemImage: "play.rectangle")
         }
         
 }

 */
