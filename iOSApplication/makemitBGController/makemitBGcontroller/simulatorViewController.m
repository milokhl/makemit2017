#import "simulatorViewController.h"
#import "bluetoothManager.h"
#import "BGDataPoint.h"

@interface simulatorViewController ()

@end

@implementation simulatorViewController

- (IBAction)toggleController:(id)sender {
    simulationPaused = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToRVC" object:self];
}

- (IBAction)raiseTargetBG:(id)sender {
    BGTargetOn = 1;
    
    currentTargetBG += 10.0;
    if (currentTargetBG >= 345) {
        [raiseTargetBGButton setEnabled:NO];
    }
    [lowerTargetBGButton setEnabled:YES];
    
    [currentTargetBGLabel setText:[NSString stringWithFormat:@"%i",(int)currentTargetBG]];
}

- (IBAction)lowerTargetBG:(id)sender {
    BGTargetOn = 1;
    
    currentTargetBG -= 10.0;
    if (currentTargetBG <= 45) {
        [lowerTargetBGButton setEnabled:NO];
    }
    [raiseTargetBGButton setEnabled:YES];
    
    [currentTargetBGLabel setText:[NSString stringWithFormat:@"%i",(int)currentTargetBG]];
}

- (IBAction)raiseBGvalue:(id)sender {
    BGTargetOn = 0;
    
    currentBG += 10.0;
    if (currentBG >= 345) {
        [raiseBGButton setEnabled:NO];
    }
    [lowerBGButton setEnabled:YES];
    
    [currentBGLabel setText:[NSString stringWithFormat:@"%i",(int)currentBG]];
}

- (IBAction)lowerBGvalue:(id)sender {
    BGTargetOn = 0;
    
    currentBG -= 10.0;
    if (currentBG <= 45) {
        [lowerBGButton setEnabled:NO];
    }
    [raiseBGButton setEnabled:YES];
    
    [currentBGLabel setText:[NSString stringWithFormat:@"%i",(int)currentBG]];
}

