#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "BGDataPoint.h"

@interface simulatorViewController : UIViewController {
    int refreshTimer;
    int refreshTimerMax;
    float screenCenterWidth;
    float screenCenterHeight;
    
    NSMutableArray *dpArray;
    NSMutableArray *dpArrayRemoval;
    NSMutableArray *dpArrayTransition;
    NSMutableArray *dpArrayTransitionRemoval;
    
    IBOutlet UIImageView *BGreferenceAxis;
    IBOutlet UILabel *currentBGLabel;
    IBOutlet UILabel *currentTargetBGLabel;
    IBOutlet UIImageView *trendArrow;
    float trendArrowRotation;
    
    float currentBG;
    float currentRate; //-2 (fast lower) to 2 (fast rise)
    bool BGTargetOn;
    bool BGTargetOnRefresh;
    float currentTargetBG;
    
    IBOutlet UIButton *raiseBGButton;
    IBOutlet UIButton *lowerBGButton;
    IBOutlet UIButton *raiseTargetBGButton;
    IBOutlet UIButton *lowerTargetBGButton;
    
    int pumpActiveId;
    float pumpAmountToSend;
    bool simulationPaused;
    
}

- (IBAction)raiseBGvalue:(id)sender;
- (IBAction)lowerBGvalue:(id)sender;
- (IBAction)toggleController:(id)sender;

@end

