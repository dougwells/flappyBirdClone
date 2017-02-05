//
//  GameScene.swift
//  flappyBirdClone
//
//  Created by Doug Wells on 1/29/17.
//  Copyright © 2017 Doug Wells. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //set gameOver to false
    var gameOver = false
    
    //Define game elements
    var bird = SKSpriteNode()
    var background1 = SKSpriteNode()
    var background2 = SKSpriteNode()
    let ground = SKNode()
    var pipeFromAbove = SKSpriteNode()
    var pipeFromBelow = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var score = 0
    var timer = Timer()
    
    //Build game element textures
    let birdTexture  = SKTexture(imageNamed: "flappy1.png")
    let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
    let backgroundTexture = SKTexture(imageNamed: "bg.png")
    let pipeFromAboveTexture = SKTexture(imageNamed: "pipe1.png")
    let pipeFromBelowTexture = SKTexture(imageNamed: "pipe2.png")
    
    //Collition - Enums, UI32 so values must be 2^x (ie, 1, 2, 4, 8, 16 etc)
    enum ColliderType: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
        case None = 8
    }
    
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
        pipeFromAbove.zPosition = -1
        pipeFromAbove.run(movePipes)
        
        //Setup physics body for pipes (must set gravity to false)
        pipeFromAbove.physicsBody = SKPhysicsBody(rectangleOf: pipeFromAboveTexture.size())
        pipeFromAbove.physicsBody?.isDynamic = false
        
        //Set up collision properties for pipe
        pipeFromAbove.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipeFromAbove.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        pipeFromAbove.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        self.addChild(pipeFromAbove)
        
        pipeFromBelow.position = CGPoint(x: self.frame.maxX + 0.5 * self.frame.width, y: self.frame.midY - 0.5 * pipeFromBelowTexture.size().height - pipeGap + pipeOffset)
        pipeFromBelow.zPosition = -1
        pipeFromBelow.run(movePipes)
        
        
        //Setup physics body for pipes (must set gravity to false)
        pipeFromBelow.physicsBody = SKPhysicsBody(rectangleOf: pipeFromBelowTexture.size())
        pipeFromBelow.physicsBody?.isDynamic = false
        
        //Set up collision properties for pipe
        pipeFromBelow.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipeFromBelow.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        pipeFromBelow.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        self.addChild(self.pipeFromBelow)
        
    //Create "gap" object to detect passing between pipes for scoring
        
        let gap = SKNode()  //Needed to detect when bird flies between pipes

        gap.position = CGPoint(x: self.frame.maxX + 0.5 * self.frame.width, y: self.frame.midY + pipeOffset)  //x position same as pipes
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeFromAboveTexture.size().width, height: 2*pipeGap))
        
        gap.physicsBody?.isDynamic = false //no gravity
        
        gap.run(movePipes)
        
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue      // Category is Gap
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue  //Notify us if contact with bird
        gap.physicsBody!.collisionBitMask = ColliderType.None.rawValue  //Physics engine controls reaction w/None
        self.addChild(gap)
        
    } //End makePipes
    
    
    // didBegin triggers when collision detected
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameOver == false {
            
        
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
                score += 1
                scoreLabel.text = "Your score = \(String(score))"
                
                print("Passed thru gap. Body A = \(contact.bodyA.contactTestBitMask), \(contact.bodyA.categoryBitMask), \(contact.bodyA.collisionBitMask), Body B = \(contact.bodyB.contactTestBitMask), \(contact.bodyB.categoryBitMask), \(contact.bodyB.collisionBitMask)")
            
            } else {
        
                print("Collision. Body A = \(contact.bodyA.contactTestBitMask), \(contact.bodyA.categoryBitMask), \(contact.bodyA.collisionBitMask), Body B = \(contact.bodyB.contactTestBitMask), \(contact.bodyB.categoryBitMask), \(contact.bodyB.collisionBitMask)")
                self.speed = 0
                gameOver = true

                
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                gameOverLabel.text = "Game Over.  Tap to play again."
                self.addChild(gameOverLabel)
            }
        }
    } //end fn didBegin
    
    
    // didMove(to: view) --> Like "viewDidLoad" method.  Scene did appear on screen
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setUpGame()
        
        
    } //End didMove function
    
    func setUpGame() {
        
        score = 0
        scoreLabel.text = "Your score = \(String(score))"
        timer.invalidate()
        
        //Timer for randomly creating pipes every 3 seconds
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
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
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        bird.physicsBody?.isDynamic = false //bird stays in middle of screen till touches begin
        bird.run(makeBirdFlap)
        
        //Set up contact interactions w/pipe & ground (only 1st one required)
        
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(bird)

        
        background1 = SKSpriteNode(texture: backgroundTexture)
        background1.run(moveBackground)
        
        background2 = SKSpriteNode(texture: backgroundTexture)
        background2.run(moveBackground)
        
        
        //Position element. self=view controller, frame= frame in which items are contained, midX & midY = middle
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        background1.zPosition = -2
        background1.position = CGPoint(x: 0, y: self.frame.midY)
        background1.size = CGSize(width: backgroundTexture.size().width, height: self.frame.height)
        self.addChild(background1)
        
        
        background2.zPosition = -2
        background2.position = CGPoint(x: backgroundTexture.size().width, y: self.frame.midY)
        background2.size = CGSize(width: backgroundTexture.size().width, height: self.frame.height)
        self.addChild(background2)
        

        
        ground.position = CGPoint(x: 0, y: -self.frame.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false //gravity. Ground should stay in place
        
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        self.addChild(ground)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60 //pixels
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height/2 - 70)
        self.addChild(scoreLabel)

    } //end setUpGame
    
    //user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !gameOver {
        
            bird.physicsBody!.isDynamic = true  //gravity. not needed. default is true
        
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0) //total distance of animation per second
        
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 60))  //move up 60 pixels
            
        } else {
            
            gameOver = false
            self.removeAllChildren()
            setUpGame()
            self.speed = 1
            
        }
        
    }
    
    //called several times per second (check for collisions, move items, etc
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
