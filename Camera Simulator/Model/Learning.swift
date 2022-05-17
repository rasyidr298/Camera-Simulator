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
}

extension Learning {
    static func dataLearning() -> [Learning] {
        return [Learning(learningTitle: "title1", learningDesc: "desc1", learningImg: "bg_test1"),
                Learning(learningTitle: "title2", learningDesc: "desc2", learningImg: "bg_test2"),
                Learning(learningTitle: "title3", learningDesc: "desc3", learningImg: "bg_test1")
        ]
    }
}
