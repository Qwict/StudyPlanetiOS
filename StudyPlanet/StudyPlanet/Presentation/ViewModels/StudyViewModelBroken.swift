////
//// Created by Joris Van Duyse on 28/12/2023.
////
//
//import Foundation
//
//class StudyViewModelBroken: ObservableObject {
//    @Inject
//    private var studyPlanetRepository: StudyPlanetRepositoryProtocol
//
//    @Published var loading: Bool = true
//    @Published var isActionFinished: Bool = false
//    @Published var discoveredPlanet: Planet = Planet(remoteId: 0, name: "Galaxy")
//    @Published var completedStartRequest: Bool = false
//    @Published var completedStopRequest: Bool = false
//
//    let planet: Planet
//    var selectedTime: Int
//    let barTick: Double
//
//    @Published var timer: Timer?
////    @Published var progress: CGFloat
//    @Published var progressTime: Int
//    @Published var progressBar = 0.0
////    @State private var isRunning = false
//
//    init(selectedTime: Int, planet: Planet) {
//        print("StudyViewModel init")
//        self._progressTime = .init(initialValue: selectedTime)  // Initialize progressTime here
//        self.selectedTime = selectedTime
//        self.planet = planet
//        self.barTick = selectedTime > 0 ? 1 / Double(selectedTime) : 0
//        self.sendRequest()
//    }
//
//    func startExploring(remoteId: Int, selectedTime: Int) {
//        studyPlanetRepository.startExploring(
//                exploreDto: ExploreDto(
//                        planetId: remoteId,
//                        selectedTime: selectedTime
//                )
//        ) { result in
//            switch result {
//                case .success(let emptyResponse):
//                    print("Started exploring")
//                case .failure(let error):
//                    print(error)
//                }
//        }
//    }
//
//    func stopExploring(remoteId: Int, selectedTime: Int) {
//        studyPlanetRepository.stopExploring(
//                exploreDto: ExploreDto(
//                        planetId: remoteId,
//                        selectedTime: selectedTime
//                )
//        ) { result in
//            switch result {
//                case .success(let exploreResponse):
//                    print(exploreResponse)
//                case .failure(let error):
//                    print(error)
//                }
//        }
//    }
//
//    func startDiscovering(selectedTime: Int) {
//        studyPlanetRepository.startDiscovering(
//                discoverDto: DiscoverDto(selectedTime: selectedTime)
//        ) { result in
//            switch result {
//                case .success(let emptyResponse):
//                    self.completedStartRequest = true
//                    self.startTimer()
//                    print("Started discovering")
//
//                case .failure(let error):
//                    print(error)
//                }
//        }
//    }
//
//    func stopDiscovering(selectedTime: Int) {
//        studyPlanetRepository.stopDiscovering(
//                discoverDto: DiscoverDto(selectedTime: selectedTime)
//        ) { result in
//            switch result {
//                case .success(let discoverResponse):
//                    print(discoverResponse.discovered ? "Discovered" : "Not discovered")
//                    if discoverResponse.discovered {
//                        self.discoveredPlanet = Planet(
////                                TODO: Fix this
//                                remoteId: discoverResponse.id ?? 0,
//                                name: discoverResponse.name ?? "Galaxy"
//                        )
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//        }
//    }
//
//    private func sendRequest() {
//
//        if (self.planet.name == "Galaxy") {
//            print("Started discovering")
//            startDiscovering(selectedTime: selectedTime)
//        } else {
//            print("Started exploring")
//            startExploring(remoteId: planet.remoteId, selectedTime: selectedTime)
//        }
//
//
//    }
//
//    private func startTimer() {
//        print("initializing timer")
////        if (!completedStartRequest) {
////            timer?.invalidate()
////        } else{
//            print("startTimer")
//            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                print("timer: \(self.progressTime)")
//                if self.progressTime <= 0 {
//                    self.timer?.invalidate()
//                    if self.planet.name == "Galaxy" {
//                        self.stopDiscovering(selectedTime: self.selectedTime)
//                    } else {
//                        self.stopExploring(remoteId: self.planet.remoteId, selectedTime: self.selectedTime)
//                    }
//                }
//                self.progressTime -= 1
////            }
//        }
//    }
//}
