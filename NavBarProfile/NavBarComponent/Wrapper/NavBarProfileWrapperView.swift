//
//  NavBarProfileWrapperView.swift
//  SwiftKitUI
//
//  Created by Tatiana on 16.07.2025.
//

import SwiftUI

/// Wrapper join whole Screen: List content, NavBarProfileView, Background.
/// They are all put together in Wrapper for optimization reasons:
/// only Wrapper will change when scrollView position or progress is changed.
/// But list content will not be changed, because progress variable is hidden for it.
struct NavBarProfileWrapperView<Content: View, Background: View>: View {
    
    let content: Content
    let background: Background?
    let model: NavBarProfileView.Model
    
    @State var navbarHeight: CGFloat = 0
    @ObservedObject var profileBehaviour: NavBarProfileBehaviour
    
    init(
        content: Content,
        background: Background?,
        model: NavBarProfileView.Model,
        profileBehaviour: NavBarProfileBehaviour
    ) {
        self.content = content
        self.background = background
        self.model = model
        self.profileBehaviour = profileBehaviour
    }
    
    var body: some View {
        
        observeOffset(content)
            .overlay(alignment: .top) {
                navbarContent
                /// Запрещаем жесты, потому что они мешают скролу.
                /// View (прозрачное) с жестами кладем в ScrollView 
                    .allowsHitTesting(false)
            }
            .background(
                /// Setup background here, to hide `var progress` for main content.
                background.opacity(1 - profileBehaviour.progress)
            )
    }
    
    private var navbarContent: some View {
        
        NavBarProfileView(
            model: model,
            // export the rect of username
            titleRect: $profileBehaviour.titleRect,
            // export progress in range [0...1]
            progress: $profileBehaviour.progress
        )
        .offset(y: profileBehaviour.offset)
        .geometryOnChange(of: model.id) { geometry in
            DispatchQueue.main.async {
                profileBehaviour.profileHeight = geometry.size.height
                navbarHeight = geometry.frame(in: .global).minY
            }
        }
        /// background for the NavigationBar so that the list data is hidden under it when scrolling
        .background(alignment: .top) {
            Color.background
                .frame(height: navbarHeight)
                .offset(y: -navbarHeight)
                .opacity(abs(profileBehaviour.progress - 1) < 0.01 ? 1 : 0)
        }
    }

    @ViewBuilder
    private func observeOffset(_ content: Content) -> some View {
        content
            .introspectScrollView { scrollView in
                if profileBehaviour.scrollView == scrollView { return }
                profileBehaviour.scrollView = scrollView
                profileBehaviour.setupScrollViewOffsetObserver(scrollView: scrollView)
                profileBehaviour.scrollViewTopInset = -scrollView.adjustedContentInset.top
            }
    }
}
