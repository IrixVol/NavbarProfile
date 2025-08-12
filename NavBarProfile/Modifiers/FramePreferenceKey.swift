//
//  FramePreferenceKey.swift
//  NavBarProfile
//
//  Created by Tatiana on 09.08.2025.
//

import SwiftUI

/// The Modifier for getting View frame size via PreferenceKey.
private struct FramePreferenceKey: PreferenceKey {
    
    static let defaultValue = CGRect()
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }
}

extension View {
    
    func onFrameChanged(
        coordinateSpace: CoordinateSpace = .global,
        action: @escaping @MainActor (CGRect) -> Void
    ) -> some View {
        
        self
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(key: FramePreferenceKey.self, value: geometry.frame(in: coordinateSpace))
                }
            )
            .onPreferenceChange(FramePreferenceKey.self) { rect in
                MainActor.assumeIsolated {
                    action(rect)
                }
            }
    }
}

extension View {
   
    /// The `Modifier` for getting View frame size via `PreferenceKey`.
    /// It calls only when view appears or changes.
    /// And more suitable for using in ScrolView then `onFrameChanged`.
    /// May give a wrong result, if Views contains mutual dependencies, in that case use `onFrameChanged`.
    func geometryOnChange<V>(
        of value: V,
        perform action: @escaping (_ geometry: GeometryProxy) -> Void
    ) -> some View where V: Equatable {
        
        self.background(
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: value) { _ in
                        action(geometry)
                    }
                    .onAppear {
                        action(geometry)
                    }
            }
        )
    }
}
