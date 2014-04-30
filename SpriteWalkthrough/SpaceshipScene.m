//
//  SpaceshipScene.m
//  SpriteWalkthrough
//
//  Created by Guilherme Castro on 18/03/14.
//  Copyright (c) 2014 Guilherme Castro. All rights reserved.
//

#import "SpaceshipScene.h"
#import "GameOver.h"


const uint32_t PLAYER = 0x1 << 0;
const uint32_t ROCK = 0x1 << 1;
const uint32_t ROCKIES = 0x1 << 2;

@interface SpaceshipScene ()
@property BOOL contentCreated;
@property SKSpriteNode *character;
@property SKSpriteNode *rock;
@property SKLabelNode *score;
@property SKSpriteNode *bg1;
@property SKSpriteNode *bg1d;
@property SKSpriteNode *bg2;
@property SKSpriteNode *bg2d;
@end

@implementation SpaceshipScene{
    int counter;
    int cooldown;
    float width;
    float height;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.physicsWorld.contactDelegate = (id)self;
        width = self.scene.size.width;
        height = self.scene.size.height;
        [self createSceneContents];
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"device"]){
            self.physicsWorld.gravity = CGVectorMake(0.0f, -7.8f);
        }
        else if([[NSUserDefaults standardUserDefaults] boolForKey:@"device"]){
            self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
        }
        
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self initializeBackground];
    
    _score = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _score.text = @"0";
    _score.fontSize = 20;
    _score.fontColor = [UIColor blackColor];
    _score.position = CGPointMake(CGRectGetMidX(self.frame),self.size.height-40);
    _score.name = @"score";
    [self addChild:(_score)];
    
    [self createCharacter];
    [self addActionButtons];
    
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(platformCreator) onTarget:self],
                                                [SKAction waitForDuration:2]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
    
    SKAction *makeRockys = [SKAction sequence: @[
                                                 [SKAction performSelector:@selector(addRocky) onTarget:self],
                                                 [SKAction waitForDuration:0.4]
                                                 ]];
    [self runAction: [SKAction repeatActionForever:makeRockys]];
    
    _character.physicsBody.velocity = CGVectorMake(0, 0);
    _character.physicsBody.allowsRotation = YES;
    _character.physicsBody.mass = 0.08;
    _character.physicsBody.categoryBitMask = PLAYER;
    _character.physicsBody.collisionBitMask = PLAYER | ROCK | ROCKIES;
    _character.physicsBody.contactTestBitMask = ROCK | ROCKIES;
}


-(void)createCharacter{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"shitty_character.png"];
    SKSpriteNode *charNode = [[SKSpriteNode alloc] initWithTexture:texture color:[UIColor blackColor] size:CGSizeMake(width*0.06, height*0.06)];
    
    charNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:charNode.size];
    charNode.physicsBody.dynamic = YES;
    _character.name = @"character";
    
    _character = charNode;
    [self addChild:_character];
    _character.position = CGPointMake(width/2, height/2);
    
}

-(void)platformCreator{
    
    float x = [self randomFloatBetween:width and:width*2];;
    float y = height/7;
    CGSize size = CGSizeMake(x,y);
    CGPoint position = CGPointMake(width+(size.width/2), arc4random_uniform(height/4));
    
    if (_contentCreated) {
        position = CGPointMake(width, arc4random_uniform(height/4));
        size.width = width*2;
        _contentCreated = false;
    }
    else{
        position = CGPointMake(width+(size.width/2), arc4random_uniform(height/4));
    }
    
    SKAction *moveAction = [SKAction moveToX:-width-(size.width/2) duration:3.5-(double)counter/5000];
    [self createPlatform:position withSize:size withMoveAction:moveAction];
}


-(void)createPlatform:(CGPoint)position withSize:(CGSize)size withMoveAction:(SKAction *)moveAction{
    SKTexture *preda = [SKTexture textureWithImageNamed:@"preda.png"];
    _rock = [[SKSpriteNode alloc] initWithTexture:preda color:[SKColor brownColor] size:size];
    _rock.position = position;
    _rock.name = @"rock";
    
    _rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_rock.size];
    _rock.physicsBody.usesPreciseCollisionDetection = YES;
    _rock.physicsBody.affectedByGravity = NO;
    [self addChild:_rock];
    _rock.physicsBody.categoryBitMask = ROCK;
    _rock.physicsBody.collisionBitMask = ROCK | PLAYER;
    _rock.physicsBody.dynamic = NO;
    SKAction *remove = [SKAction removeFromParent];
    SKAction *action = [SKAction sequence:@[moveAction, remove]];
    [_rock runAction:action];
}

