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
    @State private var showingExitAlert = false

    var hours: Int { progressTime / 3600 }
    var minutes: Int { (progressTime % 3600) / 60 }
    var seconds: Int { progressTime % 60 }


    @StateObject private var viewModel: StudyViewModel
    init(selectedTime: Int, planet: Planet) {
        _viewModel = StateObject(
                wrappedValue: StudyViewModel()
        )
        SPLogger.shared.debug("StudyScreen init")
        self._progress = .constant(CGFloat(selectedTime))
        self._progressTime = .init(initialValue: selectedTime)  // Initialize progressTime here
        self.selectedTime = selectedTime
        self.planet = planet
        self.barTick = selectedTime > 0 ? 1 / Double(selectedTime) : 0
    }

    private func startTimer() {
        SPLogger.shared.debug("Started Timer")
        if isRunning{
            timer?.invalidate()
        } else{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if progressTime <= 0 {
                    timer?.invalidate()
                    if planet.name == "Galaxy" {
                        viewModel.stopDiscovering(selectedTimeInSeconds: selectedTime)
                    } else {
                        viewModel.stopExploring(remoteId: planet.remoteId, selectedTimeInSeconds: selectedTime)
                    }
                } else {
                    self.progressTime -= 1
                }
            }
        }
        isRunning.toggle()
    }



    var body: some View {
        ZStack {
            bodyContent
                    .blur(radius: viewModel.isActionFinished ? 10 : 0)
            VStack {
                Text("Finished")
                        .font(.title)
                        .padding(.top)
                PlanetImage(planet: planet.name == "Galaxy" ? viewModel.discoveredPlanet : planet)
                if (planet.name == "Galaxy") {
                    Text(planet.name == "Galaxy" && viewModel.discoveredPlanet.name != "Galaxy" ?
                            "\(viewModel.discoveredPlanet.name) Discovered!" : "No Planet was found"
                    )
                } else {
                    Text("You explored \(planet.name)")
                }
                Text("Gained \(Int(selectedTime / 60)) xp")
                Button(action: {
                    timer?.invalidate()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15.0)
                                .frame(width: 120, height: 50, alignment: .center)
                                .foregroundColor(.white)

                        Text("Exit")
                                .font(.title)
                                .foregroundColor(.black)
                    }
                }
                        .padding(.bottom)
            }
                    .background(.gray.opacity(0.5))
                    .cornerRadius(20)
                    .padding()
                    .opacity(viewModel.isActionFinished ? 1 : 0)
        }

    }

    var bodyContent: some View {
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




            HStack {
                    Button(action: {
                        self.showingExitAlert = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.0)
                                    .frame(width: 120, height: 50, alignment: .center)
                                    .foregroundColor(.white)

                            Text("Exit")
                                    .font(.title)
                                    .foregroundColor(.black)
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
//                    Button(action: {
//                        SPLogger.shared.debug("Button action")
//                        startTimer()
//                    }) {
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 15.0)
//                                    .frame(width: 120, height: 50, alignment: .center)
//                                    .foregroundColor(.white)
//
//                            Text("Start")
//                                    .font(.title)
//                                    .foregroundColor(.black)
//                        }
//                    }
                }
//                Button(action: {
//                    SPLogger.shared.debug("Button action")
//                    if isRunning{
//                        SPLogger.shared.debug("isRunning")
//                        self.showingExitAlert = true
//                    } else{
//                        startTimer()
//                    }
//                }) {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 15.0)
//                                .frame(width: 120, height: 50, alignment: .center)
//                                .foregroundColor(isRunning ? .gray.opacity(0.2) : .white)
//
//                        Text(isRunning ? "Exit" : "Start")
//                                .font(.title)
//                                .foregroundColor(.black)
//                    }
//                }
            }
                .onAppear() {
                    SPLogger.shared.debug("onAppear")
                    startTimer()
                    if (planet.name == "Galaxy") {
                        viewModel.startDiscovering(selectedTimeInSeconds: selectedTime)
                    } else {
                        viewModel.startExploring(remoteId: planet.remoteId, selectedTimeInSeconds: selectedTime)
                    }
                }
    }
}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}