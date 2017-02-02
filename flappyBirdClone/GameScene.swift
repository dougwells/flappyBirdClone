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
    let ground = SKNode()
    var pipeFromAbove = SKSpriteNode()
    var pipeFromBelow = SKSpriteNode()
    
    //Build game element textures
    let birdTexture  = SKTexture(imageNamed: "flappy1.png")
    let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
    let backgroundTexture = SKTexture(imageNamed: "bg.png")
    let pipeFromAboveTexture = SKTexture(imageNamed: "pipe1.png")
    let pipeFromBelowTexture = SKTexture(imageNamed: "pipe2.png")
    
    func makePipes() {
        
        pipeFromAbove = SKSpriteNode(texture: pipeFromAboveTexture)
        pipeFromBelow = SKSpriteNode(texture: pipeFromBelowTexture)
        
        let pipeGap = bird.size.height * 2
        
        //random movement from 0 to half the frame height
        let movementAmount = arc4random() % UInt32(self.frame.height/2)
        
        //pipeOffset - takes movement to -1/4 to +1/4 of frame height
        let pipeOffset = CGFloat(movementAmount) - self.frame.height/4
        
        //animate pipes (make duration relative to screen width)
        let movePipes = SKAction.move(by: CGVector(dx: -2*self.frame.width * 1.5, dy:0), duration: TimeInterval(self.frame.width/50) )
        
        pipeFromAbove.position = CGPoint(x: self.frame.maxX + 0.5 * self.frame.width, y: self.frame.midY + 0.5 * pipeFromAboveTexture.size().height + pipeGap + pipeOffset)
        pipeFromAbove.run(movePipes)
        self.addChild(pipeFromAbove)
        
        pipeFromBelow.position = CGPoint(x: self.frame.maxX + 0.5 * self.frame.width, y: self.frame.midY - 0.5 * pipeFromBelowTexture.size().height - pipeGap + pipeOffset)
        pipeFromBelow.run(movePipes)
        self.addChild(self.pipeFromBelow)

        
    } //End makePipes
    
    
// Like "viewDidLoad" method.  Scene did appear on screen
    override func didMove(to view: SKView) {
        
        //Timer for randomly creating pipes every 3 seconds
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        //.animate --> array of images to scroll thru each time period
        
            //animate bird
                let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
                let makeBirdFlap = SKAction.repeatForever(animation)
        
            //animate background
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
        
        
        //Position element. self=view controller, frame= frame in which items are contained, midX & midY = middle
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        background1.zPosition = -1
        background1.position = CGPoint(x: 0, y: self.frame.midY)
        background1.size = CGSize(width: backgroundTexture.size().width, height: self.frame.height)
        self.addChild(background1)
        
        
        background2.zPosition = -1
        background2.position = CGPoint(x: backgroundTexture.size().width, y: self.frame.midY)
        background2.size = CGSize(width: backgroundTexture.size().width, height: self.frame.height)
        self.addChild(background2)
        
        self.addChild(bird)
        
        ground.position = CGPoint(x: 0, y: -self.frame.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false //gravity. Ground should stay in place
        self.addChild(ground)


        
    }
    
    //user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        
        bird.physicsBody!.isDynamic = true  //gravity. not needed. default is true
        
        bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0) //total distance of animation per second
        
        bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 60))  //move up 50 pixels
        
    }
    
    //called several times per second (check for collisions, move items, etc
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
