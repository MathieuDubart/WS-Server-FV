//
//  ImagePrompting.swift
//  WebSocketClient
//
//  Created by Al on 23/10/2024.
//

import Foundation


// MARK: - ImagePrompting
struct ImagePrompting: Codable {
    let prompt: String
    let imagesBase64Data: [String]
    
    func toDataArray() -> [Data] {
        
        var imageDataArray = [Data]()
        
        for image in imagesBase64Data{
            if let imageData = Data(base64Encoded: image, options: .ignoreUnknownCharacters) {
                imageDataArray.append(imageData)
            }
        }
        
        return imageDataArray
    }
}
