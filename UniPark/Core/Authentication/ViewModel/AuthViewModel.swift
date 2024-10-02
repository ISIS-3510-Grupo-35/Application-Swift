//
//  AuthViewModel.swift
//  UniPark
//
//  Created by Tomas Angel on 21/09/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private var db = FirestoreService.shared.getFirestoreReference()
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in...")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws { //, isDriver: Bool, balance: Int, favoriteParkingLots: [String]) async throws {
        print("Create user...")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email) //, isDriver: isDriver, balance: balance, favoriteParkingLots: favoriteParkingLots)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await db.collection("users").document(user.id).setData(encodedUser)
            
            await fetchUser()
            
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }

    
    func signOut() {
        print("Sign out...")
        do  {
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil // wipes out user session and takes us back to login screen
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        print("Delete account...")
        
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            let uid = user.uid
            let db = FirestoreService.shared.getFirestoreReference()
            try await db.collection("users").document(uid).delete()
            
            try await user.delete()
            
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            
            print("DEBUG: Account deleted successfully")
            
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        print("Getting user...")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await db.collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        print("DEBUG: Current user is\(String(describing: self.currentUser))")
    }
}

