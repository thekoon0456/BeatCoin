//
//  RealmRepository+.swift
//  CryptoCoin
//
//  Created by Deokhun KIM on 3/3/24.
//

import UIKit

// MARK: - FileManager

extension RealmRepository {
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("DEBUG: file remove error", error)
            }
        } else {
            print("DEBUG: file이 document에 없음")
        }
    }
    
    //document이미지 로드하기
    func loadImageToDocument(fileName: String) -> UIImage? {
        //경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    
    //document 폴더에 저장하기
    func saveImageToDocument(_ imageData: Data, fileName: String) {
        //앱 도큐먼트 위치 ex) desktop/sesac/week9
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        
        guard let data = UIImage(data: imageData)?.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("DEBUG: file 저장 error", error)
        }
    }
}
