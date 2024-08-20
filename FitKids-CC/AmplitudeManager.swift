//
//  AmplitudeManager.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 8/17/24.
//

import AmplitudeSwift

class AmplitudeManager {
    static let shared = AmplitudeManager()
    
    let amplitude: Amplitude
    
    private init() {
        self.amplitude = Amplitude(configuration: Configuration(
            apiKey: "192faa317821471e70df77ee87380748"
        ))
    }
    
    func track(_ eventName: String, properties: [String: Any]? = nil) {
        amplitude.track(eventType: eventName, eventProperties: properties)
    }
}
