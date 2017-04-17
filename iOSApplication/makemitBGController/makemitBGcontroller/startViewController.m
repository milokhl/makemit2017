#import "startViewController.h"
#import "bluetoothManager.h"

@interface startViewController ()

@end

@implementation startViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:nil object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if (initialVCshown == false) {
        initialVCshown = true;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        sVC = (simulatorViewController *)[storyboard instantiateViewControllerWithIdentifier:@"simulatorController"];
        rVC = (receiverViewController *)[storyboard instantiateViewControllerWithIdentifier:@"receiverController"];
        [self presentViewController:sVC animated:NO completion:nil];
    }
}

- (void)receiveNotification:(NSNotification *) notification {
    //printf("NOTIFICATION TYPE: %s\n",[[notification name] UTF8String]);
    
    NSString *inputType = [notification name];
    if ([inputType isEqualToString:@"goToSVC"]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:sVC animated:NO completion:nil];
    } else if ([inputType isEqualToString:@"goToRVC"]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:rVC animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
