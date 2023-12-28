//
// Created by Joris Van Duyse on 26/12/2023.
// Based on https://github.com/eyhdev/Animation
//

import SwiftUI

struct StudyScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let planet: PlanetDto
    var selectedTime: Int

    @State private var timer: Timer?
    @Binding var progress: CGFloat
    @State private var progressTime: Int
    @State private var progressBar = 0.0
    @State private var isRunning = false
    @State private var barTick = Double(1 / 3600)

    @State var isAccordionExpanded: Bool = true
    @State private var showingExitAlert = false

    private var barColor: Color
    private var animationTime: TimeInterval = 0.3

    var hours: Int {
        progressTime / 3600
    }

    var minutes: Int {
        (progressTime % 3600) / 60
    }

    var seconds: Int {
        progressTime % 60
    }


    init(selectedTime: Int, planet: PlanetDto) {
        print("StudyScreen init")
        self._progress = .constant(CGFloat(selectedTime))
        self._progressTime = .init(initialValue: selectedTime)  // Initialize progressTime here
        self.selectedTime = selectedTime
        self.planet = planet
        self.barColor = .white
//        self.isRunning = true
//        startTimer()
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
                        label: {
                            Text("Progress...")

                        },
                        currentValueLabel: {
                            Text(percentageProgression < 0 ? "0%" : "\(Int(percentageProgression))%")
                                    .foregroundColor(.gray)
                        }

                )
                        .padding(.horizontal)
                        .task {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                self.progressBar += barTick
                            }
                        }
                VStack {
                    DisclosureGroup("Remaining time", isExpanded: $isAccordionExpanded) {
                        HStack(spacing: 10) {
                            StopWatchUnit(timeUnit: hours, timeUnitText: "HR", color: .black)
                            Text(":")
//                        .font(.system(size: 48))
//                        .offset(y: -18)
                            StopWatchUnit(timeUnit: minutes, timeUnitText: "MIN", color: .black)
                            Text(":")
//                        .font(.system(size: 48))
//                        .offset(y: -18)
                            StopWatchUnit(timeUnit: seconds, timeUnitText: "SEC", color: .black)
                        }
                    }.accentColor(.black)
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
//                    .shadow(color: Color.black, radius: 4)
                    .padding(.horizontal)




            HStack{
                Button(action: {
                    if isRunning{
                        timer?.invalidate()
                    } else{
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                            progressTime -= 1
                        })
                    }
                    isRunning.toggle()
                }) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15.0)
                                .frame(width: 120, height: 50, alignment: .center)
                                .foregroundColor(isRunning ? .orange : .white)

                        Text(isRunning ? "Stop" : "Start")
                                .font(.title)
                                .foregroundColor(.black)
                    }
                }
//                Button(action: {
//                    progressTime = 3600
//                }) {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 15.0)
//                                .frame(width: 120, height: 50, alignment: .center)
//                                .foregroundColor(.gray)
//                        Text("Reset")
//                                .font(.title)
//                                .foregroundColor(.white)
//                    }
//                }
                Button(action: {
                    showingExitAlert = true
                }) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0)
                                .frame(width: 96, height: 45, alignment: .center)
                                .foregroundColor(.gray)
                        Text("Exit")
                                .font(.title2)
                                .foregroundColor(.white)
                    }
                }
            }
        }
        .alert(isPresented: $showingExitAlert) {
            Alert(
                    title: Text("Exit"),
                    message: Text("Are you sure you want to stop" + (planet.name == "Galaxy" ? "" : " studying on \(planet.name)") + "?"),
                    primaryButton: .destructive(Text("Yes"), action: {
                        presentationMode.wrappedValue.dismiss()
                    }),
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