//
//  bluetoothManager.h
//  makemitBGcontroller
//
//  Created by Magnus Johnson on 4/16/17.
//  Copyright © 2017 MagMHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface bluetoothManager : NSObject <CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate> {
    CBCentralManager *btCManager;
    CBPeripheral *discoveredPeripheral;
    CBCharacteristic *writeCharacteristic;
    CBCharacteristic *notifyCharacteristic;
    
    /*CBPeripheralManager *btManager;
     CBMutableService *mainDataService;
     CBMutableCharacteristic *pumpActive;
     CBMutableCharacteristic *pumpAmount;*/
    
}

- (void)sendBGValue:(int)BGValue;
- (void)testRVCInit;

+ (bluetoothManager *)sharedBMan;

@end
