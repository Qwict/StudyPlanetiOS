////
//// Created by Joris Van Duyse on 26/12/2023.
//// Based on https://github.com/eyhdev/Animation
////
//
//import SwiftUI
//
//struct StudyScreenBroken: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//
//    @StateObject private var viewModel: StudyViewModel
//    init(selectedTime: Int, planet: Planet) {
//        SPLogger.shared.debug("StudyScreen init")
//        _viewModel = StateObject(
//                wrappedValue: StudyViewModel(selectedTime: selectedTime, planet: planet)
//        )
//        self._progress = .constant(CGFloat(selectedTime))
////        self._progressTime = .init(initialValue: selectedTime)  // Initialize progressTime here
////        self.selectedTime = selectedTime
////        self.planet = planet
////        self.barTick = selectedTime > 0 ? 1 / Double(selectedTime) : 0
//    }
//
////    let planet: Planet
////    var selectedTime: Int
////    let barTick: Double
//
////    @State private var timer: Timer?
//    @Binding var progress: CGFloat
////    @State private var progressTime: Int
////    @State private var progressBar = 0.0
//////    @State private var isRunning = false
//    @State private var isAccordionExpanded: Bool = true
//    @State private var showingExitAlert = false
//
//    var hours: Int { viewModel.progressTime / 3600 }
//    var minutes: Int { (viewModel.progressTime % 3600) / 60 }
//    var seconds: Int { viewModel.progressTime % 60 }
//
//    private func startTimer() {
//        SPLogger.shared.debug("startTimer")
//
//        if (planet.name == "Galaxy") {
//            SPLogger.shared.debug("Started discovering")
//            viewModel.startDiscovering(selectedTime: selectedTime)
//        } else {
//            SPLogger.shared.debug("Started exploring")
//            viewModel.startExploring(remoteId: planet.remoteId, selectedTime: selectedTime)
//        }
//
//        if (!viewModel.completedStartRequest) {
//            timer?.invalidate()
//        } else{
//            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                SPLogger.shared.debug("timer: \(progressTime)")
//                if progressTime <= 0 {
//                    timer?.invalidate()
//                    if planet.name == "Galaxy" {
//                        viewModel.stopDiscovering(selectedTime: selectedTime)
//                    } else {
//                        viewModel.stopExploring(remoteId: planet.remoteId, selectedTime: selectedTime)
//                    }
//                }
//                self.progressTime -= 1
//            }
//        }
////    }
//
//
//
//    var body: some View {
//        VStack {
//            Text(viewModel.planet.name)
//                    .font(.title)
//                    .padding()
//            VStack {
//                PlanetImage(planet: viewModel.planet)
//                let progressBarProgression = 1 - Double(viewModel.progressTime) / Double(viewModel.selectedTime)
//                let percentageProgression = progressBarProgression * 100
//                ProgressView(
//                        value: progressBarProgression,
//                        label: { Text("Progress...") },
//                        currentValueLabel: {
//                            Text(percentageProgression < 0 ? "0%" : "\(Int(percentageProgression))%")
//                                    .foregroundColor(.gray)
//                        }
//                )
//                        .padding(.horizontal)
//
//                VStack {
//                    DisclosureGroup("Remaining time", isExpanded: $isAccordionExpanded) {
//                        HStack {
//                            StopWatchUnit(timeUnit: hours, timeUnitText: "HR", color: .black)
//                            Text(":")
//                            StopWatchUnit(timeUnit: minutes, timeUnitText: "MIN", color: .black)
//                            Text(":")
//                            StopWatchUnit(timeUnit: seconds, timeUnitText: "SEC", color: .black)
//                        }
//                    }
//                            .accentColor(.black)
//                            .padding()
//                            .frame(width: 300, height: 70, alignment: .center)
//                }
//            }
//                    .background(
////                            UIImage(named: planet.name + "Small")?.averageColor?.asColor.opacity(0.5)
////                                    ??
//                            .black.opacity(0.1)
//                    )
//                    .cornerRadius(20)
//                    .padding(.horizontal)
//                    .blur(radius: viewModel.completedStartRequest && !showingExitAlert ? 0 : 3)
//
//
//
//
//            HStack{
//                Button(action: {
//                    if viewModel.completedStartRequest {
//                        showingExitAlert = true
//                    } else{
//                        if (viewModel.planet.name == "Galaxy") {
//                            viewModel.startDiscovering(selectedTime: viewModel.selectedTime)
//                        } else {
//                            viewModel.startExploring(remoteId: viewModel.planet.remoteId, selectedTime: viewModel.selectedTime)
//                        }
//                    }
//                }) {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 15.0)
//                                .frame(width: 120, height: 50, alignment: .center)
//                                .foregroundColor(viewModel.completedStartRequest ? .gray.opacity(0.2) : .white)
//
//                        Text(viewModel.completedStartRequest ? "Exit" : "Start")
//                                .font(.title)
//                                .foregroundColor(.black)
//                    }
//                }
//            }
//        }
////                .onAppear() {
////                    SPLogger.shared.debug("onAppear")
////                    viewModel.startDiscovering(selectedTime: viewModel.selectedTime)
////                    if (viewModel.completedStartRequest) {
////                        if (viewModel.planet.name == "Galaxy") {
////                            viewModel.startDiscovering(selectedTime: viewModel.selectedTime)
////                        } else {
////                            viewModel.startExploring(remoteId: viewModel.planet.remoteId, selectedTime: viewModel.selectedTime)
////                        }
////                    } else {
////                        viewModel.completedStartRequest = false
////                    }
////                }
//                .alert(isPresented: $showingExitAlert) {
//                    Alert(
//                            title: Text("Stop studying?"),
//                            message: Text(
//                                    "Are you sure you want to stop" +
//                                            (viewModel.planet.name == "Galaxy" ? "" : " studying on \(viewModel.planet.name)") +
//                                            "?\n \(Int((viewModel.selectedTime - viewModel.progressTime) / 60)) xp will be lost from this session."
//                            ),
//                            primaryButton: .destructive(
//                                    Text("Yes"),
//                                    action: {
//                                        viewModel.timer?.invalidate()
//                                        presentationMode.wrappedValue.dismiss()
//                                    }
//                            ),
//                            secondaryButton: .default(
//                                    Text("No"),
//                                    action: {
//                                        showingExitAlert = false
//                                    }
//
//                            )
//                    )
//                }
//                .alert(isPresented: $viewModel.isActionFinished) {
//                    Alert(
//                            title: Text("Finished"),
//                            message:
////                            VStack {
////                                if (viewModel.hasDiscoveredPlanet) {
////                                    PlanetImage(planet: viewModel.discoveredPlanet)
////                                            .frame(width: 100, height: 100, alignment: .center)
////                                            .padding()
//                                    Text((viewModel.planet.name == "Galaxy" && viewModel.discoveredPlanet.name != "Galaxy" ?
//                                            "\(viewModel.discoveredPlanet.name) Discovered!" : "") +
//                                            "You have gained \(Int(viewModel.selectedTime / 60)) xp!"
//                                    ),
////                                } else {
////                                    PlanetImage(planet: planet)
////                                            .frame(width: 100, height: 100, alignment: .center)
////                                            .padding()
////                                    Text(
////
////                                            "\nYou have gained \(Int(selectedTime / 60)) xp!"
////                                    )
////                                            .font(.title2)
//                            primaryButton: .destructive(
//                                    Text("Yes"),
//                                    action: {
//                                        viewModel.timer?.invalidate()
//                                        presentationMode.wrappedValue.dismiss()
//                                    }
//                            ),
//                            secondaryButton: .default(
//                                    Text("No"),
//                                    action: {
//                                        showingExitAlert = false
//                                    }
//
//                            )
//                    )
//                }
//    }
//
//}
//
////extension String {
////    func substring(index: Int) -> String {
////        let arrayString = Array(self)
////        return String(arrayString[index])
////    }
////}