#import "BGDataPoint.h"
#import "objectUniqueIDAssigner.h"

@implementation BGDataPoint

@synthesize dataPointColor = _dataPointColor;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)changeBGvalue:(float)value {
    self.BGvalue = value;
    
    [self setTintColor:[UIColor blackColor]];
    if (value >= 105 && value <= 130) {
        [self setTintColor:[UIColor colorWithRed:10.0/255.0 green:120.0/255.0 blue:70.0/255.0 alpha:1.0]];
    } else if (value < 70) {
        [self setTintColor:[UIColor colorWithRed:140.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0]];
    } else if (value > 245) {
        [self setTintColor:[UIColor colorWithRed:140.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0]];
    }
}

- (id)initWithImageModified:(UIImage *)img :(int)objectId :(UIColor *)objectColor :(float)BGvalue :(float)timeOfPoint {
    
    //setup variables
    self.objectId = objectId;
    self.alpha = 0.0;
    [self changeBGvalue:BGvalue];
    self.timeOfPoint = timeOfPoint;
    self.dataPointColor = objectColor;
    self.uniqueObjectId = [[objectUniqueIDAssigner sharedInstance] generateNewIDForObject];
    self.scale = 0.042;
    
    printf("NEW OBJECT w/ UUID: %i\n",self.uniqueObjectId);
    
    return [self initWithImage:img];
    //return self;
}

@end
