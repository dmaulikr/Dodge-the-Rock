//
//  SpriteViewController.m
//  SpriteWalkthrough
//
//  Created by Guilherme Castro on 17/03/14.
//  Copyright (c) 2014 Guilherme Castro. All rights reserved.
//

#import "SpriteViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HelloScene.h"
@import AVFoundation;
#import "GADBannerView.h"
#import "GADInterstitial.h"

@interface SpriteViewController ()

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@end

@implementation SpriteViewController{
    GADBannerView * bannerView_;
    GADInterstitial *interstitial_;
    GADRequest *request;
}

-(void)viewWillLayoutSubviews{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"device"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"device"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super viewWillLayoutSubviews];
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Go Cart - Loop Mix" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
    SKView *spriteView = (SKView *) self.view;
    
    SKScene *hello = [HelloScene sceneWithSize:spriteView.bounds.size];
    [spriteView presentScene: hello];
    
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"readyAD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAd)
                                                 name:@"readyAD"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeAD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hide)
                                                 name:@"removeAD"
                                               object:nil];


    request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for
    // the simulator as well as any devices you want to receive test ads.
    request.testDevices = @[ GAD_SIMULATOR_ID, @"16f0e4a2ce16596d6a60550eb85a2d56", @"0c3a3524f5f19b1d8941988e7fb4fd75" ];
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    
    [bannerView_ setDelegate:(id)self];
    
    bannerView_.adUnitID = @"ca-app-pub-9815486238219436/8408957706";
    bannerView_.rootViewController = self;
    bannerView_.center = CGPointMake(spriteView.bounds.size.width / 2, spriteView.bounds.size.height - (bannerView_.frame.size.height / 2));
    
    [self.view addSubview:bannerView_];
    [bannerView_ setHidden:YES];
}

-(void)showAd{
    [bannerView_ loadRequest:request];
    [bannerView_ setHidden:NO];
}

-(void)hide{
    [bannerView_ setHidden:YES];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

/*
// Check if the Facebook app is installed and we can present the share dialog
FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
params.link = [NSURL URLWithString:@"https://www.facebook.com/medereceitas"];
params.name = _recipe.recipeName;
params.caption = @"";
params.picture = [NSURL URLWithString:_recipe.linkImage];
params.description = @"Cozinhei esta receita utilizando o aplicativo Me Dê Receitas!";

// If the Facebook app is installed and we can present the share dialog
if ([FBDialogs canPresentShareDialogWithParams:params]) {
    // Present share dialog
    [FBDialogs presentShareDialogWithLink:params.link
                                     name:params.name
                                  caption:params.caption
                              description:params.description
                                  picture:params.picture
                              clientState:nil
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          // An error occurred, we need to handle the error
                                          // See: https://developers.facebook.com/docs/ios/errors
                                          NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                      } else {
                                          // Success
                                          NSLog(@"result %@", results);
                                      }
                                  }];    } else {
                                      NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                     _recipe.recipeName, @"name",
                                                                     @"", @"caption",
                                                                     @"Cozinhei esta receita utilizando o aplicativo Me Dê Receitas!", @"description",
                                                                     @"https://www.facebook.com/medereceitas", @"link",
                                                                     _recipe.linkImage, @"picture",
                                                                     nil];
                                      
                                      // Show the feed dialog
                                      [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                                             parameters:params
                                                                                handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                                                    if (error) {
                                                                                        // An error occurred, we need to handle the error
                                                                                        // See: https://developers.facebook.com/docs/ios/errors
                                                                                        NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                                                    } else {
                                                                                        if (result == FBWebDialogResultDialogNotCompleted) {
                                                                                            // User cancelled.
                                                                                            NSLog(@"User cancelled.");
                                                                                        } else {
                                                                                            // Handle the publish feed callback
                                                                                            NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                                            
                                                                                            if (![urlParams valueForKey:@"post_id"]) {
                                                                                                // User cancelled.
                                                                                                NSLog(@"User cancelled.");
                                                                                                
                                                                                            } else {
                                                                                                // User clicked the Share button
                                                                                                NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                                                NSLog(@"result %@", result);
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }];    }



}




//// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
*/

@end