/*
 - (void)addRockIpad
 {
 self.rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake([self randomFloatBetween:900.0 and:1000.0],100)];
 _rock.position = CGPointMake(width+(_rock.size.width/2), arc4random_uniform(200));
 _rock.name = @"rock";
 
 _rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_rock.size];
 _rock.physicsBody.usesPreciseCollisionDetection = YES;
 _rock.physicsBody.affectedByGravity = NO;
 [self addChild:_rock];
 _rock.physicsBody.categoryBitMask = ROCK;
 _rock.physicsBody.collisionBitMask = ROCK | PLAYER;
 _rock.physicsBody.dynamic = NO;
 SKAction *remove = [SKAction removeFromParent];
 SKAction *moveRight = [SKAction moveByX:-width*5 y:0 duration:7.0];
 SKAction *action = [SKAction sequence:@[moveRight, remove]];
 [_rock runAction:action];
 
 }
 
 - (void)addRockIphone
 {
 self.rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(width, height/7)];
 _rock.position = CGPointMake(width+(_rock.size.width/2), arc4random_uniform(60));
 _rock.name = @"rock";
 
 _rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_rock.size];
 _rock.physicsBody.usesPreciseCollisionDetection = YES;
 _rock.physicsBody.affectedByGravity = NO;
 [self addChild:_rock];
 _rock.physicsBody.categoryBitMask = ROCK;
 _rock.physicsBody.collisionBitMask = ROCK | PLAYER;
 _rock.physicsBody.dynamic = NO;
 SKAction *remove = [SKAction removeFromParent];
 SKAction *moveRight = [SKAction moveByX:-width*5 y:0 duration:5.0];
 SKAction *action = [SKAction sequence:@[moveRight, remove]];
 [_rock runAction:action];
 }
 */

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void)addRocky{
    SKSpriteNode *rocky = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(width*0.02,width*0.02)];
    rocky.position = CGPointMake(arc4random_uniform(width), self.size.height);
//    rocky.position = CGPointMake(width, arc4random_uniform(height));
    rocky.name = @"rocky";
    
    rocky.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rocky.size];
    rocky.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rocky];
    rocky.physicsBody.mass = 9001;
    rocky.physicsBody.categoryBitMask = ROCKIES;
    rocky.physicsBody.collisionBitMask = PLAYER | ROCKIES;
    
    //[rocky.physicsBody applyImpulse:CGVectorMake(0, 0)];
}

/*
 - (void)addRockyIpad
 {
 SKSpriteNode *rocky = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(10,10)];
 rocky.position = CGPointMake(arc4random_uniform(width), self.size.height);
 rocky.name = @"rocky";
 
 rocky.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rocky.size];
 rocky.physicsBody.usesPreciseCollisionDetection = YES;
 [self addChild:rocky];
 rocky.physicsBody.mass = 9001;
 rocky.physicsBody.categoryBitMask = ROCKIES;
 rocky.physicsBody.collisionBitMask = PLAYER | ROCKIES;
 }
 
 - (void)addRockyIphone
 {
 SKSpriteNode *rocky = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(5,5)];
 rocky.position = CGPointMake(arc4random_uniform(width), self.size.height);
 rocky.name = @"rocky";
 
 rocky.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rocky.size];
 rocky.physicsBody.usesPreciseCollisionDetection = YES;
 [self addChild:rocky];
 rocky.physicsBody.mass = 9001;
 rocky.physicsBody.categoryBitMask = ROCKIES;
 rocky.physicsBody.collisionBitMask = PLAYER | ROCKIES;
 }
 */

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rocky" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0){
            [node removeFromParent];
        }
    }];
}

-(void)initializeBackground{
    SKTexture *fundo = [SKTexture textureWithImageNamed:@"fundo.png"];
    SKTexture *montanha = [SKTexture textureWithImageNamed:@"Montanhas.png"];
    SKTexture *bosque = [SKTexture textureWithImageNamed:@"bosque.png"];
    
    SKSpriteNode *back = [[SKSpriteNode alloc] initWithTexture:fundo color:[UIColor blackColor] size:CGSizeMake(width, height)];
    back.anchorPoint = CGPointZero;
    back.position = CGPointMake(0, 0);
    [self addChild:back];
    
    _bg1 = [[SKSpriteNode alloc] initWithTexture:montanha color:[UIColor blackColor] size:CGSizeMake(width, height)];
    _bg1d = [[SKSpriteNode alloc] initWithTexture:bosque color:[UIColor blackColor] size:CGSizeMake(width, height/2)];
    _bg2 = [[SKSpriteNode alloc] initWithTexture:montanha color:[UIColor blackColor] size:CGSizeMake(width, height)];
    _bg2d = [[SKSpriteNode alloc] initWithTexture:bosque color:[UIColor blackColor] size:CGSizeMake(width, height/2)];
    
    _bg1.anchorPoint = CGPointZero;
    _bg1.position = CGPointMake(0, height/10);
    [self addChild:_bg1];
    
    _bg2.anchorPoint = CGPointZero;
    _bg2.position = CGPointMake(_bg1.size.width-1, height/10);
    [self addChild:_bg2];
    
    _bg1d.anchorPoint = CGPointZero;
    _bg1d.position = CGPointMake(0, 0);
    [self addChild:_bg1d];
    
    _bg2d.anchorPoint = CGPointZero;
    _bg2d.position = CGPointMake(_bg1.size.width-1, 0);
    [self addChild:_bg2d];
}

