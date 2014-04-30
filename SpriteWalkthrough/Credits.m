//
//  Credits.m
//  SpriteWalkthrough
//
//  Created by Guilherme Castro on 27/03/14.
//  Copyright (c) 2014 Guilherme Castro. All rights reserved.
//

#import "Credits.h"
#import "HelloScene.h"

@interface Credits ()
@property BOOL contentCreated;
@end

@implementation Credits{
    float width;
    float height;
}

- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        width = self.scene.size.width;
        height = self.scene.size.height;
        [self createSceneContents];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -4.8f);
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(width, 0)];
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self initializeBackground];
    [self addChild:[self platformWithLabel:[self newProgNode] withI:1]];
    [self addChild:[self platformWithLabel:[self newLartNode] withI:2]];
    [self addChild:[self platformWithLabel:[self newBackNode] withI:3]];
//    [self addChild:[self newProgNode]];
//    [self addChild:[self newLartNode]];
//    [self addChild:[self newMusicNode]];
//    [self addChild:[self newMusicNode2]];
//    [self addChild:[self newMusicNode3]];
}

- (SKSpriteNode *)platformWithLabel:(SKLabelNode *) label withI:(int) i{
    SKSpriteNode *platform = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(width, height/4)];
    platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform.size];
    platform.position = CGPointMake(width/2, height*i);
    [platform addChild:label];
    
    return platform;
}


- (SKLabelNode *)newProgNode
{
    SKLabelNode *progNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    progNode.text = @"Programming - Guilherme Castro";
    
    progNode.fontSize = width*0.04;
    progNode.position = CGPointMake(0, 0);
    
    progNode.name = @"progNode";
    
    return progNode;
}

- (SKLabelNode *)newLartNode
{
    SKLabelNode *lartNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lartNode.text = @"Art Design - Vitor Fernandez";
    
    lartNode.fontSize = width*0.04;
    lartNode.position = CGPointMake(0,0);
    
    lartNode.name = @"lartNode";
    
    return lartNode;
}

- (SKLabelNode *)newMusicNode
{
    SKLabelNode *musicNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    musicNode.text = @"Go Cart - Loop Mix Kevin MacLeod (incompetech.com)";
    
    musicNode.fontSize = width*0.03;
    musicNode.position = CGPointMake(CGRectGetMidX(self.frame),(height*3)/8);
    
    musicNode.name = @"musicNode";
    
    return musicNode;
}

- (SKLabelNode *)newMusicNode2
{
    SKLabelNode *musicNode2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    musicNode2.text = @"Licensed under Creative Commons: By Attribution";
    
    musicNode2.fontSize = width*0.03;
    musicNode2.position = CGPointMake(CGRectGetMidX(self.frame),(height*2)/6);
    
    musicNode2.name = @"musicNode2";
    
    return musicNode2;
}

- (SKLabelNode *)newMusicNode3
{
    SKLabelNode *musicNode3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    musicNode3.text = @"http://creativecommons.org/licenses/by/3.0/";
    
    musicNode3.fontSize = width*0.03;
    musicNode3.position = CGPointMake(CGRectGetMidX(self.frame),(height*2)/8);
    
    musicNode3.name = @"musicNode3";
    
    return musicNode3;
}

- (SKLabelNode *)newBackNode
{
    SKLabelNode *backNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backNode.text = @"Tap To Go Back";
    
    backNode.fontSize = width*0.04;
    backNode.position = CGPointMake(0,0);
    
    backNode.name = @"backNode";
    
    return backNode;
}

-(void)initializeBackground{
    
    SKTexture *fundo = [SKTexture textureWithImageNamed:@"fundo.png"];
    SKTexture *montanha = [SKTexture textureWithImageNamed:@"Montanhas.png"];
    SKTexture *bosque = [SKTexture textureWithImageNamed:@"bosque.png"];
    
    SKSpriteNode *back = [[SKSpriteNode alloc] initWithTexture:fundo color:[UIColor blackColor] size:CGSizeMake(width, height)];
    back.anchorPoint = CGPointZero;
    back.position = CGPointMake(0, 0);
    [self addChild:back];
    
    SKSpriteNode *back1 = [[SKSpriteNode alloc] initWithTexture:montanha color:[UIColor blackColor] size:CGSizeMake(width, height)];
    SKSpriteNode *bg1d = [[SKSpriteNode alloc] initWithTexture:bosque color:[UIColor blackColor] size:CGSizeMake(width, height/2)];
    
    back1.anchorPoint = CGPointZero;
    back1.position = CGPointMake(0, height/10);
    [self addChild:back1];
    
    bg1d.anchorPoint = CGPointZero;
    bg1d.position = CGPointMake(0, 0);
    [self addChild:bg1d];
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    SKNode *progNode = [self childNodeWithName:@"progNode"];
    SKNode *lartNode = [self childNodeWithName:@"lartNode"];
    SKNode *musicNode = [self childNodeWithName:@"musicNode"];
    SKNode *musicNode2 = [self childNodeWithName:@"musicNode2"];
    SKNode *musicNode3 = [self childNodeWithName:@"musicNode3"];
    
    SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
    
    if([node.name isEqualToString:@"backNode"]){
        [progNode runAction:moveSequence];
        [lartNode runAction:moveSequence];
        [musicNode runAction:moveSequence];
        [musicNode2 runAction:moveSequence];
        [musicNode3 runAction:moveSequence];
        SKScene *helloScene  = [[HelloScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:helloScene transition:doors];
    }
}

@end