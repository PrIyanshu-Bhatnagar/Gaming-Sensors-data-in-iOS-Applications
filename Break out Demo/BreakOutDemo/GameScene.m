//
//  GameScene.m
//  BreakOutDemo
//
//  Created by Priyanshu Bhatnagar on 14/08/16.
//  Copyright (c) 2016 Priyanshu Bhatnagar. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"

static const CGFloat KTrackPointsPerSecond = 1000;

@interface GameScene()
@property (strong,nonatomic,nullable) UITouch *motivatingTouch;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"blueball.png"];
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball1.physicsBody.dynamic = YES;
    ball1.position = CGPointMake(100,self.size.height/2);
    ball1.physicsBody.friction = 0.0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0;
    ball1.physicsBody.angularDamping = 0;
    ball1.physicsBody.allowsRotation = NO;
    ball1.physicsBody.mass = 1;
    ball1.physicsBody.velocity = CGVectorMake(200.0,200.0); //initial Velocity
    
    
    SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"blueball.png"];
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball2.size.width/2];
    ball2.physicsBody.dynamic = YES;
    ball2.position = CGPointMake(150, self.size.height/2);
    ball2.physicsBody.friction = 0.0;
    ball2.physicsBody.restitution = 1.0;
    ball2.physicsBody.linearDamping = 0.0;
    ball2.physicsBody.angularDamping = 0.0;
    ball2.physicsBody.allowsRotation = NO;
    ball2.physicsBody.mass = 1;
    ball2.physicsBody.velocity = CGVectorMake(0.0,0.0);
    
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle.png"];
    paddle.name = @"paddle";
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddle.size.width, paddle.size.height)];
    paddle.physicsBody.dynamic = NO;
    paddle.position = CGPointMake(self.size.width/2, 100);
    paddle.physicsBody.friction = 0.0;
    paddle.physicsBody.restitution = 1.0;
    paddle.physicsBody.linearDamping = 0.0;
    paddle.physicsBody.angularDamping = 0.0;
    paddle.physicsBody.allowsRotation = NO;
    paddle.physicsBody.mass = 1;
    paddle.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    
    [self addChild:ball2];
    [self addChild:ball1];
    [self addChild:paddle];
    
    CGPoint ball1Anchor = CGPointMake(ball1.position.x, ball2.position.y);
    CGPoint ball2Anchor = CGPointMake(ball2.position.x, ball2.position.y);
    
    SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:ball1.physicsBody bodyB:ball2.physicsBody anchorA:ball1Anchor anchorB:ball2Anchor];
    joint.damping = 0.0;
    joint.frequency = 1.5;
    
    [self.scene.physicsWorld addJoint:joint];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    const CGRect touchRegion = CGRectMake(0, 0, self.size.width, self.size.height * 0.3);
   
    for (UITouch *touch in touches){
        CGPoint p = [touch locationInNode:self];
        if(CGRectContainsPoint(touchRegion, p)){
            self.motivatingTouch = touch;
        }
    }
    
    [self trackPaddlesToMotivatingTouch];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

 [self trackPaddlesToMotivatingTouch];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    if([touches containsObject:self.motivatingTouch]){
        self.motivatingTouch = nil;
    }
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    if([touches containsObject:self.motivatingTouch]){
        self.motivatingTouch = nil;
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)trackPaddlesToMotivatingTouch{
    SKNode *node = [self childNodeWithName:@"paddle"];
    UITouch *touch = self.motivatingTouch;
    if(!touch) return;
    CGFloat xPos = [touch locationInNode:self].x;
    NSTimeInterval duration = ABS(xPos - node.position.x) / KTrackPointsPerSecond;
    [node runAction:[SKAction moveToX:xPos duration:duration]];
}

@end
