//
//  MickyMouseNode.swift
//  ARKitSample
//
//  Created by Pratyush Pratik on 22/09/17.
//  Copyright © 2017 CodeBrew. All rights reserved.
//

import ARKit

class MickyMouseNode: SCNNode {

    func loadModal(){
        
        let virturalObjectScene = SCNScene(named: "art.scnassets/Mickey_Mouse.scn")
        let wrapperNode = SCNNode()
        for child in virturalObjectScene?.rootNode.childNodes ?? [] {
            
            wrapperNode.addChildNode(child)
        }
        self.addChildNode(wrapperNode)
    }
}
