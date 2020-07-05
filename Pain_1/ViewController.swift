//
//  ViewController.swift
//  Pain_1
//
//  Created by Tapan Patel on 24/01/20.
//  Copyright © 2020 Tapan Patel. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
//    var container : SCNNode!
    
//    func resetTrackingConfiguration() {
//        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.detectionImages = referenceImages
//        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
//        sceneView.session.run(configuration, options: options)
//
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        let scene = SCNScene(named: "art.scnassets/EmptyScene.scn")
       
        
        sceneView.scene = scene!
        sceneView.delegate = self
//        resetTrackingConfiguration()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main)
            else {
                print("Invalid Reference images")
                return
        }
        configuration.trackingImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration)
        // Create a session configuration
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor
        {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            //to play video
            let videoUrl = Bundle.main.url(forResource: "nagato", withExtension: "mp4")!
            let videoPlayer = AVPlayer(url: videoUrl)
            videoPlayer.actionAtItemEnd = .none
            let videoScene = SKScene(size: CGSize(width: 720  , height: 1280))
            let videoNode = SKVideoNode(avPlayer: videoPlayer)
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height/2)
            videoNode.size = videoScene.size
            videoNode.play()
            videoPlayer.play()
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,object: videoPlayer.currentItem, queue: nil){ notification in
                videoPlayer.seek(to: CMTime.zero)
                videoPlayer.play()
            }
            videoScene.addChild(videoNode)
            
            let transplane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            transplane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0)
            let transPlaneNode = SCNNode(geometry: transplane)
            //transPlaneNode.eulerAngles.x = -.pi/2

            
//            let spin = CABasicAnimation(keyPath: "rotation")
//            spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 1))
//            spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(360.degreesToRadians)))
//            spin.duration = 9
//            spin.repeatCount = .infinity
//
//            transPlaneNode.addAnimation(spin, forKey: "spin around")
            let rotate = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 4)
            let forever = SCNAction.repeatForever(rotate)
            transPlaneNode.runAction(forever)
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let VideoplaneNode = SCNNode(geometry: plane)
            VideoplaneNode.eulerAngles.x = -.pi/2
            
            let nagatoScene = SCNScene(named: "art.scnassets/nagato.scn")
            let nagatoNode = nagatoScene?.rootNode.childNodes.first!
            nagatoNode?.position = SCNVector3Zero
            nagatoNode?.eulerAngles.x = -.pi/2
            nagatoNode?.position.z = 0.03
            
            let konanScene = SCNScene(named: "art.scnassets/Konan.scn")
            let konanNode = konanScene?.rootNode.childNodes.first!
            konanNode?.position = SCNVector3Zero
            konanNode?.eulerAngles.x = -.pi/2
            konanNode?.position.z = -0.03

          

            
            transPlaneNode.addChildNode(konanNode!)
            transPlaneNode.addChildNode(nagatoNode!)
            
            node.addChildNode(transPlaneNode)
            
            node.addChildNode(VideoplaneNode)
        }
        return node
    }
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let imageAnchor = anchor as? ARImageAnchor else { return }
//        let referenceImage = imageAnchor.referenceImage
//        _ = referenceImage.name ?? "no name"
//
//        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
//        let planeNode = SCNNode(geometry: plane)
//        planeNode.opacity = 0.20
//        planeNode.eulerAngles.x = -.pi / 2
//
//        let scene = SCNScene(named: "art.scnassets/Scene.scn")
//        let nagato = scene?.rootNode.childNode(withName: "container", recursively: true)
//
//        sceneView.scene.rootNode.addChildNode(nagato!)
//
//        print("image detected")
//
//    }
  
}
extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
