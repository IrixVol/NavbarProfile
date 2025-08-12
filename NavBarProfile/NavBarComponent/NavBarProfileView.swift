// 
//  NavBarProfileView.swift
//  SwiftUIComponents
//
//  Created by Tatiana on 21.05.2025.
//

import SwiftUI

struct NavBarProfileView: View {
    
    let model: Model

    private let namespace = "NavBarProfileView"

    /// Bindings:
    /// `titleRect`pass username text size, that need to match with NavBar frame
    /// `progress` View offset from 0 to 1
    @Binding var titleRect: CGRect
    @Binding var progress: CGFloat
    
    init(
        model: Model,
        titleRect: Binding<CGRect> = .constant(.zero),
        progress: Binding<CGFloat> = .constant(.zero)
    ) {
        self.model = model
        
        self._titleRect = titleRect
        self._progress = progress
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image("user_icon_example_96")
                .frame(width: 96, height: 96)
                .clipShape(.circle)
                .scaleEffect(descriptionScale)
                .contentShape(.circle)
                .padding(.bottom, 32)
                .contentShape(.rect)
                .onTapGesture {
                    print("image tapepd")
                }
            
            username
                .allowsHitTesting(false)
                .scaleEffect(titleScale)
                .geometryOnChange(of: model.username) { geometry in
                    DispatchQueue.main.async {
                        titleRect = geometry.frame(in: .named(namespace))
                    }
                }
                .padding(.bottom, 8)

            description
                .allowsHitTesting(false)
                .scaleEffect(descriptionScale)
                .opacity(descriptionAlpha)
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(model.insets)
        .coordinateSpace(name: namespace)
    }
    
    @ViewBuilder
    private var username: some View {
        
        Text(model.username)
            .titleFont
            .foregroundStyle(.text)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .id(model.username)
    }
    
    @ViewBuilder
    private var description: some View {
        if let description = model.description {
            Text(description)
                .descriptionFont
                .foregroundStyle(.secondaryText)
                .multilineTextAlignment(.center)
        }

    }
}

// MARK: Вычисление смещений

extension NavBarProfileView {
    
    var titleScale: CGFloat {
        
        let minimumTitleScale: CGFloat =  17 / 24
        return (1 - progress * 0.25).clamped(to: minimumTitleScale...1)
    }
    
    var descriptionScale: CGFloat {
        1 - progress
    }
    
    var descriptionAlpha: CGFloat {
        1 - progress * 1.5
    }
}

#Preview {
    NavBarProfileView(model: .init(
        id: "",
        username: "Олег Сергеевич П.",
        description: "Всем привет! Я занимаюсь грузоперевозками. Ищу партнеров в Сбербизнес.",
        insets: .init()
    ))
}
