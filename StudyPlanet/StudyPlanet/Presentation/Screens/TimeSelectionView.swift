//
// Created by Joris Van Duyse on 26/12/2023.
//

import SwiftUI

struct TimeSelectionView: View {
    let planet: PlanetDto
    @State private var selectedTime: Int = 0
    @State private var availableTimes = [
        "30 minutes": 1800,
        "1 hour": 3600,
        "2 hours": 7200
    ]

    //TODO: make this live thu screen changes
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 30

    var columns = [
        MultiComponentPicker.Column(
                label: "h",
                options: Array(0...4).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }
        ),
        MultiComponentPicker.Column(
                label: "min",
                options: Array(0...59).map{ MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }
        ),
    ]

    var body: some View {
        VStack {
            VStack {
                PlanetCard(planet: planet)

                MultiComponentPicker(
                        columns: columns,
                        selections: [$selectedHour, $selectedMinute]
//                        selections: [
//                            .constant(hours),
//                            .constant(minutes)
//                        ]
                )
            }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                    .padding(.horizontal)

            NavigationLink {
                StudyScreen(
                        selectedTime: selectedHour * 3600 + selectedMinute * 60,
                        planet: planet
                )
                        .navigationBarBackButtonHidden()
            } label: {
                Text("Select")
                        .font(.title)
                        .padding()
            }
                    .disabled(selectedHour == 0 && selectedMinute == 0)

        }
    }

}
