//
//  NavBarViewModifier.swift
//  SwiftKitUI
//
//  Created by Tatiana on 21.07.2025.
//

import SwiftUI

extension View {
    
    func wrappedInLazyVStack<Background: View>(
        navBarModel: NavBarProfileView.Model,
        background: Background? = Color.background
    ) -> some View {
        
        modifier(NavBarViewModifier(
            model: navBarModel,
            background: background
        ))
    }
}

struct NavBarViewModifier<Background: View>: ViewModifier {
    
    let model: NavBarProfileView.Model
    let background: Background?

    @StateObject var profileBehaviour: NavBarProfileBehaviour = .init()
    
    func body(content: Content) -> some View {

        NavBarProfileWrapperView(
            content:
                ScrollView {
                    LazyVStack(spacing: 0) {
                        
                        /*
                        Spacer(minLength: 0)
                            .frame(height: profileBehaviour.profileHeight)
                        */
                        /// Прозрачное View для жестов
                        /// Tap на иконку работает и не мешает сколлу
                        NavBarProfileView(model: model)
                            .mask(Color.black.opacity(0))
                        
                        content
                    }
                },
            background: background,
            model: model,
            profileBehaviour: profileBehaviour
        )
    }
}
