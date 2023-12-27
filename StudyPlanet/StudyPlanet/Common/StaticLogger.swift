//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation
import os

class StaticLogger {
    public static let log = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: StaticLogger.self)
    )

}
