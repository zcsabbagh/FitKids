//
//  LogoutView.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 8/23/24.
//
import SwiftUI


struct LogoutButton: View {
    @Binding var isLoggedIn: Bool
    @State private var showLogoutMenu = false

    var body: some View {

        HStack {
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
        .padding(.horizontal, 10)
        
    }
}
