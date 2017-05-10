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
    float currentTargetBG; //simulator convergence bg target, NOT bg value user wants to be kept at
    
    IBOutlet UIButton *raiseBGButton;
    IBOutlet UIButton *lowerBGButton;
    IBOutlet UIButton *raiseTargetBGButton;
    IBOutlet UIButton *lowerTargetBGButton;
    
    float targetBGValue; //bg value user wants to be kept at
    float insulinSensitivityRatio; //ratio of insulin units/bg units to determine insulin dosage
    
    int numberOfTimestepsMonitored;
    NSMutableArray *pumpAmountsSentTimeline;
    
    int pumpActiveId;
    float pumpAmountToSend; //negative values = insulin, positive values = glycogen
    bool simulationPaused;
    
}

- (IBAction)raiseBGvalue:(id)sender;
- (IBAction)lowerBGvalue:(id)sender;
- (IBAction)toggleController:(id)sender;

@end

