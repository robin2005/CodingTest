//
//  CTLog.swift
//  CodingTest
//
//  Created by jdm on 11/2/24.
//

import Logging

struct CTLog {
    static let log = Logger(label: "CodingTest.main")
    static func info(_ message: String) {
        log.info(Logger.Message(stringLiteral: message))
    }
}
