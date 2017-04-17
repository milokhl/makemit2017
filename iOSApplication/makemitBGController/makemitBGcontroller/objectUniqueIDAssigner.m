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
