//
//  PreviewHelper.swift
//  Landlord2
//
//  Created by Dick Johnson on 17/07/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//

import SwiftUI

@available(macOS 10.15, *)
extension ColorScheme {
    var previewName: String {
        String(describing: self).capitalized
    }
}

@available(macOS 10.15, *)
extension ContentSizeCategory {
    static let smallestAndLargest = [allCases.first!, allCases.last!]

    var previewName: String {
        self == Self.smallestAndLargest.first ? "Small" : "Large"
    }
}

@available(macOS 10.15, *)
extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}

@available(macOS 10.15, *)
struct ComponentPreview<Component: View>: View {
    var component: Component

    var body: some View {
        ForEach(values: ColorScheme.allCases) { scheme in
            ForEach(values: ContentSizeCategory.smallestAndLargest) { category in
                self.component
                    .previewLayout(.sizeThatFits)
                    #if !os(macOS)
                    .background(Color(UIColor.systemBackground))
                    #endif
                    .colorScheme(scheme)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName(
                        "\(scheme.previewName) + \(category.previewName)"
                    )
            }
        }
    }
}

@available(macOS 10.15, *)
extension View {
    public func previewAsComponent() -> some View {
        ComponentPreview(component: self)
    }
}
