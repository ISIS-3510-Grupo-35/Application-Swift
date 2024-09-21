//
//  UniParkApp.swift
//  UniPark
//
//  Created by Tomas Angel on 17/09/24.
//

import SwiftUI

@main
struct UniParkApp: App {
    @StateObject var viewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
