//
// Created by Joris Van Duyse on 30/12/2023.
//

import Foundation
import SwiftyBeaver

class SPLogger {
    static let shared = SPLogger()

    private let logger: SwiftyBeaver.Type

    private init() {
        logger = SwiftyBeaver.self
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss$d $L $M"
        logger.addDestination(console)
    }

    func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.verbose(message, file: file, function: function, line: line)
    }

    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.debug(message, file: file, function: function, line: line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.info(message, file: file, function: function, line: line)
    }

    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.warning(message, file: file, function: function, line: line)
    }

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.error(message, file: file, function: function, line: line)
    }
}
