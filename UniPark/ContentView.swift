//
//  ContentView.swift
//  UniPark
//
//  Created by Tomas Angel on 21/09/24.
//
// import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel  // Move this outside the body
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ProfileView()
            } else {
                StartView()
            }
        }
    }
}


//#Preview {
//    ContentView()
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View{
        ContentView()
    }
}

