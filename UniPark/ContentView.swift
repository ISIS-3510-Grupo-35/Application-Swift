import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showMenu = false
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                NavigationStack {
                    ZStack {
                        TabView(selection: $selectedTab) {
                            ProfileView()
                                .tag(0)
                            MapView() // Display the MapView for parking lots
                                .tag(1)
                            Text("Favorites")
                                .tag(2)
                            ReservationInfoView()
                                .tag(3)
                        }
                        MenuView(isShowing: $showMenu, selectedTab: $selectedTab)
                    }
                    .toolbar(showMenu ? .hidden : .visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                showMenu.toggle()
                            }, label: {
                                Image(systemName: "line.3.horizontal")
                            })
                        }
                    }
                    .onChange(of: selectedTab) { newValue in
                        // Hide the menu when a tab is selected
                        showMenu = false
                    }
                }
            } else {
                StartView() // Show a starting view for users not signed in
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
