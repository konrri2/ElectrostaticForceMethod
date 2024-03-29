//
//  Logger.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 14/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation


public enum LoggingLevelMask: Int {
    //standard
    case error   = 0b0000_0001
    case warning = 0b0000_0010
    case info    = 0b0000_0100
    case debug   = 0b0000_1000
    
    //specyfic
    case graphics = 0b0001_0000
    case touches  = 0b0010_0000
    case physics  = 0b0100_0000
    case rx       = 0b1000_0000
    
    case parser   = 0b0001_0000_0000
    
}

let logginLevel = LoggingLevelMask.graphics.rawValue | LoggingLevelMask.parser.rawValue | LoggingLevelMask.warning.rawValue | LoggingLevelMask.error.rawValue

public func isLogginLevelOn(_ level: LoggingLevelMask) -> Bool {
    return (logginLevel & level.rawValue) > 0
}

public func log(_ text: String, level: LoggingLevelMask) {
    if (logginLevel & level.rawValue) > 0 {
        print(text)
    }
}

func logError(_ text: String) {
    log("==  __ERROR__ == " + text, level: LoggingLevelMask.error)
}

func logWarn(_ text: String) {
    log("__WARN __ " + text, level: LoggingLevelMask.warning)
}

public func log(_ text: String) {
    log("_LOG_ " + text, level: LoggingLevelMask.info)
}

func logDebug(_ text: String) {
    log("DEBUG: " + text, level: LoggingLevelMask.debug)
}
func logVerbose(_ text: String) {
    log("_L v_ " + text, level: LoggingLevelMask.debug)
}





func logGraphics(_ text: String) {
    log(text, level: LoggingLevelMask.graphics)
}

func logTouches(_ text: String) {
    log(text, level: LoggingLevelMask.touches)
}

func logPhisic(_ text: String) {
    log(text, level: LoggingLevelMask.physics)
}

func logRx(_ text: String) {
    log("[rx]" + text, level: LoggingLevelMask.rx)
}

func logParser(_ text: String) {
    log("[parser]" + text, level: LoggingLevelMask.parser)
}


