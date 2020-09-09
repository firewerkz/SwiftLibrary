//
//  AdaptiveStack.swift
//  TimetoGo2
//
//  Created by Dick Johnson on 20/08/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//
// From this https://www.hackingwithswift.com/quick-start/swiftui/how-to-automatically-switch-between-hstack-and-vstack-based-on-size-class

import SwiftUI

public struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content

    public init(horizontalAlignment: HorizontalAlignment = .center, verticalAlignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        Group {
            if sizeClass == .compact {
                VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
            } else {
                HStack(alignment: verticalAlignment, spacing: spacing, content: content)
            }
        }
    }
}
