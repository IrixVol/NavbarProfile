//
//  NavBarExampleScreen.swift
//  NavBarProfile
//
//  Created by Tatiana on 09.08.2025.
//

import SwiftUI

struct NavBarExampleScreen: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let navBarUserViewModel: NavBarProfileView.Model = .init(
        id: UUID().uuidString,
        username:  "Олег Сергеевич П.".uppercased(),
        description: "Всем привет! Я занимаюсь грузоперевозками. Ищу партнеров в Сбербизнес.",
        insets: .init(top: 8, leading: 16, bottom: 8, trailing: 16)
    )
    
    var body: some View {
        
        NavigationView {
            
            list
                .wrappedInLazyVStack(
                    navBarModel: navBarUserViewModel,
                    background: background
                )
                .animation(.linear, value: navBarUserViewModel)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("")
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
    
    var list: some View {
        
        ForEach(1..<40) { index in
            
            Text("----- \(index) -----")
                .frame(maxWidth: .infinity)
                .padding(.all, 16)
                .itemBackground(colorScheme)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .containerShape(.rect)
                .onTapGesture {
                    print("index = \(index)")
                }
        }
    }
    
    var background: some View {
        
        VStack(spacing: 0) {
            
            LinearGradient(
                colors: [.accent, .clear],
                startPoint: .top,
                endPoint: .bottom
            ).frame(height: 450)
            
            Spacer(minLength: 0)
        }
        .ignoresSafeArea()
    }
}

private extension View {
    
    @ViewBuilder
    func itemBackground(_ colorScheme: ColorScheme) -> some View {
        
        if colorScheme == .light {
            
            self
                .background(Color.background)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.3), radius: 5)
        } else {
            self
                .background(Color.secondaryBackground)
                .cornerRadius(16)
        }
    }
}
