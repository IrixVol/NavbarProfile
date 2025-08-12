//
//  Clamped.swift
//  NavBarProfile
//
//  Created by Tatiana on 09.08.2025.
//

import Foundation

extension Comparable {
    
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
