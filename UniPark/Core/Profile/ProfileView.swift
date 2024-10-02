//
//  ProfileView.swift
//  UniPark
//
//  Created by Tomas Angel on 20/09/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    //@EnvironmentObject var viewModel: AuthViewModel //Comment
    var body: some View {
        //if let user = viewModel.currentUser { //Comment
            List {
                Section {
                    HStack {
                        //Text (user.initials)
                        //Text("MJ")
                        Text(User.MOCK_USER.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        VStack (alignment: .leading, spacing: 4) {
                            //Text(user.fullname)
                            //Text("Michael Jordan")
                            Text(User.MOCK_USER.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            //Text(user.email)
                            Text(User.MOCK_USER.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }
                Section ("General") {
                    HStack {
                        SettingsRowView(imageName: "gear",
                                        title: "Version",
                                        tintColor: Color(.systemGray))
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Section ("Account") {
                    Button {
                        print("Sign out...")
                        //viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign out",
                            tintColor: .red)
                    }
                    Button {
                        print("Delete account...")
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete account",
                            tintColor: .red)
                    }
                }
            }
        }
    //} //Comment
}

struct ProfileView_Preview: PreviewProvider {
    static var previews: some View {
        // Create a sample AuthViewModel instance
        //let viewModel = AuthViewModel() // Initialize your view model as needed
        return ProfileView()
          //  .environmentObject(viewModel) // Add the environment object
    }
}
