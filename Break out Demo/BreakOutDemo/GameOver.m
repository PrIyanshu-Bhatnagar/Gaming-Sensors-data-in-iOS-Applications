//
//  GameOver.m
//  BreakOutDemo
//
//  Created by Priyanshu Bhatnagar on 14/08/16.
//  Copyright © 2016 Priyanshu Bhatnagar. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"

@implementation GameOver

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(touches){
        
        SKView *skView = (SKView *)self.view;
        
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        [skView presentScene:scene];
        
    }
    
}

@end
