//
//  CameraConstans.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 18/05/22.
//

import Foundation
import AVFoundation

enum Kelvin: Float {
    case candle         = 2000  // 1000-2000K  raises exception because out of range
    case tungsten       = 3200  // 2500-3500K
    case sunrise        = 3500  // 3000-4000K
    case flourescent    = 4500  // 4000-5000K
    case flash          = 5000  // 5000-5500K
    case daylight       = 6000  // 5000-6000K
    case cloudy         = 7000  // 6500-8000K
    case shade          = 9000  // 9000-10000K
}
struct CameraConstants {
    
    static let ExposureDurationValues = [CMTimeMake(value: 1, timescale: 10000), CMTimeMake(value: 1, timescale: 8000), CMTimeMake(value: 1, timescale: 6400), CMTimeMake(value: 1, timescale: 5000), CMTimeMake(value: 1, timescale: 4000), CMTimeMake(value: 1, timescale: 3200), CMTimeMake(value: 1, timescale: 2500), CMTimeMake(value: 1, timescale: 2000), CMTimeMake(value: 1, timescale: 1600), CMTimeMake(value: 1, timescale: 1250), CMTimeMake(value: 1, timescale: 1000), CMTimeMake(value: 1, timescale: 800), CMTimeMake(value: 1, timescale: 640), CMTimeMake(value: 1, timescale: 500), CMTimeMake(value: 1, timescale: 400), CMTimeMake(value: 1, timescale: 320), CMTimeMake(value: 1, timescale: 250), CMTimeMake(value: 1, timescale: 200), CMTimeMake(value: 1, timescale: 160), CMTimeMake(value: 1, timescale: 125), CMTimeMake(value: 1, timescale: 100), CMTimeMake(value: 1, timescale: 80), CMTimeMake(value: 1, timescale: 60), CMTimeMake(value: 1, timescale: 50), CMTimeMake(value: 1, timescale: 40), CMTimeMake(value: 1, timescale: 30), CMTimeMake(value: 1, timescale: 25), CMTimeMake(value: 1, timescale: 20), CMTimeMake(value: 1, timescale: 15), CMTimeMake(value: 1, timescale: 13), CMTimeMake(value: 1, timescale: 10), CMTimeMake(value: 1, timescale: 8), CMTimeMake(value: 1, timescale: 6), CMTimeMake(value: 1, timescale: 5), CMTimeMake(value: 1, timescale: 4), CMTimeMake(value: 1, timescale: 3)]
    
    static let ExposureDurationLabels = ["1/10000", "1/8000", "1/6400", "1/5000", "1/4000", "1/3200", "1/2500", "1/2000", "1/1600", "1/1250", "1/1000", "1/800", "1/640", "1/500", "1/400", "1/320", "1/250", "1/200", "1/160", "1/125", "1/100", "1/80", "1/60", "1/50", "1/40", "1/30", "1/25", "1/20", "1/15", "1/13", "1/10", "1/8", "1/6", "1/5", "1/4", "1/3"]
    
//    static let IsoValues: [Float] = [25, 32, 40, 64, 80, 100, 125, 160, 200, 250, 320, 400, 500, 640, 800, 1000, 1250, 1600]
    static let IsoValues: [Float] = [40, 64, 80, 100, 125, 160, 200, 250, 320, 400, 500, 640, 800, 1000, 1250, 1600]
    
    static let K_Candle = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: Kelvin.candle.rawValue, tint: -5)
    static let K_Tungsten = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: Kelvin.tungsten.rawValue, tint: -5)
    static let K_Sunrise = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: Kelvin.sunrise.rawValue, tint: -5)
    static let K_Fluorescent = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: Kelvin.flourescent.rawValue, tint: -5)
    static let K_Flash = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: Kelvin.flash.rawValue, tint: -5)
    static let K_Daylight = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: Kelvin.daylight.rawValue, tint: -5)
    static let K_Cloudy = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: Kelvin.cloudy.rawValue, tint: -5)
    static let K_Shade = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: Kelvin.shade.rawValue, tint: -5)

    static let WhiteBalanceLabels: [String] = ["AWB", "TUNGSTEN", "FLOURESCENT", "SUNSET", "FLASH", "SUNNY", "CLOUDY", "SHADE"]
    
}
