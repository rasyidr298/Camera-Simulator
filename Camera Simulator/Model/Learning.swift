//
//  Learning.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 15/05/22.
//

import Foundation
import UIKit

struct Learning {
    var learningTitle: String
    var learningDesc: String
    var learningImg: String
    var learningAnim: String
    
}

extension Learning {
    static func dataLearning() -> [Learning] {
        return [
            Learning(learningTitle: "Exposure Triangle", learningDesc: "The exposure triangle (or exposure value) in photography is a principle that determines the amount of light that reaches your camera sensor.\n\nThe exposure triangle has three parts:\nShutter Speed\nAperture\nISO\n\nWhether with film or digital photography, in order to achieve a properly exposed photo, you need to make sure that all three elements are working in harmony. That means that if one element changes, the other two need to change as well.", learningImg: "ic_triangle_cell", learningAnim: "anim_ExTri"),
//            Learning(learningTitle: "EV", learningDesc: "EV is the number that represents the light in front of your camera.\n\nExposure value (EV) in photography is a number that combines aperture and shutter speed. It represents how much light is in the scene and tells you what settings will give you the right exposure.\n\nExposure value has its roots in film photography. Photographers used a light meter or their personal experience to assess how much light was in the scene.", learningImg: "ic_ev_cell", learningAnim: "anim_EV"),
            Learning(learningTitle: "ISO", learningDesc: "ISO determines how sensitive a digital camera’s sensor is to light. In a traditional film camera, ISO refers to a specific film stock’s sensitivity to light. With new technology in DSLR cameras, a camera’s ISO setting, or its sensor’s sensitivity to light, can be adjusted based on the available light of a shot.\n\nISO is measured in ISO values such as 50, 100, 200, 400, 800, 1600, 3200, etc. A lower ISO value such as 50 makes a camera’s sensor less sensitive to light. A higher ISO value such as 6400 makes a camera’s sensor more sensitive to light.", learningImg: "ic_iso_cell", learningAnim: "anim_ISO"),
            Learning(learningTitle: "Aperture", learningDesc: "Aperture is the opening of the lens through which light passes. A large (or open) aperture lets in more light that will hit the camera sensor, whereas a small (or closed) aperture lets in less light.\n\nAperture is calibrated in f/stops, written in numbers like f/1.4, 2f/, f/2.8, f/4, f/5.6, f/8, f/11, f/16, and so on. The larger the number, the smaller the aperture. Think of the f/stop number as the radius between the rim and the hole. A higher f/stop like f/16 would measure all the space between the rim and the hole, and thus, a smaller aperture.", learningImg: "ic_aperture_cell", learningAnim: "anim_Aperture"),
            Learning(learningTitle: "Shutter Speed", learningDesc: "Shutter speed controls how long the sensor of the camera is exposed to light, measured in fractions of a second. For example, a shutter speed of 1/60 holds the shutter open for one sixtieth of one second.\n\nThe longer the shutter speed is in time the more light is allowed to travel in. If it is shorter in time, less light is let in.", learningImg: "ic_shutter_cell", learningAnim: "Anim_ShutterSpeed")
        ]
    }
}
