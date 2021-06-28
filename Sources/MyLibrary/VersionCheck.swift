//
//  VersionCheck.swift

// from here https://github.com/acarolsf/checkVersion-iOS
//
//  CheckUpdate.swift
//  CheckApp
//
//  Created by Ana Carolina on 13/11/20.
//  Copyright © 2020 acarolsf. All rights reserved.
//
import Foundation
import UIKit

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}

public class CheckUpdate: NSObject {

    public static let shared = CheckUpdate()

    public func showUpdate(withConfirmation: Bool) {
        DispatchQueue.global().async {
            self.checkVersion(force: !withConfirmation)
        }
    }

    private  func checkVersion(force: Bool) {
        if let currentVersion = self.getBundle(key: "CFBundleShortVersionString") {
            _ = getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version {
                    if let error = error {
                        print("error getting app store version: ", error)
                    } else if self.compareNumeric(currentVersion, appStoreAppVersion) == .orderedSame {
                        print("Already on the lastest app store version: ", appStoreAppVersion)
                    } else if self.compareNumeric(currentVersion, appStoreAppVersion) == .orderedAscending {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ", currentVersion)
                        print("appURL \(String(describing: info?.trackViewUrl))")
                        DispatchQueue.main.async {
                            if let topController: UIViewController = UIApplication.shared.windows.first?.rootViewController,
                               let trackViewUrl = info?.trackViewUrl {
                                topController.showAppUpdateAlert(version: appStoreAppVersion, force: force, appURL: trackViewUrl)
                            }
                        }
                    } else {
                        print("App is newer: AppStore Version: \(appStoreAppVersion) > Current version: ", currentVersion)
                    }
                }
            }
        }
    }

    private func compareNumeric(_ version1: String, _ version2: String) -> ComparisonResult {
        return version1.compare(version2, options: .numeric)
      }

    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {

        guard let identifier = self.getBundle(key: "CFBundleIdentifier"),
              let url = URL(string: "https://itunes.apple.com/gb/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

                do {
                    if let error = error { throw error }
                    guard let data = data else { throw VersionError.invalidResponse }

                    let result = try JSONDecoder().decode(LookupResult.self, from: data)
                    print(result.results)
                    guard let info = result.results.first else {
                        throw VersionError.invalidResponse
                    }

                    completion(info, nil)
                } catch {
                    completion(nil, error)
                }
            }

        task.resume()
        return task

    }

    func getBundle(key: String) -> String? {

        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            //fatalError("Couldn't find file 'Info.plist'.")
            return nil
        }
        // 2 - Add the file to a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        // Check if the variable on plist exists
        guard let value = plist?.object(forKey: key) as? String else {
            //fatalError("Couldn't find key '\(key)' in 'Info.plist'.")
            return nil
        }
        return value
    }
}

extension UIViewController {
    @objc fileprivate func showAppUpdateAlert( version: String, force: Bool, appURL: String) {
        guard let appName = CheckUpdate.shared.getBundle(key: "CFBundleName") else { return } //Bundle.appName()
        let alertTitle = "New version"
        let alertMessage = "A new version, \(version), of \(appName) is available on AppStore. Update now!"

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        if !force {
            let notNowButton = UIAlertAction(title: "Not now", style: .default)
            alertController.addAction(notNowButton)
        }

        let updateButton = UIAlertAction(title: "Update", style: .default) { _ in
            guard let url = URL(string: appURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
