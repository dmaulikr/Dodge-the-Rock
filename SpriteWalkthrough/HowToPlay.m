//
//  HowToPlay.m
//  SpriteWalkthrough
//
//  Created by Guilherme Castro on 25/03/14.
//  Copyright (c) 2014 Guilherme Castro. All rights reserved.
//

#import "HowToPlay.h"
#import "HelloScene.h"

@interface HowToPlay ()
@property BOOL contentCreated;
@end

@implementation HowToPlay{
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
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self initializeBackground];
    [self addChild:[self newFiNode]];
    [self addChild:[self newSiNode]];
    [self addChild:[self newTiNode]];
    [self addChild:[self newBackNode]];
}

- (SKLabelNode *)newFiNode
{
    SKLabelNode *firstInstrucionNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    firstInstrucionNode.text = @"Tap the screen to jump";
    
    firstInstrucionNode.fontSize = width*0.03;
    firstInstrucionNode.position = CGPointMake(CGRectGetMidX(self.frame),(height*3)/4);
    
    firstInstrucionNode.name = @"fiNode";
    
    return firstInstrucionNode;
}


- (SKLabelNode *)newSiNode
{
    SKLabelNode *secondInstructionNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    secondInstructionNode.text = @"Tap the bottom buttons to dash";
    
    secondInstructionNode.fontSize = width*0.03;
    secondInstructionNode.position = CGPointMake(CGRectGetMidX(self.frame),height/2);
    
    secondInstructionNode.name = @"siNode";
    
    return secondInstructionNode;
}

- (SKLabelNode *)newTiNode
{
    SKLabelNode *thirdInstrucionNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    thirdInstrucionNode.text = @"Avoid the rocks and\n the edge of the screen";
    
    thirdInstrucionNode.fontSize = width*0.03;
    thirdInstrucionNode.position = CGPointMake(CGRectGetMidX(self.frame),height/4);
    
    thirdInstrucionNode.name = @"tiNode";
    
    return thirdInstrucionNode;
}

- (SKLabelNode *)newBackNode
{
    SKLabelNode *backNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backNode.text = @"Tap To Go Back";
    
    backNode.fontSize = width*0.03;
    backNode.position = CGPointMake(CGRectGetMidX(self.frame),height/8);
    
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
    
    SKNode *fiNode = [self childNodeWithName:@"fiNode"];
    SKNode *siNode = [self childNodeWithName:@"siNode"];
    SKNode *tiNode = [self childNodeWithName:@"tiNode"];
    
    SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
    
    if([node.name isEqualToString:@"backNode"]){
        [fiNode runAction:moveSequence];
        [siNode runAction:moveSequence];
        [tiNode runAction:moveSequence];
        SKScene *helloScene  = [[HelloScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:helloScene transition:doors];
    }
}
@end