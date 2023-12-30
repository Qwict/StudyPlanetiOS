//
// Created by Joris Van Duyse on 26/12/2023.
// Based on https://github.com/eyhdev/Animation
//

import SwiftUI

struct StudyScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

//    let planet: PlanetDto
    let planet: Planet
    var selectedTime: Int
    let barTick: Double

    @State private var timer: Timer?
    @Binding var progress: CGFloat
    @State private var progressTime: Int
    @State private var progressBar = 0.0
    @State private var isRunning = false
    @State private var isAccordionExpanded: Bool = true
    @State private var showingExitAlert = true

    var hours: Int { progressTime / 3600 }
    var minutes: Int { (progressTime % 3600) / 60 }
    var seconds: Int { progressTime % 60 }


    @StateObject private var viewModel: StudyViewModel
    init(selectedTime: Int, planet: Planet) {
        _viewModel = StateObject(
                wrappedValue: StudyViewModel()
        )
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
                if progressTime <= 0 {
                    timer?.invalidate()
                    if planet.name == "Galaxy" {
                        viewModel.stopDiscovering(selectedTime: selectedTime)
                    } else {
                        viewModel.stopExploring(remoteId: planet.remoteId, selectedTime: selectedTime)
                    }
                } else {
                    self.progressTime -= 1
                }
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
                    print("Button action")
                    if isRunning{
                        print("isRunning")
                        self.showingExitAlert = true
                    } else{
                        startTimer()
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
        .onAppear() {
            print("onAppear")
            startTimer()
            if (planet.name == "Galaxy") {
                viewModel.startDiscovering(selectedTime: selectedTime)
            } else {
                viewModel.startExploring(remoteId: planet.remoteId, selectedTime: selectedTime)
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
        .alert(isPresented: $viewModel.isActionFinished) {
            Alert(
                title: Text("Finished"),
                message:
                    Text((planet.name == "Galaxy" && viewModel.discoveredPlanet.name != "Galaxy" ?
                            "\(viewModel.discoveredPlanet.name) Discovered!" : "") +
                            "You have gained \(Int(selectedTime / 60)) xp!"
                    ),
                primaryButton: .destructive(
                        Text("Yes"),
                        action: {
                            timer?.invalidate()
                            presentationMode.wrappedValue.dismiss()
                        }
                ),
                secondaryButton: .default(
                        Text("No"),
                        action: {
                            showingExitAlert = false
                        }

                )
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