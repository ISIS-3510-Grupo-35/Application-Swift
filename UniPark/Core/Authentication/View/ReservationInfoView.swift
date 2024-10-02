//
//  ReservationInfoView.swift
//  UniPark
//
//  Created by Tomas Angel on 2/10/24.
//

import Foundation
import SwiftUI

struct ReservationInfoView: View {
    //@EnvironmentObject var reservationViewModel: ResViewModel // Uncomment and use your view model
    
    var body: some View {
        //if let reservation = reservationViewModel.currentReservation { // Uncomment when using the ViewModel
        let reservation = Reservation.MOCK_RESERVATION // For preview purposes, replace with actual data from ViewModel
        
        VStack {
            Text("Reservation")
                .font(.title)
                .fontWeight(.bold)
            List {
                Section {
                    HStack {
                        //Text("Reservation ID")
                        Text("Reservation ID")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(reservation.id)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        //Text("License Plate")
                        Text("License Plate")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(reservation.licensePlate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        //Text("Arrival Time")
                        Text("Arrival Time")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(reservation.arrivalTime)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        //Text("Departure Time")
                        Text("Departure Time")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(reservation.departureTime)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        //Text("Parking Lot ID")
                        Text("Parking Lot ID")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(reservation.parkingId)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        //Text("User ID")
                        Text("User ID")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(reservation.userId)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Actions") {
                    Button {
                        print("Cancel reservation...")
                        // Add your logic here, e.g., cancel reservation from Firestore
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Cancel Reservation", tintColor: .red)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        //}
        .background(Color(.yellow))
    }

}

struct ReservationInfoView_Preview: PreviewProvider {
    static var previews: some View {
        // Uncomment the environment object once you have your ViewModel ready
        // let reservationViewModel = ResViewModel()
        ReservationInfoView()
        // .environmentObject(reservationViewModel) // Add the environment object when needed
    }
}
