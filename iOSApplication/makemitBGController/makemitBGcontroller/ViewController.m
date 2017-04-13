#import "ViewController.h"
#import "BGDataPoint.h"

@interface ViewController ()

@end

@implementation ViewController

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
    printf("raise BG val\n");
    
    BGTargetOn = 0;
    
    currentBG += 10.0;
    if (currentBG >= 345) {
        [raiseBGButton setEnabled:NO];
    }
    [lowerBGButton setEnabled:YES];
    
    [currentBGLabel setText:[NSString stringWithFormat:@"%i",(int)currentBG]];
}

- (IBAction)lowerBGvalue:(id)sender {
    printf("lower BG val\n");
    
    BGTargetOn = 0;
    
    currentBG -= 10.0;
    if (currentBG <= 45) {
        [lowerBGButton setEnabled:NO];
    }
    [raiseBGButton setEnabled:YES];
    
    [currentBGLabel setText:[NSString stringWithFormat:@"%i",(int)currentBG]];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        //[btCManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"]] options:nil];
        [btCManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    printf("DISCOVERED: %s: %s - %i services\n",[peripheral.name UTF8String],[[peripheral.identifier UUIDString] UTF8String],(int)peripheral.services.count);
    if ([peripheral.name isEqualToString:@"Adafruit Bluefruit LE"] && [[peripheral.identifier UUIDString] isEqualToString:@"1A58BC43-D08C-4110-9BAD-A5349ABC0D45"]) {
        discoveredPeripheral = peripheral;
        [btCManager connectPeripheral:discoveredPeripheral options:nil];
        [btCManager stopScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    printf("Peripheral connected\n");
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        //NSLog(@"Discovered service %@", service);
        if ([[service.UUID UUIDString] isEqualToString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            printf("Found data service...\n");
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        //NSLog(@"Discovered characteristic %@", characteristic);
        if ([[characteristic.UUID UUIDString] isEqualToString:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            printf("Found write characteristic!\n");
            writeCharacteristic = characteristic;
        } else if ([[characteristic.UUID UUIDString] isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            printf("Found notify characteristic!\n");
            notifyCharacteristic = characteristic;
        }
    }
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if (peripheral.state != CBManagerStatePoweredOn) {
        return;
    }
    
    if (peripheral.state == CBManagerStatePoweredOn) {
        /*[btManager startAdvertising:nil];
        [btManager addService:mainDataService];*/
        printf("Peripheral advertising\n");
    }
}

/*- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    printf("CENTRAL SUBSCRIBED\n");
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    printf("STARTED ADVERTISING\n");
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    printf("READY TO UPDATE SUBSCRIBERS\n");
}*/

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
    if (refreshTimer <= 0) {
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
        pumpAmountToSend = currentBG;
        
        //bluetooth characteristics
        /*[btManager updateValue:[NSData dataWithBytes:&pumpActiveId length:sizeof(pumpActiveId)] forCharacteristic:pumpActive onSubscribedCentrals:nil];
        [btManager updateValue:[NSData dataWithBytes:&pumpAmountToSend length:sizeof(pumpAmountToSend)] forCharacteristic:pumpAmount onSubscribedCentrals:nil];*/
        
        if (discoveredPeripheral != nil && writeCharacteristic != nil) {
            int dataSent = (int)pumpAmountToSend;
            NSMutableData *dataToWrite = [NSMutableData dataWithCapacity:0];
            [dataToWrite appendBytes:&dataSent length:sizeof(int)];
            [discoveredPeripheral writeValue:dataToWrite forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            
            printf("UPDATE SENT: %i, %.1f\n",pumpActiveId,pumpAmountToSend);
        } else {
            printf("UPDATE NOT SENT: %i, %.1f\n",pumpActiveId,pumpAmountToSend);
        }
        
        [currentBGLabel setText:[NSString stringWithFormat:@"%i",(int)currentBG]];
    } else {
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
    
    screenCenterWidth = [UIScreen mainScreen].bounds.size.width/2;
    screenCenterHeight = [UIScreen mainScreen].bounds.size.height/2;
    
    dpArray = [[NSMutableArray alloc] init];
    dpArrayTransition = [[NSMutableArray alloc] init];
    
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
    
    //bluetooth - broadcasting services/characteristics, only if acting as peripheral
    /*btManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    pumpAmount = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:@"0C50D390-DC8E-436B-8AD0-A36D1B304B17"] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    pumpActive = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:@"0C50D390-DC8E-436B-8AD0-A36D1B304B18"] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    //[NSData dataWithBytes:&pumpActiveId length:sizeof(pumpActiveId)]
    mainDataService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:@"0C50D390-DC8E-436B-8AD0-A36D1B304B19"] primary:YES];
    [mainDataService setCharacteristics:[NSArray arrayWithObjects:pumpActive, pumpAmount, nil]];
    //[btManager startAdvertising:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:CBAdvertisementDataServiceUUIDsKey, nil] forKeys:[NSArray arrayWithObjects:mainDataService.UUID, nil]]];*/
    
    //bluetooth - connecting to services/peripherals, only if acting as central
    btCManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    //start regular timer
    [NSTimer scheduledTimerWithTimeInterval:1/60.0f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
