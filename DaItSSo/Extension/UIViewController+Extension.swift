//
//  UIViewController+Extension.swift
//  DaItSSo
//
//  Created by 김상규 on 6/26/24.
//

import UIKit

extension UIViewController {
    typealias CompletionHandler = ((UIAlertAction) -> ())
    
    func presentTwoActionsAlert(title: String, message: String, act: String, completionHandler: CompletionHandler? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let act = UIAlertAction(title: act, style: .destructive, handler: completionHandler)
        
        alert.addAction(cancel)
        alert.addAction(act)

        present(alert, animated: true)
    }
    
    func presentErrorAlert(searchError: ErrorType.SearchError, completionHandler: CompletionHandler? = nil) {
        let alert = UIAlertController(title: searchError.rawValue , message: nil, preferredStyle: .alert)
        let back = UIAlertAction(title: "확인", style: .default, handler: completionHandler)
        alert.addAction(back)
        self.present(alert, animated: true)
    }
    
    func saveImageToDocument(image: UIImage, filename: String) {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        print(fileURL)
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return UIImage(systemName: "star.fill")
        }
        
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            
            do {
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
        
    }
}
