//
//  main.swift
//  WebSocketServer
//
//  Created by Al on 22/10/2024.
//

import Foundation
import Combine

var serverWS = WebSocketServer.instance

var cmd = TerminalCommandExecutor()

serverWS.setupWithRouteInfos(routeInfos: RouteInfos(routeName: "say", textCode: { session, receivedText in
    cmd.say(textToSay: receivedText)
}, dataCode: { session, receivedData in
    
}))

var cancellable: AnyCancellable? = nil

serverWS.setupWithRouteInfos(routeInfos: RouteInfos(routeName: "imagePrompting", textCode: { session, receivedText in
    
    cancellable?.cancel()
    cancellable = cmd.$output.sink { newValue in
        print("La valeur de myVariable a changé : \(newValue)")
        cmd.say(textToSay: newValue)
    }
    
    if let jsonData = receivedText.data(using: .utf8),
       let imagePrompting = try? JSONDecoder().decode(ImagePrompting.self, from: jsonData){
        
        let dataImageArray = imagePrompting.toDataArray()
        let tmpImagesPath = TmpFileManager.instance.saveImageDataArray(dataImageArray: dataImageArray)
       
        if (tmpImagesPath.count == 1){
            cmd.imagePrompting(imagePath: tmpImagesPath[0], prompt: imagePrompting.prompt)
        }else{
            print("You are sending too much images")
        }
            
    }
    
}, dataCode: { session, receivedData in
    
}))

serverWS.setupWithRouteInfos(routeInfos: RouteInfos(routeName: "imagePromptingToText", textCode: { session, receivedText in
    
    cancellable?.cancel()
    cancellable = cmd.$output.sink { newValue in
        print("#### sending: \(newValue)")
        session.writeText(newValue)
    }
    
    if let jsonData = receivedText.data(using: .utf8),
       let imagePrompting = try? JSONDecoder().decode(ImagePrompting.self, from: jsonData){
        
        let dataImageArray = imagePrompting.toDataArray()
        let tmpImagesPath = TmpFileManager.instance.saveImageDataArray(dataImageArray: dataImageArray)
       
        if (tmpImagesPath.count == 1){
            cmd.imagePrompting(imagePath: tmpImagesPath[0], prompt: imagePrompting.prompt)
        }else{
            print("You are sending too much images")
        }
        
    }
    
}, dataCode: { session, receivedData in
    
}))


serverWS.start()


RunLoop.main.run()

