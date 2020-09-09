//
//  File.swift
//  
//
//  Created by Dick Johnson on 08/09/2020.
//

import SwiftUI

extension Binding {
    static func mock(_ value: Value) -> Self {
        var value = value
        return Binding(get: { value }, set: { value = $0 })
    }
}

extension String {
    func stripExtension(_ extensionSeperator: Character = ".") -> String {
        let selfReversed = self.reversed()
        guard let extensionPosition = selfReversed.firstIndex(of: extensionSeperator) else {  return self  }
        return String(self[..<self.index(before: (extensionPosition.base.samePosition(in: self)!))])
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

