//
// Created by Joris Van Duyse on 26/12/2023.
//

import SwiftUI

struct TimeSelectionView: View {
    let planet: PlanetDto
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
                VStack {
                    Text("Select")
                            .font(.title)
                    if selectedHour == 0 && selectedMinute < 15 {
                        Text("Selected time must be at least 15 minutes.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                    } else {
                        Text("Estimated experience gained: \(selectedHour * 60 + selectedMinute)xp")
                                .font(.caption)
                                .foregroundColor(.secondary)
                    }
                }
                        .frame(height: 50)
                        .padding()
                        .accentColor(.black)

            }
                    .disabled(selectedHour == 0 && selectedMinute < 15)

        }
    }

}
