//
//  Logger.swift
//  GameOfThrones
//
//  Created by Emin on 10.09.2022.
//

import Foundation


import SwiftyBeaver
struct Logger {

    static let log = SwiftyBeaver.self
    
    static func startLogger(){
        // We may use different targets later
        #if DEBUG
        setDestinations()
        #endif
    }
    
    
    private static func setDestinations(){
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console

        formatLevelColors(destionation: console)
        formatLogText(destination: console)
        log.addDestination(console)
    }
    
    private static func formatLevelColors(destionation:BaseDestination){
        destionation.levelColor.error = "❌"
        destionation.levelColor.warning = "⚠️"
        destionation.levelColor.debug = ""
        destionation.levelColor.info = ""
        destionation.levelColor.verbose = ""
    }
    
    private static func formatLogText(destination:BaseDestination){
        destination.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $T $C$L$c $N - $F : $M $X"
    }
    
}
