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
    //@State private var balance = 0
    //@State private var favoriteParkingLots = [String]()
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
                VStack(alignment: .leading, spacing: 24){
                    //Email input
                    InputView(text: $email, title: "Email Address", placeHolder: "nombre@email.com")
                        .autocapitalization(.none)
                    //Name input
                    InputView(text: $fullname, title: "Full name", placeHolder: "Pepito Perez")
                    //Password input
                    InputView(text: $password, title: "Password", placeHolder: "Enter your password", isSecureField: true)
                    //Confirm password input
                    ZStack (alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Confirm password", placeHolder: "Confirm your password", isSecureField: true)
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed ))
                            }
                        }
                    }
                    //User type picker
                    Text("I am a ")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                    Picker("Select User Type", selection: $selectedUserType) {
                        Color.yellow
                            ForEach(userTypes, id: \.self) { userType in
                                                Text(userType).tag(userType)
                            }
                    }.tint(Color(.darkGray))
                    .font(.system(size: 14))
                    
                }
                .padding(.horizontal)
                .padding(.top, 13)
                //Sign up button
                Button{
                    print("Sign user up...")
                    Task {
                        try await viewModel.createUser(withEmail:email, password:password ,fullname:fullname); //, isDriver: true, balance:balance, favoriteParkingLots: [])
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
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.7)
                .cornerRadius(10)
                .padding(.top, 24)
                Spacer()
                //Log in navegation
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

extension SignupView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}


struct SingupView_Preview: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
