//
//  File.swift
//  
//
//  Created by Dick Johnson on 13/09/2020.
//
// From
// https://medium.com/@garsdle/unwrapping-optionals-in-swiftui-7563dcc200e7

import SwiftUI

public struct OptionalView<Value, Content>: View where Content: View {
    var content: (Value) -> Content
    var value: Value

    public init?(_ value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        guard let value = value else {
            return nil
        }
        self.value = value
        self.content = content
    }

    public var body: some View {
        content(value)
    }
}

extension Optional where Wrapped: View {
    public func fallbackView<T: View>(_ transform: () -> T) -> AnyView? {
        switch self {
        case .none:
            return AnyView(transform())
        case .some(let view):
            return AnyView(view)
        }
    }

    public func fallbackView<T: View, Value>(_ value: Value?, _ transform: (Value) -> T) -> AnyView? {
        switch self {
        case .none:
            if let unwrapped = value {
                return AnyView(transform(unwrapped))
            } else {
                return nil
            }
        case .some(let view):
            return AnyView(view)
        }
    }
}

