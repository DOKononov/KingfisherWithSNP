//
//  ScreenSize.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 18.08.22.
//

import Foundation
import UIKit

final class ScreenSize {
    private init(){}
    static var shared = ScreenSize()
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    func screenWidth(_ multiplier: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * multiplier

    }
}
