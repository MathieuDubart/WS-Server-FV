//
//  WebSocketServer.swift
//  WebSocketServer
//
//  Created by Al on 22/10/2024.
//

import Foundation
import Swifter
import AppKit
import SwiftUI



struct RouteInfos {
        
    var routeName:String
    var textCode:(WebSocketSession, String)->()
    var dataCode:(WebSocketSession, Data)->()
    
}


class WebSocketServer {
    
    static let instance = WebSocketServer()
    
    let server = HttpServer()
    
    func setupWithRouteInfos(routeInfos:RouteInfos){
        server["/"+routeInfos.routeName] = websocket(text: { session, text in
            routeInfos.textCode(session,text)
        }, binary: { session, binary in
            routeInfos.dataCode(session,Data(binary))
        })
    }
    
    func start(){
        do{
            try server.start()
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
        }catch{
            
        }
    }
    
}
