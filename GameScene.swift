//
//  GameScene.swift
//  PhoneBall
//
//  Created by 张宏台 on 14-9-22.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {


    var boardPosition:CGPoint = CGPointMake(0,0);
    var boardSize:CGSize = CGSize(width: 0,height: 0);
    var backgroundBoard = SKSpriteNode();


    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        var skyColor = SKColor();
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0);
        self.backgroundColor = skyColor;

        //添加背景图片，草地，小河，山
        var bgTexture = SKTexture(imageNamed: "background");
        
        //设置大小和位置
        backgroundBoard = SKSpriteNode(texture:bgTexture)
        //在模拟器中我使用screen的大小为参考，否则很难控制这个图片的显示。
        var screen = UIScreen.mainScreen()
        println("screen width:\(screen.bounds.size.width),height:\(screen.bounds.size.height)")
        println("board width:\(backgroundBoard.size.width),height:\(backgroundBoard.size.height)")
        
        backgroundBoard.setScale(screen.bounds.size.width/backgroundBoard.size.width*1.3)
        boardSize = backgroundBoard.size
        
        //它的位置是左右居中。Scene的Y轴是由下至上的，所以是屏幕高度除以2+100，即中间靠上的位置
        backgroundBoard.position = CGPointMake(self.frame.size.width/2,backgroundBoard.size.height/2+50)
        backgroundBoard.zPosition = 1;
        boardPosition = backgroundBoard.position
        self.addChild(backgroundBoard)

        var leftDoorx = boardPosition.x - boardSize.width*PBHalfDoor/PBBoardWidth;
        var leftEdgex = boardPosition.x - boardSize.width*(PBHalfDoor+PBHalfWidth)/PBBoardWidth;
        var rightDoorx = boardPosition.x + boardSize.width*PBHalfDoor/PBBoardWidth;
        var rightEdgex = boardPosition.x + boardSize.width*(PBHalfDoor+PBHalfWidth)/PBBoardWidth;
        var bottomy = boardPosition.y - boardSize.height*PBHalfHeight/PBBoardHeight;
        var topy = boardPosition.y + boardSize.height*PBHalfHeight/PBBoardHeight;

        var left1 = CGPointMake( leftDoorx,bottomy );
        var left2 = CGPointMake(leftEdgex,bottomy);
        var left3 = CGPointMake(leftEdgex,topy);
        var left4 = CGPointMake(leftDoorx,topy);

        var right1 = CGPointMake( rightDoorx,bottomy );
        var right2 = CGPointMake(rightEdgex,bottomy);
        var right3 = CGPointMake(rightEdgex,topy);
        var right4 = CGPointMake(rightDoorx,topy);
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
