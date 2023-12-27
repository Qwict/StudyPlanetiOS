//
// Created by Joris Van Duyse on 26/12/2023.
// Based on https://github.com/eyhdev/Animation
//

import SwiftUI

struct StudyScreen: View {
    @State private var timer: Timer?
    @Binding var progress: CGFloat
    @State private var progressTime = 3600
    @State private var progressBar = 0.0
    @State private var isRunning = false
    @State private var barTick = Double(1 / 3600)

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


    public init(selectedTime: Int) {
        self._progress = .constant(CGFloat(selectedTime))
        self.barColor = .white
        startTimer()
    }

    private func startTimer() {
        if isRunning{
            timer?.invalidate()
        } else{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.progressTime -= 1
            }
        }
        isRunning.toggle()
    }



    var body: some View {
        VStack {
//            GeometryReader{ geo in
//                ZStack(alignment: .leading){
//                    Rectangle()
//                            .fill(barColor.opacity(0.3))
//
//                    Rectangle()
//                            .fill(barColor)
//                            .frame(width: min(geo.size.width, geo.size.width * progress))
//                            .animation(.linear)
//                }.cornerRadius(25.0)
//            }

            ProgressView(
                    value: progressBar,
                    label: {
                        Text("Processing...")

                    },
                    currentValueLabel: { Text(progressBar.formatted(.percent.precision(.fractionLength(0)))) }
            )
            .padding()
            .task {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.progressBar += barTick
                }
            }

            HStack(spacing: 10){
                StopWatchUnit(timeUnit: hours, timeUnitText: "HR", color: .black)
                Text(":")
                        .font(.system(size: 48))
                        .offset(y: -18)
                StopWatchUnit(timeUnit: minutes, timeUnitText: "MIN", color: .black)
                Text(":")
                        .font(.system(size: 48))
                        .offset(y: -18)
                StopWatchUnit(timeUnit: seconds, timeUnitText: "SEC", color: .black)
            }

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
                Button(action: {
                    progressTime = 3600
                }) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15.0)
                                .frame(width: 120, height: 50, alignment: .center)
                                .foregroundColor(.gray)
                        Text("Reset")
                                .font(.title)
                                .foregroundColor(.white)
                    }
                }

            }
        }
    }
}

struct StopWatchUnit: View{

    var timeUnit: Int
    var timeUnitText: String
    var color: Color

    var timeUnitStr: String{
        let timeUnitStr = String(timeUnit)
        return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
    }
    var body: some View{
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 15.0)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .fill(color)
                        .frame(width: 75, height: 75, alignment: .center)

                HStack(spacing: 2){
                    Text(timeUnitStr.substring(index: 0))
                            .font(.system(size: 48))
                            .frame(width: 28)

                    Text(timeUnitStr.substring(index: 1))
                            .font(.system(size: 48))
                            .frame(width: 28)
                }
            }
            Text(timeUnitText)
                    .font(.system(size: 16))
        }
    }
}

//struct StopWatch_Previews: PreviewProvider {
//    static var previews: some View {
//        StudyScreen()
//                .preferredColorScheme(.dark)
//    }
//}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}