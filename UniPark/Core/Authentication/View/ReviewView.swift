//
//  ReviewView.swift
//  UniPark
//
//  Created by Tomas Angel on 26/09/24.
//

import Foundation
import SwiftUI

struct ReviewView: View {
    @State var parkingSpot: ParkingDetail
    @State var review: Review
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack {
            Text(parkingSpot.name)
                .font(.tittle)
                .bold()
                .multilineTextAlignment(.leading)
                .lineLimit(1)
            Text(parkingSpot.address)
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(parkingSpot: "El mono", review: Review())
    }
}
