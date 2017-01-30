//
//  GameScene.swift
//  flappyBirdClone
//
//  Created by Doug Wells on 1/29/17.
//  Copyright © 2017 Doug Wells. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    
    // Like "viewDidLoad" method.  Scene did appear on screen
    override func didMove(to view: SKView) {
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        
        bird = SKSpriteNode(texture: birdTexture)
        
        //Position bird. self=view contrlr, frame= frame in which items are contained, midX & midY = middle
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //add bird to the view controller
        self.addChild(bird)

        
    }
    
    //user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    //called several times per second (check for collisions, move items, etc
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
