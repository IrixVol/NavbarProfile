//
//  Text+Font.swift
//  NavBarProfile
//
//  Created by Благообразова Татьяна Александровна on 11.08.2025.
//

import SwiftUI

extension Text {
    
    var titleFont: some View {
        self.font(Font.system(size: UIFontMetrics.default.scaledValue(for: 24)).bold())
    }
    
    var descriptionFont: some View {
        self.font(Font.system(size: UIFontMetrics.default.scaledValue(for: 16)))
    }
}
