//
//  AppDelegate.m
//  worklog
//
//  Created by RichardNie on 2022/5/29.
//

#import "AppDelegate.h"
#import "DBHelper.h"
#import "common/CommonHeaders.h"
#import "NotedownTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    [DBHelper initDatabase];
    [DBHelper cleanWorkLogsBeforeDays:30];

    if (@available(iOS 13.0, *)) {
        // 在SceneDelegate里创建UIWindow
    }
    else {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        [self.window setRootViewController:[mainStoryboard instantiateInitialViewController]];
        [self.window makeKeyAndVisible];
    }
    
    //如果是通过3D Touch点击shortItem进入应用的话，那么UIApplicationLaunchOptionsShortcutItemKey一定返回相应的UIApplicationShortcutItem。
    UIApplicationShortcutItem *shortItem =[launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if (shortItem) {
        //如果从3D Touch点击item进行，那么返回false，不再触发-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler方法
        return NO;
    }
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [DBHelper closeDatabase];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    NSInteger nowInt = [NSDate dateToInteger:[NSDate date]];
    if (G_LAST_DATE < 0) {
        G_LAST_DATE = nowInt;
        G_NEED_RELOAD_DATA = NO;
    } else if (G_LAST_DATE != nowInt) {
        G_LAST_DATE = nowInt;
        G_NEED_RELOAD_DATA = YES;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    G_LAST_DATE = [NSDate dateToInteger:[NSDate date]];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark - Shortcut
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
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

#pragma mark - Exception
// 获取异常崩溃信息
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *errorMessage = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    NSLog(@"errorMessage = %@", errorMessage);
}

@end
