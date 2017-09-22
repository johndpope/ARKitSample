//
//  ViewController.swift
//  ARKitSample
//
//  Created by Pratyush Pratik on 21/09/17.
//  Copyright © 2017 CodeBrew. All rights reserved.
//

/**
 
 OVERVIEW
 ========
 
 A new framework that allows you to easily create unparalleled augmented reality experiences for
 iPhone and iPad. By blending digital objects and information with the environment around you, ARKit
 takes apps beyond the screen, freeing them to interact with the real world in entirely new ways.
 
 ---------------------------------------------------------------------------------------------------
 
 SPECIFICATIONS
 ==============
 
 ~ True Depth Camera => An app can detect the position, topology, and expression of the user’s face, all with high accuracy and in real time, making it easy to apply live selfie effects or use facial expressions to drive a 3D character.
 
 ~ Visual Inertial Odometry => It accurately track the world around it. VIO fuses camera sensor data with CoreMotion data. These two inputs allow the device to sense how it moves within a room with a high degree of accuracy, and without any additional calibration.
 
 ~ Scene Understanding and Lighting Estimation => iPhone and iPad can analyze the scene presented by the camera view and find horizontal planes in the room. ARKit can detect horizontal planes like tables and floors, and can track and place objects on smaller feature points as well. ARKit also makes use of the camera sensor to estimate the total amount of light available in a scene and applies the correct amount of lighting to virtual objects.
 
 ~ High Performance Hardware and Rendering Optimizations => ARKit runs on the Apple A9, A10, and A11 processors. These processors deliver breakthrough performance that enables fast scene understanding and lets you build detailed and compelling virtual content on top of real-world scenes. You can take advantage of the optimizations for ARKit in Metal, SceneKit, and third-party tools like Unity and Unreal Engine.
 
 ---------------------------------------------------------------------------------------------------
 
 KEYPOINTS
 =========
 
 ~ ARKit uses depth sensing. i.e it notices where object are and we can build objects around it

 **/

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    //Plays into ability of tracking things as we are moving around
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/Mickey_Mouse.scn")!
        
        let scene = SCNScene()
//        let position = SCNVector3(0, 0, -0.3)
//        let globe = createGlobe(at: position)
//        scene.rootNode.addChildNode(globe)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //it takes the position of your phone and build a landscape view around it
        //track device orientation and position
        //camera is accessed
        let configuration = ARWorldTrackingConfiguration()
        
        //it saves it as your position
        // Run the view's session
        sceneView.session.run(configuration)
        addObject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func addObject() {
        
        let mickyMouse = MickyMouseNode()
        mickyMouse.loadModal()
        
//        let xPos = randomPosition(lowerBound: -0.5, upperBound: 0.5)
//        let yPos = randomPosition(lowerBound: -0.5, upperBound: 0.5)
//        
//        mickyMouse.position = SCNVector3(xPos, yPos, -1)
        
        sceneView.scene.rootNode.addChildNode(mickyMouse)
    }
    
    func randomPosition(lowerBound lower: Float, upperBound upper: Float) -> Float{
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    /*
     SCNNode:
     ========
     
     A structural element of a scene graph, representing a position and transform in a 3D coordinate space, to which you can attach geometry, lights, cameras, or other displayable content.
     */
    func createGlobe(at position: SCNVector3) -> SCNNode{
        let sphere = SCNSphere(radius: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
        sphere.firstMaterial = material
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        return sphereNode
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitFeature = results.last else { return }
        //grabbing transform of result
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        //m41,m42,m43 is for grabbing our position
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        createBall(hitPosition: hitPosition)
    }
    
    func createBall(hitPosition : SCNVector3) {
        let newBall = SCNSphere(radius: 0.01)
        let newBallNode = SCNNode(geometry: newBall)
        newBallNode.position = hitPosition
        self.sceneView.scene.rootNode.addChildNode(newBallNode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
