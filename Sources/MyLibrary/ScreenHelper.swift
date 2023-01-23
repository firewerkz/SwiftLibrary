//
//  ScreenHelper.swift
//  Landlord2
//
//  Created by Dick Johnson on 17/07/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//

import SwiftUI

#if os(macOS)
#else
@available(iOS 14, *)
struct ScreenPreview<Screen: View>: View {
    var screen: Screen

    var body: some View {
        ForEach(values: deviceNames) { device in
            ForEach(values: ColorScheme.allCases) { scheme in
                NavigationView {
                    self.screen
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                }
                .previewDevice(PreviewDevice(rawValue: device))
                .colorScheme(scheme)
                .previewDisplayName("\(scheme.previewName): \(device)")
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }

    private var deviceNames: [String] {
        [
            "iPhone 8",
            "iPhone 11",
            "iPhone 11 Pro Max",
            "iPad (7th generation)"
        ]
    }
}

@available(iOS 14, *)
extension View {
    public func previewAsScreen() -> some View {
        ScreenPreview(screen: self)
    }
}
#endif
