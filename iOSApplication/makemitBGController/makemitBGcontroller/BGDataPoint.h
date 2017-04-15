#import <UIKit/UIKit.h>

@interface BGDataPoint : UIImageView {
    UIColor *dataPointColor;
    int _objectId; //specifies type of object
    int _objectSubId; //set after initialization
    int _uniqueObjectId; //unique for every object
    float _posX;
    float _posY;
    float _scale;
    float _BGvalue;
    float _timeOfPoint;
    bool _beingDeleted;
}

@property (nonatomic, assign) UIColor* dataPointColor;
@property (nonatomic, assign) int objectId;
@property (nonatomic, assign) int objectSubId;
@property (nonatomic, assign) int uniqueObjectId;
@property (nonatomic, assign) float posX;
@property (nonatomic, assign) float posY;
@property (nonatomic, assign) float scale;
@property (nonatomic, assign) float BGvalue;
@property (nonatomic, assign) float timeOfPoint;
@property (nonatomic, assign) bool beingDeleted;

-(id)initWithImageModified:(UIImage *)img :(int)objectId :(UIColor*)objectColor :(float)BGvalue :(float)timeOfPoint;

-(void)changeBGvalue:(float)value;

@end
