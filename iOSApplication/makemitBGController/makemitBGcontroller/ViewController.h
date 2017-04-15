#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "BGDataPoint.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate> {
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
    
    CBCentralManager *btCManager;
    CBPeripheral *discoveredPeripheral;
    CBCharacteristic *writeCharacteristic;
    CBCharacteristic *notifyCharacteristic;
    
    /*CBPeripheralManager *btManager;
    CBMutableService *mainDataService;
    CBMutableCharacteristic *pumpActive;
    CBMutableCharacteristic *pumpAmount;*/
    
    int pumpActiveId;
    float pumpAmountToSend;
    
}

- (IBAction)raiseBGvalue:(id)sender;
- (IBAction)lowerBGvalue:(id)sender;

@end

