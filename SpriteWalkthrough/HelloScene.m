//
//  HelloScene.m
//  SpriteWalkthrough
//
//  Created by Guilherme Castro on 17/03/14.
//  Copyright (c) 2014 Guilherme Castro. All rights reserved.
//

#import "HelloScene.h"
#import "SpaceshipScene.h"
#import "HowToPlay.h"
#import "Credits.h"

@interface HelloScene ()
@property BOOL contentCreated;
@end

@implementation HelloScene{
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
    [self addChild:[self newHelloNode]];
    [self addChild:[self newStartNode]];
    [self addChild:[self newHowToPlayNode]];
    [self addChild:[self newCreditsNode]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             @"0", @"score",
                                                             @"0", @"bestScore",nil]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.text = @"Dodge The Rock";
    
    helloNode.fontSize = width*0.06;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),(height*3)/4);
    
    helloNode.name = @"helloNode";
    
    return helloNode;
}

- (SKLabelNode *)newStartNode
{
    SKLabelNode *startNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    startNode.text = @"Tap to Start";
    
    startNode.fontSize = width*0.04;
    startNode.position = CGPointMake(CGRectGetMidX(self.frame),height/2);
    
    startNode.name = @"startNode";
    
    return startNode;
}

- (SKLabelNode *)newHowToPlayNode
{
    SKLabelNode *htpNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    htpNode.text = @"How To Play";
    
    htpNode.fontSize = width*0.04;
    htpNode.position = CGPointMake(CGRectGetMidX(self.frame),(height*3)/8);
    htpNode.name = @"htpNode";
    
    return htpNode;
}

- (SKLabelNode *)newCreditsNode
{
    SKLabelNode *creditNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    creditNode.text = @"Credits";
    
    creditNode.fontSize = width*0.04;
    creditNode.position = CGPointMake(CGRectGetMidX(self.frame),height/4);
    creditNode.name = @"creditsNode";
    
    return creditNode;
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
    
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    SKNode *startNode = [self childNodeWithName:@"startNode"];
    SKNode *htpNode = [self childNodeWithName:@"htpNode"];
    SKNode *back = [self childNodeWithName:@"backGround"];
    SKNode *crediNode = [self childNodeWithName:@"creditsNode"];
    
    SKAction *zoom = [SKAction scaleTo: 1.5 duration: 0.25];
    SKAction *pause = [SKAction waitForDuration: 0.5];
    SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *moveSequence = [SKAction sequence:@[zoom, pause, fadeAway, remove]];
    
    if ([node.name isEqualToString:helloNode.name] || [node.name isEqualToString:startNode.name])
    {
        [startNode runAction:fadeAway];
        [htpNode runAction:fadeAway];
        [crediNode runAction:fadeAway];
        [helloNode runAction: moveSequence completion:^{
            [startNode runAction:remove];
            [htpNode runAction:remove];
            [crediNode runAction:remove];
            [back runAction:fadeAway];
            [back runAction:remove];
            SKScene *spaceshipScene  = [[SpaceshipScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene:spaceshipScene transition:doors];
        }];
    }
    
    if([node.name isEqualToString:@"htpNode"])
    {
        [startNode runAction:fadeAway];
        [helloNode runAction:fadeAway];
        [crediNode runAction:fadeAway];
        [htpNode runAction: moveSequence completion:^{
            [startNode runAction:remove];
            [helloNode runAction:remove];
            [crediNode runAction:remove];
            [back runAction:fadeAway];
            [back runAction:remove];
            SKScene *howToPlay  = [[HowToPlay alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene:howToPlay transition:doors];
        }];
    }
    
    if([node.name isEqualToString:@"creditsNode"])
    {
        [startNode runAction:fadeAway];
        [helloNode runAction:fadeAway];
        [htpNode runAction:fadeAway];
        [crediNode runAction: moveSequence completion:^{
            [startNode runAction:remove];
            [helloNode runAction:remove];
            [htpNode runAction:remove];
            [back runAction:fadeAway];
            [back runAction:remove];
            SKScene *credits  = [[Credits alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene:credits transition:doors];
        }];
    }
    
}

@end
