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

#import "CatalyzeQuery.h"
#import "CatalyzeUser.h"
#import "CatalyzeHTTPManager.h"

@implementation CatalyzeQuery
@synthesize catalyzeClassName = _catalyzeClassName;
@synthesize pageNumber = _pageNumber;
@synthesize pageSize = _pageSize;
@synthesize queryValue = _queryValue;
@synthesize queryField = _queryField;

+ (CatalyzeQuery *)queryWithClassName:(NSString *)className {
    return [[CatalyzeQuery alloc] initWithClassName:className];
}

- (id)initWithClassName:(NSString *)newClassName {
    self = [super init];
    if (self) {
        _catalyzeClassName = newClassName;
        self.httpManager = [[CatalyzeHTTPManager alloc] init];
    }
    return self;
}

- (id)init {
    self = [self initWithClassName:@"object"];
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    @try {
        [super setValue:value forKey:key];
    } @catch (NSException *e) {}
}

#pragma mark -
#pragma mark Retrieve

- (void)retrieveAllEntriesInBackgroundWithBlock:(CatalyzeArrayResultBlock)block {
    [CatalyzeHTTPManager doGet:[NSString stringWithFormat:@"/classes/%@/query?pageSize=%i&pageNumber=%i%@%@",[CatalyzeHTTPManager percentEncode:[self catalyzeClassName]], _pageSize, _pageNumber, [self constructQueryFieldParam], [self constructQueryValueParam]] block:^(int status, NSString *response, NSError *error) {
        if (block) {
            NSLog(@"response: %@", response);
            block([NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil], error);
        }
    }];
}

- (void)retrieveAllEntriesInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self retrieveAllEntriesInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:objects waitUntilDone:NO];
    }];
}

- (void)retrieveInBackgroundWithBlock:(CatalyzeArrayResultBlock)block {
    [self retrieveInBackgroundForUsersId:[[CatalyzeUser currentUser] usersId] block:block];
}

- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self retrieveInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:objects waitUntilDone:NO];
    }];
}

- (void)retrieveInBackgroundForUsersId:(NSString *)usersId block:(CatalyzeArrayResultBlock)block {
    [CatalyzeHTTPManager doGet:[NSString stringWithFormat:@"/classes/%@/query/%@?pageSize=%i&pageNumber=%i%@%@",[CatalyzeHTTPManager percentEncode:[self catalyzeClassName]], usersId, _pageSize, _pageNumber, [self constructQueryFieldParam], [self constructQueryValueParam]] block:^(int status, NSString *response, NSError *error) {
        if (block) {
            NSLog(@"response: %@", response);
            block([NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil], error);
        }
    }];
}

- (void)retrieveInBackgroundForUsersId:(NSString *)usersId target:(id)target selector:(SEL)selector {
    [self retrieveInBackgroundForUsersId:usersId block:^(NSArray *objects, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:objects waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Helpers

- (NSString *)constructQueryFieldParam {
    NSString *queryFieldParam = @"";
    if (_queryField) {
        if (![_queryField isKindOfClass:[NSString class]] || ([_queryField isKindOfClass:[NSString class]] && ![_queryField isEqualToString:@""])) {
            queryFieldParam = [NSString stringWithFormat:@"&field=%@", [CatalyzeHTTPManager percentEncode:_queryField]];
        }
    }
    return queryFieldParam;
}

- (NSString *)constructQueryValueParam {
    NSString *queryValueParam = @"";
    if (_queryValue) {
        if (![_queryValue isKindOfClass:[NSString class]] || ([_queryValue isKindOfClass:[NSString class]] && ![_queryValue isEqualToString:@""])) {
            queryValueParam = [NSString stringWithFormat:@"&searchBy=%@", [CatalyzeHTTPManager percentEncode:_queryValue]];
        }
    }
    return queryValueParam;
}

@end
