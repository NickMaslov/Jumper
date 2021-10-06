//
//  GameScene.swift
//  Jumper
//
//  Created by Mykola Maslov on 10/6/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sky: EndlessBackground!
    var forest: EndlessBackground!
    var ground: EndlessBackground!
    var girl: SKSpriteNode!
    var dino: SKSpriteNode!
    
    var isOver = false
    
    override func didMove(to view: SKView) {
        sky = EndlessBackground(parent: self, sprite: self.childNode(withName: "sky") as! SKSpriteNode, speed: 1)
        forest = EndlessBackground(parent: self, sprite: self.childNode(withName: "forest") as! SKSpriteNode, speed: 3)
        ground = EndlessBackground(parent: self, sprite: self.childNode(withName: "ground") as! SKSpriteNode, speed: 6)
        
        girl = self.childNode(withName: "girl") as? SKSpriteNode
        dino =  self.childNode(withName: "dino") as? SKSpriteNode
        
        
        let backgroundMusic = SKAudioNode(fileNamed: "theme.mp3")
        backgroundMusic.autoplayLooped = true
        self.addChild(backgroundMusic)
        
        
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        sky.update()
        forest.update()
        ground.update()
        updateDino()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if girl.physicsBody?.velocity.dy == 0 && !isOver {
            self.run(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false))
            girl.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
    }
    
    func updateDino() {
        if dino.position.x + dino.size.width < 0 {
            self.run(SKAction.playSoundFileNamed("dinosaur.wav", waitForCompletion: false))
            dino.position.x = self.size.width
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == 2 | 4 {
            gameOver()
        }
    }
    
    func gameOver() {
        isOver = true
        dino.removeAllActions()
        girl.removeAllActions()
        
        ground.stop()
        forest.stop()
        sky.stop()
    }
    
}
