//
//  GameViewController.swift
//  Plane
//
//  Created by Разработчик on 25.04.18.
//  Copyright © 2018 Разработчик. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    let scene = GameScene(size: CGSize(width: 1024, height: 768))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isHidden = true
        
        guard let view = self.view as? SKView else { return }
        scene.scaleMode = .aspectFill
        scene.playButton = playButton
        
        view.presentScene(scene)
        
    }
    @IBAction func playButtonAction(_ sender: UIButton) {
        scene.gameIsPaused = false
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
