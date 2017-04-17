#import "receiverViewController.h"
#import "bluetoothManager.h"

@interface receiverViewController ()

@end

@implementation receiverViewController

- (IBAction)toggleController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToSVC" object:self];
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
