//
//  ViewController.swift
//  ARDemo
//
//  Created by PeterDing on 2018/7/22.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [])
        addBox()
        addTapGestrueToSceneView()
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    private func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.005)
        let boxNode = SCNNode()
            boxNode.geometry = box
            boxNode.position = SCNVector3(x, y, z)
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene
    }

    private func addTapGestrueToSceneView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let taplocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(taplocation)
        guard let node = hitResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(taplocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.columns.3
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
}

