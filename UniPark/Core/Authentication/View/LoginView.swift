//
//  LoginView.swift
//  UniPark
//
//  Created by Tomas Angel on 20/09/24.
//

import Foundation

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.yellow
                    .ignoresSafeArea()
                VStack{
                    //image
                    Image("uniparkSign")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 100)
                        .padding(.vertical, 32)
                    
                    // signin forms
                    VStack(spacing: 24){
                        InputView(text: $email, title: "Email Address", placeHolder: "nombre@email.com")
                            .autocapitalization(.none)
                        InputView(text: $password, title: "Password", placeHolder: "Enter your password", isSecureField: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    // signin button
                    Button{
                        print("Log in user here...")
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                        
                    } label: {
                        HStack {
                            Text("Sign in")
                                .fontWeight(.semibold)
                            Image(systemName:"arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .padding(.top, 24)
                    Spacer()
                    
                    // signup button
                    NavigationLink {
                        SignupView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack (spacing: 2){
                            Text("Don't have an account?")
                            Text("Sign up")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        .font(.system(size: 14))
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View{
        LoginView()
    }
}
