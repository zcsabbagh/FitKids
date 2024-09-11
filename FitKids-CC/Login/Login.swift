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
            Spacer()
            Image("fitkids")
                .resizable()
                .scaledToFit()
                .frame(height: 140)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 40)
                .padding(.horizontal, 40)
            

            Text("COACH'S CORNER")
                .font(.custom("BebasNeue-Regular", size: 50))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .minimumScaleFactor(0.95)
                .lineLimit(1)
            
            TextField("Email address", text: self.$username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .accentColor(.black)
                .padding(.vertical, 5)
                .padding(.horizontal, 40)
               

            SecureField("Password", text: self.$password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .accentColor(.black)
                .padding(.vertical, 5)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                

            Button(action: {
                print("Login button tapped")
                isLoggingIn = true
//                logIn2(username: username, password: password)
                 logIn3(username: username, password: password)
            }) {
                Text("Log In")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(8)
            }
            .disabled(isLoggingIn)
            .padding(.horizontal, 60)
            
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
            Spacer()
            Spacer()
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
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
        print("Username: ", username)
        print("Password: ", password)
        
        let parameters = "username==\(username)&password=\(password.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
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

    func logIn3(username: String, password: String) {
    let urlString = "https://fitkids.org/wp-json/wp/v2/posts"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let loginString = "\(username):\(password)"
    guard let loginData = loginString.data(using: .utf8) else {
        print("Login encoding failed")
        return
    }
    let base64LoginString = loginData.base64EncodedString()
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    
    // Print the request headers for debugging
    print("Request headers: \(request.allHTTPHeaderFields ?? [:])")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        DispatchQueue.main.async {
            self.isLoggingIn = false
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showError = true
                return
            }
            
            // Print the raw response
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                print("Response headers: \(httpResponse.allHeaderFields)")
            }
            
            if let data = data {
                print("Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Parsed JSON response: \(json)")
                    
                    if let status = json["status"] as? String, status != "error" {
                        print("Login successful")
                        self.isLoggedIn = true
                    } else {
                        print("Login failed: \(json["error_description"] as? String ?? "Unknown error")")
                        self.showError = true
                    }
                } else {
                    print("Failed to parse JSON")
                    self.showError = true
                }
            } else {
                print("No data received")
                self.showError = true
            }
        }
    }.resume()
}

}
