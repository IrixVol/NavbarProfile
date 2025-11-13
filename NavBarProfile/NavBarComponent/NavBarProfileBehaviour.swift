//
//  NavBarProfileBehaviour.swift
//  SwiftKitUI
//
//  Created by Tatiana on 08.07.2025.
//

import UIKit
import Combine
import SwiftUI

@MainActor
/// Calculation offset for NavBarProfileView and animation on ScrollView stop.
final class NavBarProfileBehaviour: ObservableObject {
    
    private let navigationBarHeight: CGFloat = UINavigationController()
        .navigationBar.frame.maxY
    
    /// ScrollView initial top inset.
    /// `ScrollView.contentOffset.y` start with some value (not with 0), that need to take into account in calculation.
    /// It occurs when using transparant navbar, edgesForExtendedLayout, extendedLayoutIncludesOpaqueBars
    var scrollViewTopInset: CGFloat = 0

    /// The rect of username, that need to match with NavbarTitle
    @Published var titleRect: CGRect = .init()
    /// The height of whole component
    @Published var profileHeight: CGFloat?
    
    /// Don't mark scrollViewOffset with @Published to avoid extra View rebuilding, when in changing.
    /// Instead use `@Published var progress`, it is changing in range [0...1]
    var scrollViewOffset: CGFloat = 0 {
        didSet {
            onUpdateScrollViewOffset()
        }
    }
    
    /// [0...1] `0` - profile shown, `1` - profile hidden (pushed up)
    @Published var progress: CGFloat = 0
    
    /// [0...profileHeight] `0` - profile shown, `profileHeight` - profile hidden (pushed up)
    @Published var offset: CGFloat = 0
    
    private var contentOffsetObservation: NSKeyValueObservation?
    private var isFinalizeScrolling = false
    private var cancellable = Set<AnyCancellable>()
    
    init() { }
    
    func calcOffset() -> (progress: CGFloat, offset: CGFloat) {
        
        guard let profileHeight, profileHeight != 0 else { return (0, 0) }
        
        let maxOffset = titleRect.maxY + (navigationBarHeight - titleRect.height) / 2
        let newOffset = -min(scrollViewOffset, maxOffset)
        let newProgress = (scrollViewOffset / profileHeight).clamped(to: 0...1)
        
        return (progress: newProgress, offset: newOffset)
    }
    
    func updateScrollViewOffset(_ value: CGFloat) {
        
        let newValue = value - scrollViewTopInset
        if abs(scrollViewOffset - newValue) > 0.4 {
            scrollViewOffset = newValue
        }
    }
    
    func onUpdateScrollViewOffset() {
        
        let (newProgress, newOffset) = calcOffset()
        
        if newProgress != progress {
            progress = newProgress
        }
        
        if newOffset != offset {
            offset = newOffset
        }
    }
    
    func getFinalizeScrollPosition() -> CGFloat? {
        
        guard
            let profileHeight,
            !isFinalizeScrolling,
            scrollViewOffset > 0,
            scrollViewOffset < profileHeight
        else {
            return nil
        }
        
        isFinalizeScrolling = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.isFinalizeScrolling = false
        }
        
        return scrollViewOffset < profileHeight * 0.5 ? 0 : profileHeight
    }
}
