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
    
    //Define game elements
    var bird = SKSpriteNode()
    var background1 = SKSpriteNode()
    var background2 = SKSpriteNode()
    
    // Like "viewDidLoad" method.  Scene did appear on screen
    override func didMove(to view: SKView) {
        
        //Build game element textures
        let birdTexture  = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        
        //.animate --> array of images to scroll thru each time period
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        let moveAction = SKAction.move(by: CGVector(dx:-backgroundTexture.size().width, dy:0), duration: 5)
        let resetAction = SKAction.move(by: CGVector(dx:backgroundTexture.size().width, dy:0), duration: 0)
        let moveBackground = SKAction.repeatForever(SKAction.sequence([moveAction, resetAction]))
        
        //build element & run animations
        bird = SKSpriteNode(texture: birdTexture)
        bird.run(makeBirdFlap)
        
        background1 = SKSpriteNode(texture: backgroundTexture)
        background1.run(moveBackground)
        
        background2 = SKSpriteNode(texture: backgroundTexture)
        background2.run(moveBackground)
        
        
        
        //Position element. self=view contrlr, frame= frame in which items are contained, midX & midY = middle
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        background1.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background1.size = CGSize(width: self.frame.width, height: self.frame.height)

        
        background2.position = CGPoint(x: self.frame.maxX, y: self.frame.midY)
        background2.size = CGSize(width: self.frame.width, height: self.frame.height)
        
        //add bird to the view controller
        self.addChild(background1)
        self.addChild(background2)
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
