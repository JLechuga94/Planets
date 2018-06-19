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
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        let origin = SCNVector3(0,0,0)
        
        let venusParentNode = SCNNode()
        venusParentNode.position = origin
        
        let earthParentNode = SCNNode()
        earthParentNode.position = origin
        
        let moonParentNode = SCNNode()
        moonParentNode.position = origin
        
        let marsParentNode = SCNNode()
        marsParentNode.position = origin
        
        let saturnParentNode = SCNNode()
        saturnParentNode.position = origin
        
        let sun = CelestialBody(geometry: SCNSphere(radius: 0.6), diffuse: UIImage(named: "SunDiffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-1))
        
        let venus = CelestialBody(geometry: SCNSphere(radius: 0.1), diffuse: UIImage(named: "VenusDiffuse")!, specular: nil, emission: UIImage(named: "VenusEmission")!, normal: nil, position: SCNVector3(1,0,0))
        
        let earth = CelestialBody(geometry: SCNSphere(radius: 0.2), diffuse: UIImage(named: "EarthDay")!, specular: UIImage(named: "EarthSpecular")!, emission: UIImage(named: "EarthEmission")!, normal: UIImage(named: "EarthNormalMap")!, position: SCNVector3(1.5,0,0))
        
        let earthMoon = CelestialBody(geometry: SCNSphere(radius: 0.05), diffuse: UIImage(named: "MoonDiffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(0.4,0,0))
        
        let mars = CelestialBody(geometry: SCNSphere(radius: 0.3), diffuse: UIImage(named: "MarsDiffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(2,0,0))
        
        let saturn = CelestialBody(geometry: SCNSphere(radius: 0.45), diffuse: UIImage(named: "SaturnDiffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(3,0,0))
        
        let saturnRing = SCNNode(geometry: SCNTorus(ringRadius: 0.7, pipeRadius: 0.1))
        saturnRing.position = origin
//        saturnRing.eulerAngles = SCNVector3(Float(90.degreesToRadians),0,0)
        saturnRing.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "SaturnEmission")

        
        let generalRotation = Rotation(duration: 8)
        let venusRotation = Rotation(duration: 10)
        let earthRotation = Rotation(duration: 15)
        let marsRotation = Rotation(duration: 20)
        let saturnRotation = Rotation(duration: 30)
        let moonRotation = Rotation(duration: 5)

        // Rotation around their own axis
        sun.runAction(generalRotation)
        venus.runAction(generalRotation)
        earth.runAction(generalRotation)
        mars.runAction(generalRotation)
        saturn.runAction(generalRotation)
        earthMoon.runAction(generalRotation)
        
        //Rotation relative to their parent node. This determines the speed rotation relative to the sun or the Earth in the case of the moon
        venusParentNode.runAction(venusRotation)
        earthParentNode.runAction(earthRotation)
        moonParentNode.runAction(moonRotation)
        marsParentNode.runAction(marsRotation)
        saturnParentNode.runAction(saturnRotation)
        
        //This is done in order to avoid modifying the values of the child vector each time the parent vector is modified. In this way the child is always in the origin of the parent vector no matter the value
        sun.addChildNode(venusParentNode)
        sun.addChildNode(earthParentNode)
        sun.addChildNode(marsParentNode)
        sun.addChildNode(saturnParentNode)
        
        earth.addChildNode(moonParentNode)
        
        //These node's positions are in the origin of the Sun's vector. This is done in order to control indepent velocity of rotation for each one of the planets
        venusParentNode.addChildNode(venus)
        earthParentNode.addChildNode(earth)
        marsParentNode.addChildNode(mars)
        saturnParentNode.addChildNode(saturn)
        
        moonParentNode.addChildNode(earthMoon)
        saturn.addChildNode(saturnRing)
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
    //Generic rotation function. Since we only rotate in the y-axis all other values are zero
    func Rotation(duration: TimeInterval)-> SCNAction {
        let Rotation = SCNAction.rotateBy(x: 0, y:CGFloat(360.degreesToRadians), z: 0, duration: duration)
        let infiniteAction = SCNAction.repeatForever(Rotation)
        return infiniteAction
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
