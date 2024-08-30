//
//  Login.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 3/1/24.
//

import Foundation
import SwiftUI
import AmplitudeSwift
import SPConfetti

struct LoginView: View {
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @State private var isLoggingIn = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Image("Login")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 70)
                    .padding(.horizontal, 40)
                Spacer()
            }


            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 50)
                
                Text("Email address")
                    .padding(.horizontal, 20)
                    .padding(.bottom, -10)
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextField("", text: self.$username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Password")
                    .padding(.horizontal, 20)
                    .padding(.bottom, -10)
                    .frame(maxWidth: .infinity, alignment: .leading)

                SecureField("", text: self.$password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button(action: {
                        print("Login button tapped")
                        isLoggingIn = true
                        logIn(username: username, password: password)
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .disabled(isLoggingIn)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                if isLoggingIn {
                    ProgressView()
                        .padding(.top)
                        .padding(.horizontal, 20)
    
                }
               
                
                if showError {
                    Text("Error signing in, please try again")
                        .foregroundColor(.red)
                        .padding(.top)
                        .padding(.horizontal, 20)
                }
            }
            .padding(40)
            Spacer()
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
//        .background(Color(hex: "378C52"))
        .onAppear {
            print("LoginView appeared")
        }
    }
    
    func logIn(username: String, password: String) {
        print("Logging in")
        
        guard let url = URL(string: "https://fitkids.org/wp-json/api/v1/token") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = "username=\(username)&password=\(password.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoggingIn = false
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showError = true
                }
                return
            }
            
            if let data = data {
                // Handle the response data here
                if let responseString = String(data: data, encoding: .utf8),
                   let jsonData = responseString.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let token = json["jwt_token"] as? String {
                    print("Login successful. Token: \(token)")
                    // Store the token securely and update isLoggedIn state
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                } else {
                    print("Failed to parse response or extract token")
                    DispatchQueue.main.async {
                        self.showError = true
                    }
                }
            }
        }.resume()
    }
}
