//
//  SceneDelegate.m
//  worklog
//
//  Created by RichardNie on 2022/5/29.
//

#import "SceneDelegate.h"
#import "NotedownTableViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

//APP没有启动，点击shortcut item会打开APP，然后走这个代理
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)){
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // 在这里手动创建新的window
    if (@available(iOS 13.0, *))
    {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setWindowScene:windowScene];
        [self.window setBackgroundColor:[UIColor systemBackgroundColor]];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        [self.window setRootViewController:[mainStoryboard instantiateInitialViewController]];
        [self.window makeKeyAndVisible];
        
        [self dealwithShortcutItemType: connectionOptions.shortcutItem.type];
    }
    else
    {
        // 在AppDelegate里创建UIWindow
    }

}


- (void)sceneDidDisconnect:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    NSLog(@"sceneWillEnterForeground");
    NSInteger nowInt = [NSDate dateToInteger:[NSDate date]];
    if (G_LAST_DATE < 0) {
        G_LAST_DATE = nowInt;
        G_NEED_RELOAD_DATA = NO;
    } else if (G_LAST_DATE != nowInt) {
        G_LAST_DATE = nowInt;
        G_NEED_RELOAD_DATA = YES;
    }
}

- (void)sceneDidEnterBackground:(UIScene *)scene API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    NSLog(@"sceneDidEnterBackground");
    G_LAST_DATE = [NSDate dateToInteger:[NSDate date]];
}

//APP已启动，点击shortcut item会走这个代理
- (void)windowScene:(UIWindowScene *)windowScene performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler API_AVAILABLE(ios(13.0)){
    completionHandler([self dealwithShortcutItemType: shortcutItem.type]);
}

- (BOOL) dealwithShortcutItemType: (NSString *)shortcutItemType {
    if ([shortcutItemType isEqualToString:@"0"]) {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        NSLog(@"Shortcut Pressed.");
        return YES;
    }
    else
        return NO;
}

- (void) timerAction:(NSTimer *) timer{
    if (G_FLAG1) {
        G_FLAG1 = NO;
        [timer invalidate];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shortCut1Notification" object:nil];
    }
}

@end
