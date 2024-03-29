//
//  ProgressBar.swift
//  Landlord2
//
//  Created by Dick Johnson on 05/08/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//

// From this https://www.simpleswiftguide.com/how-to-build-linear-progress-bar-in-swiftui/
import SwiftUI

@available(macOS 12.0, *)
public struct ProgressBar: View {
    @Binding var value: Double

    public init(value: Binding<Double>) {
        self._value = value
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if #available(macCatalyst 15.0, iOS 15.0, *) {
                    Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(Color.teal)
                } else {
                    Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(.black)
                }

                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.blue)
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}
@available(macOS 12.0, *)
struct ProgressBarDemo: View {
    @State var progressValue: Double = 0.0

    var body: some View {
        VStack {
            ProgressBar(value: $progressValue).frame(height: 20)

            Button(action: {
                self.startProgressBar()
            }, label: {
                Text("Start Progress")
            }).padding()

            Button(action: {
                self.resetProgressBar()
            }, label: {
                Text("Reset")
            })

            Text("\(progressValue*10, specifier: "%.2f")%")

            Spacer()
        }.padding()
    }

    func startProgressBar() {
        for _ in 0...80 {
            self.progressValue += 0.015
        }
    }

    func resetProgressBar() {
        self.progressValue = 0.0
    }
}

@available(macOS 12.0, *)
struct ProgressBarDemo_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarDemo()
    }
}
