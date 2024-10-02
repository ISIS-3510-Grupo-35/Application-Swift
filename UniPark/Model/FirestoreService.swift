//
//  FirestoreService.swift
//  UniPark
//
//  Created by Ingrith Barbosa on 1/10/24.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    
    func getFirestoreReference() -> Firestore {
        return db
    }
}