-(void)addActionButtons{
    
    CGSize size = CGSizeMake(width/10, width/10);
    CGPoint rightPosition = CGPointMake(width-size.width/2, size.height/2);
    CGPoint leftPosition = CGPointMake(size.width/2,size.height/2);
    
    SKSpriteNode *leftActionNode = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:size];
    leftActionNode.position = leftPosition;
    leftActionNode.name = @"leftActionNode";
    leftActionNode.zPosition = 1.0;
    
    SKSpriteNode *rightActionNode = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:size];
    rightActionNode.position = rightPosition;
    rightActionNode.name = @"rightActionNode";
    rightActionNode.zPosition = 1.0;
    
    [self addChild:leftActionNode];
    [self addChild:rightActionNode];
}

-(void)gameOver{
    [[NSUserDefaults standardUserDefaults] setObject:_score.text forKey:@"score"];
    int score = [_score.text intValue];
    int bestScore = [[[NSUserDefaults standardUserDefaults]objectForKey:@"bestScore"] intValue];
    if(score > bestScore){
        [[NSUserDefaults standardUserDefaults] setObject:_score.text forKey:@"bestScore"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeAllChildren];
    [self removeAllActions];
    [self createSceneContents];
    SKScene *gameOver  = [[GameOver alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:gameOver transition:doors];
}


-(void)update:(NSTimeInterval)currentTime{
    
    if(_character.position.y < 0 || _character.position.x < 0|| _character.position.x > width || _character.position.y > height){
        [self gameOver];
    }
    
    counter++;
    cooldown--;
    _score.text = [NSString stringWithFormat:@"%d",counter];
    
    _bg1.position = CGPointMake(_bg1.position.x-width*(double)counter/5000000, _bg1.position.y);
    _bg2.position = CGPointMake(_bg2.position.x-width*(double)counter/5000000, _bg2.position.y);
    _bg1d.position = CGPointMake(_bg1d.position.x-width*(double)counter/500000, _bg1d.position.y);
    _bg2d.position = CGPointMake(_bg2d.position.x-width*(double)counter/500000, _bg2d.position.y);
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"device"]){
        self.physicsWorld.gravity = CGVectorMake(0.0f, -7.8f - ((double)counter/5000));
    }
    else if([[NSUserDefaults standardUserDefaults] boolForKey:@"device"]){
        self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f  - ((double)counter/5000));
    }
    
    //Switch Background
    if (_bg1.position.x < -_bg1.size.width){
        _bg1.position = CGPointMake(_bg2.position.x + _bg2.size.width, _bg1.position.y);
    }
    
    if (_bg1d.position.x < -_bg1d.size.width){
        _bg1d.position = CGPointMake(_bg2d.position.x + _bg2d.size.width, _bg1d.position.y);
    }
    
    if (_bg2.position.x < -_bg2.size.width) {
        _bg2.position = CGPointMake(_bg1.position.x + _bg1.size.width, _bg2.position.y);
    }
    
    if (_bg2d.position.x < -_bg2d.size.width) {
        _bg2d.position = CGPointMake(_bg1d.position.x + _bg1d.size.width, _bg2d.position.y);
    }
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    NSLog(@"%@",_character.physicsBody.allContactedBodies);
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"device"]){
        if ([node.name isEqualToString:@"rightActionNode"]) {
            [_character.physicsBody applyImpulse:CGVectorMake(15.0, 3.0)];
            _character.texture = [SKTexture textureWithImageNamed:@"shitty_character2"];
            return;
        }
        
        if ([node.name isEqualToString:@"leftActionNode"]) {
            [_character.physicsBody applyImpulse:CGVectorMake(-15.0, 3.0)];
            _character.texture = [SKTexture textureWithImageNamed:@"shitty_character2"];
            return;
        }
        
        if(cooldown<10){
            [_character.physicsBody applyImpulse:CGVectorMake(0.0, 50.0)];
            _character.texture = [SKTexture textureWithImageNamed:@"shitty_character2"];
            cooldown = 50;
        }
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"device"]){
        if ([node.name isEqualToString:@"rightActionNode"]) {
            [_character.physicsBody applyImpulse:CGVectorMake(20.0, 5.0)];
            _character.texture = [SKTexture textureWithImageNamed:@"shitty_character2"];
            return;
        }
        
        if ([node.name isEqualToString:@"leftActionNode"]) {
            [_character.physicsBody applyImpulse:CGVectorMake(-20.0, 5.0)];
            _character.texture = [SKTexture textureWithImageNamed:@"shitty_character2"];
            return;
        }
        
        if(cooldown < 10){
            [_character.physicsBody applyImpulse:CGVectorMake(0.0, 80)];
            _character.texture = [SKTexture textureWithImageNamed:@"shitty_character2"];
            cooldown = 50;
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if([contact.bodyB.node.name isEqualToString:@"rock"]){
        _character.texture = [SKTexture textureWithImageNamed:@"shitty_character.png"];
    }
    else{
        [self runAction:[SKAction playSoundFileNamed:@"bslap.mp3" waitForCompletion:NO]];
    }
}

@end