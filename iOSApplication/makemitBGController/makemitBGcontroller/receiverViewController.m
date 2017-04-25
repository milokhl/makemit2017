#import "receiverViewController.h"
#import "bluetoothManager.h"

@interface receiverViewController ()

@end

@implementation receiverViewController

- (IBAction)toggleController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToSVC" object:self];
}

- (IBAction)addToMotorAngle:(id)sender {
    testMotorAngle += 1;
    
    [currentMotorAngle setText:[NSString stringWithFormat:@"%i",testMotorAngle]];
}

- (IBAction)subtractFromMotorAngle:(id)sender {
    testMotorAngle -= 1;
    
    [currentMotorAngle setText:[NSString stringWithFormat:@"%i",testMotorAngle]];
}

- (IBAction)sendMotorAngle:(id)sender {
    [[bluetoothManager sharedBMan] sendBGValue:testMotorAngle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[bluetoothManager sharedBMan] testRVCInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
