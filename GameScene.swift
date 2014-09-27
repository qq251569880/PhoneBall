//
//  GameScene.swift
//  PhoneBall
//
//  Created by 张宏台 on 14-9-22.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {

    //场景使用的数据
    //场地中心位置
    var boardPosition:CGPoint = CGPointMake(0,0);
    //场地大小
    var boardSize:CGSize = CGSize(width: 0,height: 0);
    //球门位置
    var topy:CGFloat = 0.0;
    var bottomy:CGFloat = 0.0;
    var leftDoorx:CGFloat = 0.0;
    var rightDoorx:CGFloat = 0.0;
    //
    //各节点实体
    var backgroundBoard = SKSpriteNode();
    var redControl = SKSpriteNode();
    var blueControl = SKSpriteNode();
    var whiteBall = SKSpriteNode();

    var lastPosition:CGPoint?;
    var currentPosition:CGPoint?;
    var lastUpdateTime:CFTimeInterval?;
    var selectedNode:SKNode?;
    
    var gameOver:Bool = false;
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        var skyColor = SKColor();
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0);
        self.backgroundColor = skyColor;

        //添加背景场地
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
        //backgroundBoard.zPosition = 1;
        boardPosition = backgroundBoard.position
        self.addChild(backgroundBoard)
        //添加物理边界
        addEdgePhysics();
        
        //添加物理实体
        addVolumePhysics();
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */

        for touch: AnyObject in touches {
            lastPosition = touch.locationInNode(self)
            let node = self.nodeAtPoint(lastPosition!)
            if node === redControl {
                selectedNode = redControl;
            }
        }
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            var location = touch.locationInNode(self)
            if(selectedNode != nil){
                if(location.y > boardPosition.y){
                    location.y = boardPosition.y - 1;
                }
                currentPosition = location;
//                 var action = SKAction();
//                 action = SKAction.moveTo(location,duration:0.01);
//                 if(selectedNode === redControl){
//                     redControl.runAction(action);
//                 }
            }
        }
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        selectedNode = nil;
        lastPosition = nil;
        currentPosition = nil;
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(lastUpdateTime == nil){
            lastUpdateTime = currentTime;
            
        }else{
            if(selectedNode != nil && lastPosition != nil && currentPosition != nil)
            {
                
                selectedNode!.position = currentPosition!;
                lastPosition = currentPosition;
            }
        }
        if(whiteBall.position.y > topy && !gameOver){
            gameOver = true;
            gameAlert("游戏胜利，是否重新开始？");
        }else if(whiteBall.position.y < bottomy && !gameOver){
            gameOver = true;
            gameAlert("游戏失败，是否重新开始？");
        }
    }
    
    //内部自定义函数
    func gameAlert(info:String){
        let tit = NSLocalizedString("提示", comment: "")
        let msg = NSLocalizedString(info, comment: "")
        var alert:UIAlertView = UIAlertView()
        alert.title = tit
        alert.message = msg
        alert.delegate = self
        alert.addButtonWithTitle("OK")
        alert.addButtonWithTitle("Cancel")
        alert.show()
    }
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex == 0){
            self.restart()
        }
    }
    func restart(){
        gameOver = false;
        redControl.position = CGPointMake( boardPosition.x,boardPosition.y - boardSize.height/4);
        blueControl.position = CGPointMake( boardPosition.x,boardPosition.y + boardSize.height/4)
        whiteBall.position = CGPointMake( boardPosition.x,boardPosition.y)
   }
    func addEdgePhysics(){
        leftDoorx = boardPosition.x - boardSize.width*PBHalfDoor/PBBoardWidth;
        var leftEdgex = boardPosition.x - boardSize.width*(PBHalfDoor+PBHalfWidth)/PBBoardWidth;
        rightDoorx = boardPosition.x + boardSize.width*PBHalfDoor/PBBoardWidth;
        var rightEdgex = boardPosition.x + boardSize.width*(PBHalfDoor+PBHalfWidth)/PBBoardWidth;
        bottomy = boardPosition.y - boardSize.height*PBHalfHeight/PBBoardHeight;
        topy = boardPosition.y + boardSize.height*PBHalfHeight/PBBoardHeight;

        var left1 = CGPointMake( leftDoorx,bottomy );
        var left2 = CGPointMake(leftEdgex,bottomy);
        var left3 = CGPointMake(leftEdgex,topy);
        var left4 = CGPointMake(leftDoorx,topy);
        var edgePath = CGPathCreateMutable();
        CGPathMoveToPoint(edgePath, nil, left1.x, left1.y);
        CGPathAddLineToPoint(edgePath,nil,left2.x,left2.y);
        CGPathAddLineToPoint(edgePath,nil,left3.x,left3.y);
        CGPathAddLineToPoint(edgePath,nil,left4.x,left4.y);

        var right1 = CGPointMake( rightDoorx,bottomy );
        var right2 = CGPointMake(rightEdgex,bottomy);
        var right3 = CGPointMake(rightEdgex,topy);
        var right4 = CGPointMake(rightDoorx,topy);
        var rightPath = CGPathCreateMutable();
        CGPathMoveToPoint(edgePath, nil, right1.x, right1.y);
        CGPathAddLineToPoint(edgePath,nil,right2.x,right2.y);
        CGPathAddLineToPoint(edgePath,nil,right3.x,right3.y);
        CGPathAddLineToPoint(edgePath,nil,right4.x,right4.y);

        self.physicsBody = SKPhysicsBody(edgeChainFromPath:edgePath);
        self.physicsBody!.categoryBitMask = edgeCategory;
        self.physicsBody!.collisionBitMask = 0;
        self.physicsBody!.contactTestBitMask = 0;
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        var centerLine = SKShapeNode();
        var centerPath = CGPathCreateMutable();
        CGPathMoveToPoint(centerPath, nil, leftEdgex, boardPosition.y);
        CGPathAddLineToPoint(centerPath,nil,rightEdgex, boardPosition.y);
        centerLine.path = centerPath;
        centerLine.strokeColor = SKColor.clearColor();
        centerLine.physicsBody = SKPhysicsBody(edgeChainFromPath:centerPath);
        centerLine.physicsBody!.categoryBitMask = centerCategory;
        centerLine.physicsBody!.collisionBitMask = 0;
        centerLine.physicsBody!.contactTestBitMask = 0;
        self.addChild(centerLine);
    }
    func addVolumePhysics(){
        var screen = UIScreen.mainScreen()
        var redTexture = SKTexture(imageNamed: "red");
        redControl = SKSpriteNode(texture:redTexture);
        redControl.setScale(screen.bounds.size.width/backgroundBoard.size.width*0.5);
        redControl.physicsBody = SKPhysicsBody(circleOfRadius:redControl.size.width/2);
        redControl.physicsBody!.dynamic = true;
        redControl.physicsBody!.affectedByGravity = false;
        redControl.physicsBody!.categoryBitMask = redPlayerCategory;
        redControl.physicsBody!.collisionBitMask = ballCategory|centerCategory|edgeCategory;
        redControl.physicsBody!.contactTestBitMask = 0;
        redControl.position = CGPointMake( boardPosition.x,boardPosition.y - boardSize.height/4);

        self.addChild(redControl)

        var blueTexture = SKTexture(imageNamed: "blue");
        blueControl = SKSpriteNode(texture:blueTexture);
        blueControl.setScale(screen.bounds.size.width/backgroundBoard.size.width*0.5);
        blueControl.physicsBody = SKPhysicsBody(circleOfRadius:blueControl.size.width/2);
        blueControl.physicsBody!.dynamic = true;
        blueControl.physicsBody!.affectedByGravity = false;
        blueControl.physicsBody!.categoryBitMask = bluePlayerCategory;
        blueControl.physicsBody!.collisionBitMask = ballCategory|centerCategory|edgeCategory;
        blueControl.physicsBody!.contactTestBitMask = 0;
        blueControl.position = CGPointMake( boardPosition.x,boardPosition.y + boardSize.height/4)
        self.addChild(blueControl)

        var ballTexture = SKTexture(imageNamed: "ball");
        whiteBall = SKSpriteNode(texture:ballTexture);
        whiteBall.setScale(screen.bounds.size.width/backgroundBoard.size.width*0.5);
        whiteBall.physicsBody = SKPhysicsBody(circleOfRadius:whiteBall.size.width/2);
        whiteBall.physicsBody!.dynamic = true;
        whiteBall.physicsBody!.affectedByGravity = false;
        whiteBall.physicsBody!.categoryBitMask = ballCategory;
        whiteBall.physicsBody!.collisionBitMask = edgeCategory|bluePlayerCategory|redPlayerCategory;
        whiteBall.physicsBody!.contactTestBitMask = 0;
        whiteBall.position = CGPointMake( boardPosition.x,boardPosition.y-200)
        self.addChild(whiteBall)
    }
}
