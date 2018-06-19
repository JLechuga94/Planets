//
//  ViewController.swift
//  Planets
//
//  Created by Julian Lechuga Lopez on 19/6/18.
//  Copyright © 2018 Julian Lechuga Lopez. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        let origin = SCNVector3(0,0,0)
        
        let earthParentNode = SCNNode()
        earthParentNode.position = origin
        
        let venusParentNode = SCNNode()
        venusParentNode.position = origin
        
        let moonParentNode = SCNNode()
        moonParentNode.position = origin
        
        let sun = CelestialBody(geometry: SCNSphere(radius: 0.35), diffuse: UIImage(named: "SunDiffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-1))
        
        let earth = CelestialBody(geometry: SCNSphere(radius: 0.2), diffuse: UIImage(named: "EarthDay")!, specular: UIImage(named: "EarthSpecular")!, emission: UIImage(named: "EarthEmission")!, normal: UIImage(named: "EarthNormalMap")!, position: SCNVector3(1.5,0,0))
        
        let earthMoon = CelestialBody(geometry: SCNSphere(radius: 0.05), diffuse: UIImage(named: "MoonDiffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(0.4,0,0))
        
        let venus = CelestialBody(geometry: SCNSphere(radius: 0.1), diffuse: UIImage(named: "VenusDiffuse")!, specular: nil, emission: UIImage(named: "VenusEmission")!, normal: nil, position: SCNVector3(0.7,0,0))
        
        let generalRotation = Rotation(duration: 8)
        let earthRotation = Rotation(duration: 15)
        let venusRotation = Rotation(duration: 10)
        let moonRotation = Rotation(duration: 5)

        // Rotation around their own axis
        sun.runAction(generalRotation)
        earth.runAction(generalRotation)
        venus.runAction(generalRotation)
        earthMoon.runAction(generalRotation)
        
        //Rotation relative to their parent node
        earthParentNode.runAction(earthRotation)
        venusParentNode.runAction(venusRotation)
        moonParentNode.runAction(moonRotation)
        
        sun.addChildNode(earthParentNode)
        sun.addChildNode(venusParentNode)
        earth.addChildNode(moonParentNode)
        
        //This is done in order to avoid modifying the values of the child vector each time the parent vector is modified. In this way the child is always in the origin of the parent vector no matter the value
        earthParentNode.addChildNode(earth)
        venusParentNode.addChildNode(venus)
        moonParentNode.addChildNode(earthMoon)
        
        self.sceneView.scene.rootNode.addChildNode(sun)
    }
    
    //Creation of different celestial bodies
    func CelestialBody(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let CelestialBody = SCNNode(geometry: geometry)
        CelestialBody.geometry?.firstMaterial?.diffuse.contents = diffuse
        CelestialBody.geometry?.firstMaterial?.specular.contents = specular
        CelestialBody.geometry?.firstMaterial?.emission.contents = emission
        CelestialBody.geometry?.firstMaterial?.normal.contents = normal
        CelestialBody.position = position
        return CelestialBody
    }
    //Since we only rotate in the y-axis all other values are zero
    func Rotation(duration: TimeInterval)-> SCNAction {
        let Rotation = SCNAction.rotateBy(x: 0, y:CGFloat(360.degreesToRadians), z: 0, duration: duration)
        let infiniteAction = SCNAction.repeatForever(Rotation)
        return infiniteAction
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
