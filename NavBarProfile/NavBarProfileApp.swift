//
//  NavBarProfileApp.swift
//  NavBarProfile
//
//  Created by Tatiana on 09.08.2025.
//

import SwiftUI

@main
struct NavBarProfileApp: App {
    
    init() {
        // Only for iOS15
        // for iOS16* use .toolbarBackground(.hidden, for: .navigationBar)
        // setupNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            NavBarExampleScreen()
        }
    }
}

@MainActor
func setupNavigationBarAppearance() {
    
    let appearance = UINavigationBarAppearance()
    appearance.shadowImage = UIImage()
    appearance.backgroundImage = UIImage()
    appearance.backgroundColor = .white
    appearance.shadowColor = .clear
    appearance.configureWithTransparentBackground()
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
}
