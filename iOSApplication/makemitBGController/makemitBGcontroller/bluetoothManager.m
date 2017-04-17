#import "bluetoothManager.h"

@implementation bluetoothManager

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

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [btCManager scanForPeripheralsWithServices:nil options:nil];
    discoveredPeripheral = nil;
    writeCharacteristic = nil;
    notifyCharacteristic = nil;
    printf("peripheral disconnected, rescanning...");
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [btCManager scanForPeripheralsWithServices:nil options:nil];
    discoveredPeripheral = nil;
    writeCharacteristic = nil;
    notifyCharacteristic = nil;
    printf("peripheral failed to connect, rescanning...");
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

- (void)sendBGValue:(int)BGValue {
    if (discoveredPeripheral != nil && writeCharacteristic != nil) {
        int dataSent = (int)BGValue;
        NSMutableData *dataToWrite = [NSMutableData dataWithCapacity:0];
        [dataToWrite appendBytes:&dataSent length:sizeof(int)];
        [discoveredPeripheral writeValue:dataToWrite forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        
        printf("UPDATE SENT: %i\n",BGValue);
    } else {
        printf("UPDATE NOT SENT: %i\n",BGValue);
    }
}

- (void)testRVCInit {
    printf("test RVC init\n");
}

+ (bluetoothManager *)sharedBMan {
    static bluetoothManager *sharedBMan;
    
    @synchronized(self) {
        if (!sharedBMan) {
            sharedBMan = [[bluetoothManager alloc] init];
        }
        
        return sharedBMan;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
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
    }
    return self;
}

@end
