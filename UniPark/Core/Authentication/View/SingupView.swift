//
//  SingupView.swift
//  UniPark
//
//  Created by Tomas Angel on 20/09/24.
//

import Foundation

import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var selectedUserType:String = "Driver"
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    let userTypes = ["Driver", "Parkinglot owner"]
    
    var body: some View {
        ZStack{
            Color.yellow
                .ignoresSafeArea()
            VStack {
                Image("uniparkSign")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .padding(.vertical, 32)
                VStack(spacing: 24){
                    
                    InputView(text: $email, title: "Email Address", placeHolder: "nombre@email.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $fullname, title: "Full name", placeHolder: "Pepito Perez")
                    
                    InputView(text: $password, title: "Password", placeHolder: "Enter your password", isSecureField: true)
                    
                    InputView(text: $confirmPassword, title: "Confirm password", placeHolder: "Confirm your password", isSecureField: true)
                    
                    Form {
                        Picker("Select User Type", selection: $selectedUserType) {
                            Color.yellow
                                ForEach(userTypes, id: \.self) { userType in
                                                    Text(userType).tag(userType)
                                                }
                        }
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, 13)
                
                Button{
                    print("Sign user up...")
                    Task {
                        try await viewModel.createUser(withEmail:email, password:password,fullname:fullname)
                    }
                } label: {
                    HStack {
                        Text("Sign up")
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
                
                Button {
                    dismiss()
                } label: {
                    HStack (spacing: 2){
                        Text("Already have an account?")
                        Text("Log in")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

struct SingupView_Preview: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
