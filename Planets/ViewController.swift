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
        let earth = SCNNode()
        earth.geometry = SCNSphere(radius: 0.2)
        earth.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "EarthDay")
        earth.geometry?.firstMaterial?.specular.contents = UIImage(named: "EarthSpecular")
        earth.geometry?.firstMaterial?.emission.contents = UIImage(named: "EarthEmission")
        earth.geometry?.firstMaterial?.normal.contents = UIImage(named: "EarthNormalMap")
        earth.position = SCNVector3(0,0,-1)
        self.sceneView.scene.rootNode.addChildNode(earth)
        
        let EarthRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 15)
        let infiniteAction = SCNAction.repeatForever(EarthRotation)
        earth.runAction(infiniteAction)
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
