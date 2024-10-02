import SwiftUI

struct ReservationView: View {
    @State private var licensePlate = ""
    @State private var selectedDay = "Monday"
    
    // Arrival time states
    @State private var selectedHourArrival = 0
    @State private var selectedMinuteArrival = 0
    
    // Departure time states
    @State private var selectedHourDeparture = 0
    @State private var selectedMinuteDeparture = 0
    
    @State private var parkingLotId = 001
    @State private var userId = 11223344
    @State private var isReservationSuccessful = false // State to control navigation
    
    @EnvironmentObject var reservationViewModel: ReservationViewModel // Reservation ViewModel

    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        NavigationStack { // Wrap content in a NavigationStack
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                VStack {
                    Text("Reservation")
                        .font(.title)
                    VStack(alignment: .leading, spacing: 24) {
                        // License plate input
                        InputView(text: $licensePlate, title: "License Plate", placeHolder: "ABC-123")
                            .autocapitalization(.allCharacters)
                            .keyboardType(.default)
                        
                        // Picker for days of the week
                        Text("Select the day of the week")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.darkGray))
                            .fontWeight(.semibold)
                        
                        Picker("Select Day", selection: $selectedDay) {
                            ForEach(daysOfWeek, id: \.self) { day in
                                Text(day).tag(day)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                        
                        // Time picker for arrival
                        Text("Select time of arrival")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.darkGray))
                            .fontWeight(.semibold)
                        
                        HStack {
                            // Hour picker for arrival
                            Picker("Arrival Hours", selection: $selectedHourArrival) {
                                ForEach(0..<24, id: \.self) { hour in
                                    Text("\(hour) hr").tag(hour)
                                }
                            }
                            .frame(maxWidth: 150)
                            .clipped()
                            
                            // Minute picker for arrival
                            Picker("Arrival Minutes", selection: $selectedMinuteArrival) {
                                ForEach(0..<60, id: \.self) { minute in
                                    Text("\(minute) min").tag(minute)
                                }
                            }
                            .frame(maxWidth: 150)
                            .clipped()
                        }
                        
                        // Time picker for departure
                        Text("Select time of departure")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.darkGray))
                            .fontWeight(.semibold)
                        
                        HStack {
                            // Hour picker for departure
                            Picker("Departure Hours", selection: $selectedHourDeparture) {
                                ForEach(0..<24, id: \.self) { hour in
                                    Text("\(hour) hr").tag(hour)
                                }
                            }
                            .frame(maxWidth: 150)
                            .clipped()
                            
                            // Minute picker for departure
                            Picker("Departure Minutes", selection: $selectedMinuteDeparture) {
                                ForEach(0..<60, id: \.self) { minute in
                                    Text("\(minute) min").tag(minute)
                                }
                            }
                            .frame(maxWidth: 150)
                            .clipped()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 13)
                    
                    // Reservation button
                    Button {
                        Task {
                            let arrivalTime = "\(selectedDay), \(selectedHourArrival):\(String(format: "%02d", selectedMinuteArrival)):00"
                            let departureTime = "\(selectedDay), \(selectedHourDeparture + 6):\(String(format: "%02d", selectedMinuteDeparture)):00" // Assuming 6 hours parking duration

                            do {
                                try await reservationViewModel.createReservation(
                                    arrivalTime: arrivalTime,
                                    departureTime: departureTime,
                                    licensePlate: licensePlate,
                                    parkingId: parkingLotId,
                                    userId: userId
                                )
                                print("Reservation successful!")
                                isReservationSuccessful = true // Set state to true on success
                            } catch {
                                print("Error creating reservation: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        HStack {
                            Text("Make Reservation")
                                .fontWeight(.semibold)
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    // NavigationLink to go to ReservationInfoView after successful reservation
                    NavigationLink(destination: ReservationInfoView(), isActive: $isReservationSuccessful) {
                        EmptyView() // Hidden link
                    }
                }
            }
        }
    }
}

#Preview {
    ReservationView()
        .environmentObject(ReservationViewModel()) // Inject the ReservationViewModel for preview
}
