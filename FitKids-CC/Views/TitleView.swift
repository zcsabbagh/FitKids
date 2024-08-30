//
//  LogoutView.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 8/23/24.
//
import SwiftUI


struct TitleView: View {
    @Binding var isLoggedIn: Bool
    @State private var showLogoutMenu = false
    var title: String
    
    var body: some View {

        HStack {
            if title == "Classes" {
                Image("stretching")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            } else if title == "resources" {
                Image("single-kid")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
                
            
            if title == "Classes" {
                Text("K-8 Curriculum")
                    .font(.title2)
            } else {
                VStack (alignment: .leading, spacing: 0) {
                    Text("Program Resources")
                        .font(.title2)
                }

            }
            
            Spacer()
            if #available(iOS 15.0, *) {
                Button(action: {
                    showLogoutMenu = true
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.gray.opacity(0.7))
                        .clipShape(Circle())
                }
                .confirmationDialog("Logout", isPresented: $showLogoutMenu) {
                    Button("Log Out", role: .destructive) {
                        isLoggedIn = false
                    }
                    Button("Cancel", role: .cancel) {}
                }
            } else {
                Button(action: {
                    isLoggedIn = false
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.gray.opacity(0.7))
                        .clipShape(Circle())
                }
                
            }

        }
        .padding(.horizontal, 20)
        
    }
}
