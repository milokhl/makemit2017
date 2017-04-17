//
//  startViewController.h
//  makemitBGcontroller
//
//  Created by Magnus Johnson on 4/15/17.
//  Copyright © 2017 MagMHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simulatorViewController.h"
#import "startViewController.h"
#import "receiverViewController.h"

@interface startViewController : UIViewController {
    simulatorViewController *sVC;
    receiverViewController *rVC;
    bool initialVCshown;
}

@end
