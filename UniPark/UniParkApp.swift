//
//  UniParkApp.swift
//  UniPark
//
//  Created by Tomas Angel on 17/09/24.
//

import SwiftUI
import Firebase

@main
struct UniParkApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                //.environmentObject(ReservationViewModel())
        }
    }
}
