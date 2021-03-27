//
//  File.swift
//  
//
//  Created by Dick Johnson on 27/03/2021.
//

import Foundation

public class VRMValidator {

    static let vrmRegExArray = [
        // Original way
        //"(?<Current>^[A-Z]{2}[0-9]{2}[A-Z]{3}$)",
        // Something more like
        "(?<Current>^[A-HK-PRSVWY][A-HJ-PR-Y]([0][2-9]|[1-9][0-9])[A-HJ-PR-Z]{3}$)",
        "(?<Prefix>^[A-Z][0-9]{1,3}[A-Z]{3}$)",
        "(?<Suffix>^[A-Z]{3}[0-9]{1,3}[A-Z]$)",
        "(?<DatelessLongNumberPrefix>^[0-9]{1,4}[A-Z]{1,2}$)",
        "(?<DatelessShortNumberPrefix>^[0-9]{1,3}[A-Z]{1,3}$)",
        "(?<DatelessLongNumberSuffix>^[A-Z]{1,2}[0-9]{1,4}$)",
        "(?<DatelessShortNumberSuffix>^[A-Z]{1,3}[0-9]{1,3}$)",
        "(?<DatelessNorthernIreland>^[A-Z]{1,3}[0-9]{1,4}$)",
        "(?<DiplomaticPlate>^[0-9]{3}[DX]{1}[0-9]{3}$)"
    ]

    public class func validate(vrm: String) -> Bool {

        let cleanVrm = vrm.removingWhitespaces().uppercased()
        //if it's empty or has more than 8 characters
        if cleanVrm.isEmpty || cleanVrm.count >= 8 {
            return false
        }

        var matched = false
        for regEx in vrmRegExArray {
            let vrmTest = NSPredicate(format: "SELF MATCHES %@", regEx)
            matched = vrmTest.evaluate(with: cleanVrm.uppercased())
            if matched == true {
                return true
            }
        }

        return matched
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
