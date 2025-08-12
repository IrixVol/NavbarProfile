//
//  View+IntrospectExtension {.swift
//  SwiftKitUI
//
//  Created by Tatiana on 12.06.2023.
//

import SwiftUI

public extension View {
    
    func introspectScrollView(action: @escaping (UIScrollView) -> Void) -> some View {
        injectMarkerViewRepresentable(action: action)
    }
    
    func introspectTableView(action: @escaping (UITableView) -> Void) -> some View {
        injectMarkerViewRepresentable(action: action)
    }
    
    func introspectCollectionView(action: @escaping (UICollectionView) -> Void) -> some View {
        injectMarkerViewRepresentable(action: action)
    }
    
    func introspectTextView(action: @escaping (UITextView) -> Void) -> some View {
        injectMarkerViewRepresentable(action: action)
    }
    
    func introspectTextField(action: @escaping (UITextField) -> Void) -> some View {
        injectMarkerViewRepresentable(action: action)
    }
}
