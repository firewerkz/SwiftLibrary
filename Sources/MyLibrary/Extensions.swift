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

extension Bundle {
    func getAppVersion() -> String {
        if let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"),
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
        return "\(versionNumber).\(buildNumber)"
        }
        else {
            return "Error reading version"
        }
    }
}

extension Int {
    func toTimeString() -> String {
        let seconds = self % 60
        let minutes = self/60
        
        var secondsString = "\(seconds)"
        var minutesString = "\(minutes)"
        
        if seconds < 10 {
            secondsString = "0" + secondsString
        }
        
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        
        return "\(minutesString):\(secondsString)"
    }
    
// From this https://matteomanferdini.com/model-view-controller-ios/#more-2835
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: Float(self) )) ?? ""
    }
}

extension URL: Identifiable {
    public var id: String { return lastPathComponent }
    
    var name: String {
           self.lastPathComponent.stripExtension()
    }
}

extension Date {
    func yearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale.current)
        return dateFormatter.string(from: self)
    }
    
    func monthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM", options: 0, locale: Locale.current)
        return dateFormatter.string(from: self)
    }
    
    func shortStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ddMMyyyy", options: 0, locale: Locale.current)
        return dateFormatter.string(from: self)
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

// Extension to UIImage to rotate imamge if needed to be saved correctly as PNG.
extension UIImage {
    func correctlyOrientedImage() -> UIImage {
        NSLog("correctlyOrientedImage, image Orientation is \(self.imageOrientation.rawValue)")
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        NSLog("correctlyOrientedImage, image needed rotating")
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize( width: self.size.width, height: self.size.height)))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    func saveImage(key: String) {
        let imagetoSave = self.correctlyOrientedImage()
        if let imageData =  imagetoSave.jpegData(compressionQuality: 0.5){
            UserDefaults.standard.set(imageData, forKey: key)
        }
    }
}

// From this https://swiftwithmajid.com/2020/02/26/textfield-in-swiftui/
extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }
}


