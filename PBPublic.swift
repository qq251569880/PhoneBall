//
//  PBPublic.swift
//  PhoneBall
//
//  Created by 张宏台 on 14-9-22.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import Foundation
import UIKit

let PBBoardWidth:CGFloat = 284;
let PBBoardHeight:CGFloat = 481;

let PBedgeSize:CGFloat = 9;//场地边界宽度
let PBHalfWidth:CGFloat = 92;//除球门外半边宽度
let PBHalfHeight:CGFloat = 231;//场地高度的一半
let PBHalfDoor:CGFloat = 41;

//检测MASK
let ballCategory:UInt32 = 0x01;
let redPlayerCategory:UInt32 = 0x02;
let bluePlayerCategory:UInt32 = 0x04;
let centerCategory:UInt32 = 0x08;
let edgeCategory:UInt32 = 0x10;

//玩家xy移动最大速度的75%作为电脑速度上限
var xRobotSpeed:CGFloat = 0.0;
var yRobotSpeed:CGFloat = 0.0;
var robotInterval = 5;
var roboTick = 0;