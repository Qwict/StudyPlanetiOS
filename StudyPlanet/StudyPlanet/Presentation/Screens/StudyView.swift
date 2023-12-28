//
// Created by Joris Van Duyse on 26/12/2023.
// Based on https://github.com/eyhdev/Animation
//

import SwiftUI

struct StudyScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let planet: PlanetDto
    var selectedTime: Int
    let barTick: Double

    @State private var timer: Timer?
    @Binding var progress: CGFloat
    @State private var progressTime: Int
    @State private var progressBar = 0.0
    @State private var isRunning = false
    @State private var isAccordionExpanded: Bool = true
    @State private var showingExitAlert = false

    var hours: Int { progressTime / 3600 }
    var minutes: Int { (progressTime % 3600) / 60 }
    var seconds: Int { progressTime % 60 }


    init(selectedTime: Int, planet: PlanetDto) {
        print("StudyScreen init")
        self._progress = .constant(CGFloat(selectedTime))
        self._progressTime = .init(initialValue: selectedTime)  // Initialize progressTime here
        self.selectedTime = selectedTime
        self.planet = planet
        self.barTick = selectedTime > 0 ? 1 / Double(selectedTime) : 0
    }

    private func startTimer() {
        print("startTimer")
        if isRunning{
            print("isRunning")
            timer?.invalidate()
        } else{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                print("timer: \(progressTime)")
                self.progressTime -= 1
            }
        }
        isRunning.toggle()
    }



    var body: some View {
        VStack {
            Text(planet.name)
                    .font(.title)
                    .padding()
            VStack {
                PlanetImage(planet: planet)
                let progressBarProgression = 1 - Double(progressTime) / Double(selectedTime)
                let percentageProgression = progressBarProgression * 100
                ProgressView(
                        value: progressBarProgression,
                        label: { Text("Progress...") },
                        currentValueLabel: {
                            Text(percentageProgression < 0 ? "0%" : "\(Int(percentageProgression))%")
                                    .foregroundColor(.gray)
                        }
                )
                        .padding(.horizontal)

                VStack {
                    DisclosureGroup("Remaining time", isExpanded: $isAccordionExpanded) {
                        HStack {
                            StopWatchUnit(timeUnit: hours, timeUnitText: "HR", color: .black)
                            Text(":")
                            StopWatchUnit(timeUnit: minutes, timeUnitText: "MIN", color: .black)
                            Text(":")
                            StopWatchUnit(timeUnit: seconds, timeUnitText: "SEC", color: .black)
                        }
                    }
                            .accentColor(.black)
                            .padding()
                            .frame(width: 300, height: 70, alignment: .center)
                }
            }
                    .background(
//                            UIImage(named: planet.name + "Small")?.averageColor?.asColor.opacity(0.5)
//                                    ??
                                    .black.opacity(0.1)
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .blur(radius: isRunning ? 0 : 5)




            HStack{
                Button(action: {
                    if isRunning{
                        showingExitAlert = true
                    } else{
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                            self.progressTime -= 1
                            self.progressBar += barTick
                        })
                        isRunning.toggle()
                    }
                }) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15.0)
                                .frame(width: 120, height: 50, alignment: .center)
                                .foregroundColor(isRunning ? .gray.opacity(0.2) : .white)

                        Text(isRunning ? "Exit" : "Start")
                                .font(.title)
                                .foregroundColor(.black)
                    }
                }
            }
        }
        .alert(isPresented: $showingExitAlert) {
            Alert(
                    title: Text("Exit"),
                    message: Text("Are you sure you want to stop" + (planet.name == "Galaxy" ? "" : " studying on \(planet.name)") + "?"),
                    primaryButton: .destructive(
                            Text("Yes"),
                            action: {
                                timer?.invalidate()
                                presentationMode.wrappedValue.dismiss()
                            }
                    ),
                    secondaryButton: .default(Text("No"))
            )
        }
    }
}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}