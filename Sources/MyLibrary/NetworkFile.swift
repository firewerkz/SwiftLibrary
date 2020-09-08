//
//  NetworkFile.swift
//  Landlord2
//
//  Created by Dick Johnson on 21/08/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//

import Foundation
import Firebase

final class NetworkFile: ObservableObject {
    enum FileState {
        case failed, inprogress, paused, idle, resumed, downloaded, uploaded
    }
    @Published var fileState: FileState = .idle
    @Published var percentComplete: Double = 0.0
    @Published var progress: Double = 0.0
    @Published var error: String?
    @Published var totalSize: Int64 = 0
    var metadata: StorageMetadata?
    var documentRef: StorageReference?
    
    func alreadyExists(path: String, url: URL, completion: @escaping (Bool) -> Void) {
        self.documentRef = Storage.storage().reference(withPath: "\(path)/\(url.lastPathComponent)")
        documentRef!.getMetadata{ metadata, error in
            if let storageError = error {
                let errorCode = StorageErrorCode(rawValue: storageError._code)
                switch errorCode {
                case .objectNotFound:
                    print("File not found")
                    completion(false)
                default:
                    NSLog("%@", "getMetadata error \(storageError.localizedDescription)")
                    completion(false)
                }
            } else {
                print("File found")
                self.metadata = metadata
                completion(true)
            }
        }
    }
    
    func download(from: StorageReference, to: URL) {
        self.error = nil
        
        let downloadTask = from.write(toFile: to)
        
        downloadTask.observe(.resume) { snapshot in
            self.fileState = .resumed
        }
        
        downloadTask.observe(.pause){ snapshot in
            self.fileState = .paused
        }
        
        downloadTask.observe(.progress){ snapshot in
            self.progress = Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            self.percentComplete = 100.0 * self.progress
            self.totalSize = snapshot.progress!.totalUnitCount
        }
        
        downloadTask.observe(.success){ snapshot in
            self.fileState = .downloaded
            self.percentComplete = 0.0
            self.progress = 0.0
        }
        
        downloadTask.observe(.failure) { snapshot in
            self.percentComplete = 0.0
            self.progress = 0.0
            self.fileState = .failed
            guard let errorCode = (snapshot.error as NSError?)?.code else {
              return
            }
            guard let error = StorageErrorCode(rawValue: errorCode) else {
              return
            }
            switch (error) {
            case .objectNotFound:
                self.error = "File doesn't exist"
              break
            case .unauthorized:
                self.error = "User doesn't have permission to access file"
              break
            case .cancelled:
                self.error = "User cancelled the download"
              break

            /* ... */

            case .unknown:
                self.error = "Unknown error occurred, inspect the server response"
              break
            default:
                self.error = "Another error occurred. This is a good place to retry the download."
              break
            }
        }
    }
    
    func upload(from: URL) {
        let metadata = StorageMetadata()
        self.error = nil
        
        let uploadTask = self.documentRef?.putFile(from: from, metadata: metadata)
        
        uploadTask?.observe(.resume){ snapshot in
            self.fileState = .resumed
        }
        
        uploadTask?.observe(.pause) { snapshot in
            self.fileState = .paused
        }
        
        uploadTask?.observe(.progress) { snapshot in
            self.progress = Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            self.percentComplete = 100.0 * self.progress
            self.totalSize = snapshot.progress!.totalUnitCount
        }
        
        uploadTask?.observe(.success) { snapshot in
            self.fileState = .uploaded
            self.percentComplete = 0.0
            self.progress = 0.0
        }
        
        uploadTask?.observe(.failure) { snapshot in
            self.percentComplete = 0.0
            self.progress = 0.0
            self.fileState = .failed
            if let error = snapshot.error as NSError? {
                print("Upload error \(error)")
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    self.error = "File doesn't exist"
                    break
                case .unauthorized:
                    self.error = "User doesn't have permission to access file"
                    break
                case .cancelled:
                    self.error = "User canceled the upload"
                    break

          /* ... */

                case .unknown:
                    self.error = "Unknown error occurred, inspect the server response"
                    break
                default:
                    self.error = "A separate error occurred. This is a good place to retry the upload."
                    break
                }
            }
        }
    }
}
