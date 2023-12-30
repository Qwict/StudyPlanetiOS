//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation

/// View model responsible for authentication-related operations.
class MainViewModel : ObservableObject {

    @Inject
    private var studyPlanetRepository: StudyPlanetRepositoryProtocol

    @Published var user: UserEntity = UserEntity()
    @Published var currentLevel: Int = 0
    @Published var experienceForNextLevel: Int = 0
    @Published var experienceProgress: Float = 0.0

    init() {
        getLocalUser()
    }

    func getLocalUser() {
        studyPlanetRepository.getLocalUser() { result in
            switch result {
            case .success(let user):
                self.user = user
                self.levelCalculator()
            case .failure(let error):
                print(error)
            }
        }
    }

    func levelCalculator() {
        print("Calculating level")
        let currentLevel = ceil(log2(Double(user.experience) / 60))
        let experienceForCurrentLevel = pow(2.0, currentLevel - 1) * 60
        let experienceForNextLevel = pow(2.0, currentLevel) * 60 - Double(user.experience) + experienceForCurrentLevel
        let experienceProgress = (Double(user.experience) - experienceForCurrentLevel) / experienceForNextLevel

        if user.experience == 0 {
            self.currentLevel = 0
            self.experienceForNextLevel = 2
        } else {
            self.currentLevel = Int(currentLevel)
            self.experienceForNextLevel = Int(experienceForNextLevel)
            self.experienceProgress = Float(experienceProgress)
        }
    }

}