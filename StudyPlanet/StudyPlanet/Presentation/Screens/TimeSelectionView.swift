//
// Created by Joris Van Duyse on 26/12/2023.
//

import SwiftUI

struct TimeSelectionView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    @State private var selectedTime: Int = 0
    @State private var availableTimes = [
        "30 minutes": 1800,
        "1 hour": 3600,
        "2 hours": 7200
    ]

    var body: some View {
        VStack {
            Text("Select your time")
                .font(.title)
                .padding()

            Picker(selection: $selectedTime, label: Text("Select your time")) {
                ForEach(0 ..< 3) {
                    Text(Array(availableTimes.keys)[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            NavigationLink {
                StudyScreen(selectedTime: 1800)
                        .navigationBarBackButtonHidden()
            } label: {
                    Text("Select")
                            .font(.title)
                            .padding()
            }

        }
    }

}