- (void)update:(NSTimer *)timer {
    
    dpArrayTransitionRemoval = [[NSMutableArray alloc] init];
    dpArrayRemoval = [[NSMutableArray alloc] init];
    
    //BG target mode management
    if (BGTargetOn != BGTargetOnRefresh) {
        BGTargetOnRefresh = BGTargetOn;
        
        if (BGTargetOn == 0) {
            trendArrow.alpha = 1.0;
            currentTargetBGLabel.alpha = 0.5;
        } else {
            trendArrow.alpha = 0.5;
            currentTargetBGLabel.alpha = 1.0;
        }
    }
    
    //refresh timer
    if (refreshTimer <= 0 && simulationPaused == 0) {
        refreshTimer = refreshTimerMax;
        
        //updating next rounds values
        if (BGTargetOn == 0) {
            currentBG += (float)currentRate*12.0;
            currentRate = currentRate + ((0 - currentRate)/2.25);
        } else {
            currentBG += (currentTargetBG - currentBG)/2.25;
        }
        
        //advancing data points
        for (BGDataPoint *currentDP in dpArray) {
            if (currentDP.timeOfPoint < 1.985) {
                currentDP.timeOfPoint += 1.0/6.0;
            } else if (currentDP.timeOfPoint >= 1.985) {
                currentDP.beingDeleted = 1;
            }
        }
        
        //new data point
        BGDataPoint *dataPoint1 = [[BGDataPoint alloc] initWithImageModified:[[UIImage imageNamed:@"datapoint.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] :1 :[UIColor blackColor] :currentBG :0];
        [dataPoint1 setFrame:CGRectMake(0, 0, dataPoint1.frame.size.width*dataPoint1.scale, dataPoint1.frame.size.height*dataPoint1.scale)]; //only significant for frame size/scale
        float posXtarget = BGreferenceAxis.center.x+(screenCenterWidth*0.88);
        float posYtarget = BGreferenceAxis.center.y+34+((120-currentBG)*0.5);
        [dataPoint1 setCenter:CGPointMake(posXtarget, posYtarget)];
        dataPoint1.posX = dataPoint1.center.x;
        dataPoint1.posY = dataPoint1.center.y;
        [dpArrayTransition addObject:dataPoint1];
        
        //algorithm for pump to use & amount to push
        pumpAmountToSend = ((targetBGValue-currentBG)/insulinSensitivityRatio);
        /*for (int i = 0; i < numberOfTimestepsMonitored; i++) {
            float decayFactor = 0.2; //0.6*((1.0-(float)i/((float)numberOfTimestepsMonitored-0.5)));
            pumpAmountToSend -= decayFactor*fabsf([[pumpAmountsSentTimeline objectAtIndex:i] floatValue]);
        }*/
        [[bluetoothManager sharedBMan] sendBGValue:(int)(pumpAmountToSend*100.0)];
        
        printf("pats: %f\n",pumpAmountToSend);
        
        //saves sent amount to timeline to be used in future amount calculations
        for (int i = 0; i < numberOfTimestepsMonitored; i++) {
            int indexBeingChanged = (int)pumpAmountsSentTimeline.count-1-i;
            if (indexBeingChanged > 0) {
                [pumpAmountsSentTimeline setObject:[pumpAmountsSentTimeline objectAtIndex:indexBeingChanged-1] atIndexedSubscript:indexBeingChanged];
            } else { //adds new value
                [pumpAmountsSentTimeline setObject:[NSNumber numberWithFloat:pumpAmountToSend] atIndexedSubscript:0];
            }
        }
        
        [currentBGLabel setText:[NSString stringWithFormat:@"%i",(int)currentBG]];
    } else if (simulationPaused == 0) {
        refreshTimer--;
    }
    
    //trend arrow
    trendArrowRotation = trendArrowRotation + ((((((float)currentRate-2.5)/5.0)*M_PI) - trendArrowRotation)/5.0);
    trendArrow.transform = CGAffineTransformMakeRotation(-trendArrowRotation);
    
    //transition objects
    for (BGDataPoint *tObject in dpArrayTransition) {
        [dpArray addObject:tObject];
        [self.view addSubview:tObject];
        [dpArrayTransitionRemoval addObject:tObject];
    }
    for (BGDataPoint *tObject in dpArrayTransitionRemoval) {
        [dpArrayTransition removeObject:tObject];
    }
    
    //data points
    for (BGDataPoint *currentDP in dpArray) {
        
        //being deleted
        if (currentDP.beingDeleted == YES) {
            currentDP.alpha = currentDP.alpha + ((0 - currentDP.alpha)/6.0);
            if (currentDP.alpha < 0.05) { //actually delete currentDP
                [dpArrayRemoval addObject:currentDP];
            }
        } else {
            currentDP.alpha = currentDP.alpha + ((1.0 - currentDP.alpha)/6.0);
        }
        
        //position update
        float posXtarget = BGreferenceAxis.center.x+(screenCenterWidth*0.88*(1.0-currentDP.timeOfPoint));
        float posYtarget = BGreferenceAxis.center.y+34+((120-currentDP.BGvalue)*0.5);
        currentDP.posX = currentDP.posX+((posXtarget - currentDP.posX)/10.0);
        currentDP.posY = currentDP.posY+((posYtarget - currentDP.posY)/10.0);
        
        currentDP.center = CGPointMake(currentDP.posX, currentDP.posY);
    }
    for (BGDataPoint __strong*dpObject in dpArrayRemoval) {
        [dpObject removeFromSuperview];
        [dpArray removeObject:dpObject];
        dpObject = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //refreshTimerMax = 600;
    refreshTimerMax = 60;
    refreshTimer = refreshTimerMax;
    
    currentBG = 125;
    currentTargetBG = 125;
    currentRate = 2;
    
    targetBGValue = 125;
    insulinSensitivityRatio = 35; //currently optimized for me, Magnus Johnson
    
    screenCenterWidth = [UIScreen mainScreen].bounds.size.width/2;
    screenCenterHeight = [UIScreen mainScreen].bounds.size.height/2;
    
    dpArray = [[NSMutableArray alloc] init];
    dpArrayTransition = [[NSMutableArray alloc] init];
    
    numberOfTimestepsMonitored = 2;
    pumpAmountsSentTimeline = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < numberOfTimestepsMonitored; i++) {
        [pumpAmountsSentTimeline addObject:[NSNumber numberWithFloat:0.0]];
    }
    
    //initial dataPoints
    for (int int1 = 0; int1 <= 12; int1++) {
        float BGvalue = (310*((float)int1/11.0))+40;
        
        BGDataPoint *dataPoint1 = [[BGDataPoint alloc] initWithImageModified:[[UIImage imageNamed:@"datapoint.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] :1 :[UIColor blackColor] :BGvalue :(float)int1/6.0];
        [dataPoint1 setFrame:CGRectMake(0, 0, dataPoint1.frame.size.width*dataPoint1.scale, dataPoint1.frame.size.height*dataPoint1.scale)]; //only significant for frame size/scale
        [dataPoint1 setCenter:CGPointMake(BGreferenceAxis.center.x, BGreferenceAxis.center.y)];
        dataPoint1.posX = dataPoint1.center.x;
        dataPoint1.posY = dataPoint1.center.y;
        [dpArray addObject:dataPoint1];
        [self.view addSubview:dataPoint1];
    }
    
    pumpActiveId = 1;
    
    //start regular timer
    //[NSTimer scheduledTimerWithTimeInterval:1/60.0f target:self selector:@selector(update:) userInfo:nil repeats:YES];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewDidAppear:(BOOL)animated {
    simulationPaused = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
