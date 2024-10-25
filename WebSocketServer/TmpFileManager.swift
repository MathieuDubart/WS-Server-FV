//
//  TmpFileManager.swift
//  WebSocketServer
//
//  Created by Al on 23/10/2024.
//

import Foundation

class TmpFileManager {
    
    static let instance = TmpFileManager()
    
    private var currentPathArray = [String]()
    
    private func deleteCurrentPathArray() {
        //
        // Suppress tmp files
        //
        self.currentPathArray = []
    }
    
    func saveImageDataArray(dataImageArray:[Data]) -> [String]{
        deleteCurrentPathArray()
        dataImageArray.enumerated().forEach { (index, element) in
            let currentImageName = "tmp\(index).jpeg"
            if FileHandler.saveImage(from: element, to: currentImageName){
                currentPathArray.append(currentImageName)
            }else{
                print("Error saving images.")
            }
        }
        return self.currentPathArray
    }
    
}

