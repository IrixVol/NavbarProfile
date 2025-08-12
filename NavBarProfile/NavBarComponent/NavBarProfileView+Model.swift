// 
//  NavBarProfileView+Model.swift
//  SwiftUIComponents
//
//  Created by Tatiana on 21.05.2025.
//
import SwiftUI

extension NavBarProfileView {

    struct Model: Identifiable, Equatable {
        let id: String
        let username: String
        var description: String?
        var insets: EdgeInsets
    }
}
