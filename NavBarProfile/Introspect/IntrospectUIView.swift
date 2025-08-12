//
//  IntrospectUIView.swift
//  SwiftKitUI
//
//  Created by Tatiana on 12.06.2023.
//

import UIKit
import SwiftUI

extension View {
    
    /// Добавляем в существующее View через overlay `IntrospectUIView: UIView`, к которому имеем доступ из UIKit
    /// а также доступ через SwiftUI через оболочку `IntrospectView: UIViewRepresentable`
    func injectMarkerViewRepresentable<TargetView: UIView>(action: @escaping (TargetView) -> ()) -> some View {
        overlay(
            IntrospectView(action: action)
                .frame(width: 0, height: 0)
        )
    }
}
    
private class IntrospectUIView: UIView {
    
    var onDidMoveToWindow: (() -> Void)?
    
    required init() {
        super.init(frame: .zero)
        isHidden = true
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        DispatchQueue.main.async {
            self.onDidMoveToWindow?()
        }
    }
}

/// Обертка IntrospectUIView для представления в SwiftUI
private struct IntrospectView<TargetViewType: UIView>: UIViewRepresentable {
    
    /// Замыкание, которое выполняется на найденном view заданного типа `TargetViewType`
    let action: (TargetViewType) -> Void
    
    init(action: @escaping (TargetViewType) -> Void) {
        self.action = action
    }
    
    func makeUIView(context: UIViewRepresentableContext<IntrospectView>) -> IntrospectUIView {
        
        let view = IntrospectUIView()
        view.onDidMoveToWindow = { [weak view] in
            performAction(view)
        }
        return view
    }
    
    func updateUIView(
        _ view: IntrospectUIView,
        context: UIViewRepresentableContext<IntrospectView>
    ) {
        performAction(view)
    }
    
    func performAction(_ marker: IntrospectUIView?) {
        
        guard let marker, let targetView: TargetViewType = find(marker: marker) else { return }
        action(targetView)
    }
    
    func find<TargetView: UIView>(marker: UIView) -> TargetView? {
        
        guard let superView = marker.superview?.superview else { return nil }
        
        return if TargetView.self == UICollectionViewCell.self {
            // Ищем первый в цепочке superview UICollectionViewCell
            findFirstSuperview(on: superView)
        } else {
            find(marker: marker, on: superView)
        }
    }
    
    func findFirstSuperview<TargetView: UIView>(on superview: UIView) -> TargetView? {
        sequence(first: superview) { $0.superview }
            .lazy
            .compactMap { $0 as? TargetView }
            .first
    }
    
    func find<TargetView: UIView>(marker: UIView, on superview: UIView) -> TargetView? {
        
        // superview.superview приходится вызывать, чтобы искать на View, которые `clipped()`
        var subviews: [UIView] = [superview.superview ?? superview]
        while !subviews.isEmpty {
            
            // ScrollView в iOS 15 и 16 расположен на уровне Marker SuperView
            if #unavailable(iOS 17.0), TargetView.self == UIScrollView.self,
               let markerIndex = subviews.firstIndex(where: { $0 == marker.superview }),
               let item = subviews.prefix(markerIndex).last(where: { $0 is TargetView }) {
                
                return item as? TargetView
            }
            
            if let markerIndex = subviews.firstIndex(where: { $0 == marker }) {
                return Array(subviews.prefix(markerIndex)).findTargetView(type: TargetView.self)
            }
            
            // На этом же уровне ищем TargetView
            subviews = subviews.flatMap { $0.subviews }
        }
        
        assertionFailure("Not found View for Marker: " + "\(type(of: TargetView.self))")
        return nil
    }
}

fileprivate extension Array where Element == UIView {
    
    // Когда на одном уровне view несколько полей заданного типа (например TextField):
    // Надо выбирать целевое поле предшествующее маркеру
    // [0]    SwiftUI.VerticalTextView        <- цель1
    // [1]    SwiftKitUI.IntrospectUIView     <- маркер1
    // [2]    SwiftUI.VerticalTextView        <- цель2
    // [3]    SwiftKitUI.IntrospectUIView     <- маркер2
    @MainActor
    func findTargetView<TargetView: UIView>(type: TargetView.Type) -> TargetView? {
        
        for view in reversed() {
            if let item = view as? TargetView ?? view.subviews.last as? TargetView {
                return item
            }
        }
        assertionFailure("Not found View for Marker: " + "\(TargetView.self)")
        return nil
    }
}
