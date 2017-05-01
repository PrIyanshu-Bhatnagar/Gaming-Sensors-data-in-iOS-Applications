//
//  GameScene.m
//  PongDemo
//
//  Created by Priyanshu Bhatnagar on 07/08/16.
//  Copyright (c) 2016 Priyanshu Bhatnagar. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()

@property (strong,nonatomic) UITouch *leftPaddleMotivationTouch;
@property (strong,nonatomic) UITouch *rightPaddleMotivationTouch;

@end

@implementation GameScene

static const CGFloat kTrackPixelPerSecond = 1000;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKNode *ball = [self childNodeWithName:@"ball"];
    ball.physicsBody.angularVelocity = 1.0;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    //Where is the touch location
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInNode:self];
        NSLog(@"\n%f %f %f %f", p.x,p.y,self.frame.size.width,self.frame.size.height);
        
        if(p.x < self.frame.size.width *0.3){
            self.leftPaddleMotivationTouch = touch;
            (NSLog(@"left"));
        } else if(p.x > self.frame.size.width* 0.7){
            self.rightPaddleMotivationTouch = touch;
            NSLog(@"right");
        }
        else{
            SKNode *ball = [self childNodeWithName:@"ball"];
            ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx * 1.25,ball.physicsBody.velocity.dy);
        }
    }
     [self trackPaddlesToMotivationTouches];
}
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self trackPaddlesToMotivationTouches];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([touches containsObject:self.leftPaddleMotivationTouch]) self.leftPaddleMotivationTouch = nil;
    if([touches containsObject:self.rightPaddleMotivationTouch])self.rightPaddleMotivationTouch = nil;
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([touches containsObject:self.leftPaddleMotivationTouch]) self.leftPaddleMotivationTouch = nil;
    if([touches containsObject:self.rightPaddleMotivationTouch])self.rightPaddleMotivationTouch = nil;

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void) trackPaddlesToMotivationTouches{
  
    id a = @[@{@"node":[self childNodeWithName:@"left_paddle"],@"touch":self.leftPaddleMotivationTouch ?: [NSNull null]}
             ,@{@"node": [self childNodeWithName:@"right_paddle"], @"touch": self.rightPaddleMotivationTouch ?: [NSNull null]}];
    
    for(NSDictionary *o in a){
        SKNode *node = o[@"node"];
        UITouch *touch = o[@"touch"];
        
        if([[NSNull null] isEqual:touch]){
            continue;
        }
        
        CGFloat yPos = [touch locationInNode:self].y;
        NSTimeInterval duration = ABS(yPos - node.position.y) / kTrackPixelPerSecond;
        
        SKAction *moveAction = [SKAction moveToY:yPos duration:duration];
        [node runAction:moveAction withKey:@"@moving!"];
    }
}

@end
