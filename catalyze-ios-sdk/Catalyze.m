/*
 * Copyright (C) 2013 catalyze.io, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import "Catalyze.h"
#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityConsoleLogger.h"

@implementation Catalyze

+ (void)setApiKey:(NSString *)apiKey applicationId:(NSString *)appId {
    [Catalyze setApiKey:apiKey applicationId:appId baseUrl:kCatalyzeBaseUrl];
}

+ (void)setApiKey:(NSString *)apiKey applicationId:(NSString *)appId baseUrl:(NSString *)baseUrl {
    [[NSUserDefaults standardUserDefaults] setValue:apiKey forKey:kCatalyzeApiKeyKey];
    [[NSUserDefaults standardUserDefaults] setValue:appId forKey:kCatalyzeAppIdKey];
    [[NSUserDefaults standardUserDefaults] setValue:baseUrl forKey:kCatalyzeBaseUrlKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)apiKey {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:kCatalyzeApiKeyKey]) {
        NSLog(@"Warning! Application key not set! Please call [Catalyze setApiKey:applicationId:] in your AppDelegate's applicationDidFinishLaunchingWithOptions: method");
    }
    return [[NSUserDefaults standardUserDefaults] valueForKey:kCatalyzeApiKeyKey];
}

+ (NSString *)applicationId {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:kCatalyzeAppIdKey]) {
        NSLog(@"Warning! Application id not set! Please call [Catalyze setApiKey:applicationId:] in your AppDelegate's applicationDidFinishLaunchingWithOptions: method");
    }
    return [[NSUserDefaults standardUserDefaults] valueForKey:kCatalyzeAppIdKey];
}

+ (void)setLoggingLevel:(LoggingLevel)level {
    // Remove any current loggers
    id loggers = [[[AFNetworkActivityLogger sharedLogger] loggers] anyObject];
    [[AFNetworkActivityLogger sharedLogger] removeLogger:loggers];

    if (level == kLoggingLevelOff) {
        [[AFNetworkActivityLogger sharedLogger] stopLogging];
    } else {
        AFNetworkActivityConsoleLogger *logger = [AFNetworkActivityConsoleLogger new];
        
        switch (level) {
            case kLoggingLevelDebug:
                logger.level = AFLoggerLevelDebug;
                break;
            case kLoggingLevelInfo:
                logger.level = AFLoggerLevelInfo;
                break;
            case kLoggingLevelWarn:
                logger.level = AFLoggerLevelError;
                break;
            default:
                break;
        }
        [[AFNetworkActivityLogger sharedLogger] addLogger:logger];
        [[AFNetworkActivityLogger sharedLogger] startLogging];
    }
}

@end
