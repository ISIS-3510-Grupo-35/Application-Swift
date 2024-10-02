//
//  SideMenuOptionModel.swift
//  UniPark
//
//  Created by Tomas Angel on 1/10/24.
//

import Foundation

enum SideMenuOptionModel: Int, CaseIterable {
    case profile
    case searchParkingLot
    case favoriteParkingLot
    case reservations
    
    var title: String{
        switch self {
        case .profile:
            return "Profile"
        case .searchParkingLot:
            return "Search parking lots"
        case .favoriteParkingLot:
            return "Favorites"
        case .reservations:
            return "Reservations"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .profile:
            return "person.fill"
        case .searchParkingLot:
            return "magnifyingglass"
        case .favoriteParkingLot:
            return "heart.fill"
        case .reservations:
            return "car.fill"
        }
    }
}

extension SideMenuOptionModel: Identifiable{
    var id: Int{return self.rawValue}
}
