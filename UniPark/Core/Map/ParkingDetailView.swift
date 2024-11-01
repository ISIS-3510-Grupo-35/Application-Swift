import SwiftUI

struct ParkingDetailView: View {
    var parkingSpot: ParkingSpot
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(parkingSpot.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Text(parkingSpot.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                AsyncImage(url: URL(string: parkingSpot.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding(.bottom)
                } placeholder: {
                    ProgressView()
                        .frame(height: 200)
                }
            
                HStack {
                    Text("Rating: ")
                        .font(.headline)
                    ForEach(0..<Int(parkingSpot.review)) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    if parkingSpot.review < 5 {
                        ForEach(0..<(5 - Int(parkingSpot.review))) { _ in
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                Text("Price information:")
                    .font(.headline)
                Text("$" + String(parkingSpot.priceMinute) + "/min")
                Text("$" + String(parkingSpot.fullRate) + " all day for up to " + String(parkingSpot.durationFullRate) + " hours")
            }
            .padding()
            .navigationTitle("Parking Detail")
            
            Button(action: {
                print("Reserve now tapped!")
                Text("Reservation View")
                //ReservationView()
            }) {
                Text("Reserve now")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            .padding(.horizontal)
        }
    }
}

//#Preview {
    //None
//}
