//
//  GameOver.m
//  SpriteWalkthrough
//
//  Created by Guilherme Castro on 21/03/14.
//  Copyright (c) 2014 Guilherme Castro. All rights reserved.
//

#import "SpaceshipScene.h"
#import "GameOver.h"

@interface GameOver ()
@property BOOL contentCreated;
@end

@implementation GameOver{
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readyAD" object:nil userInfo:nil];
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self initializeBackground];
    [self addChild:[self newHelloNode]];
    [self addChild:[self newScoreNode]];
    [self addChild:[self newBestScoreNode]];
}

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    NSArray *ulose = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ULose" ofType:@"plist"]];
    int index = arc4random_uniform(6);
    helloNode.text = ulose[index];
    
    helloNode.fontSize = width*0.06;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),(height*3)/4);
    
    helloNode.name = @"helloNode";
    
    return helloNode;
}

- (SKLabelNode *)newScoreNode
{
    SKLabelNode *scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreNode.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"score"];
    
    scoreNode.fontSize = width*0.04;
    scoreNode.position = CGPointMake(CGRectGetMidX(self.frame),height/2);
    
    scoreNode.name = @"scoreNode";
    
    return scoreNode;
}

- (SKLabelNode *)newBestScoreNode
{
    SKLabelNode *bscoreNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    bscoreNode.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"bestScore"];
    
    bscoreNode.fontSize = width*0.04;
    bscoreNode.position = CGPointMake(CGRectGetMidX(self.frame),height/4);
    
    bscoreNode.name = @"bscoreNode";
    
    return bscoreNode;
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
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    SKNode *score = [self childNodeWithName:@"scoreNode"];
    SKNode *bscore = [self childNodeWithName:@"bscoreNode"];
    if (helloNode != nil)
    {
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        [score runAction:fadeAway];
        [bscore runAction:fadeAway];
        SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
        [helloNode runAction: moveSequence completion:^{
            [score runAction:remove];
            [score runAction:remove];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAD" object:nil userInfo:nil];
            SKScene *spaceshipScene  = [[SpaceshipScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene:spaceshipScene transition:doors];
        }];
    }
}

@end


