//
//  objectUniqueIDAssigner.m
//  TapNote 2
//
//  Created by Magnus Johnson on 10/21/16.
//  Copyright © 2016 MagMHJ. All rights reserved.
//

#import "objectUniqueIDAssigner.h"

@implementation objectUniqueIDAssigner

- (int)generateNewIDForObject {
    maxIDUsed += 1;
    return maxIDUsed-1;
}

+ (id)sharedInstance {
    
    static objectUniqueIDAssigner *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[objectUniqueIDAssigner alloc] modifiedInit];
    });
    return sharedInstance;
}

- (id)modifiedInit {
    maxIDUsed = 1; //defines minimum uuid
    
    return [self init];
}

@end
