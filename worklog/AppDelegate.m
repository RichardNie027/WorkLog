//
//  AppDelegate.m
//  worklog
//
//  Created by RichardNie on 2022/5/29.
//

#import "AppDelegate.h"
#import "DBHelper.h"
#import "common/CommonHeaders.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    [DBHelper initDatabase];
    [DBHelper cleanWorkLogsBeforeDays:30];
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

// 获取异常崩溃信息
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *errorMessage = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    NSLog(@"errorMessage = %@", errorMessage);
}

@end
