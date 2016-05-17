/*
 * Copyright (c) 2015, Nordic Semiconductor
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DFUViewController.h"
#import "ScannerViewController.h"

#import "Constants.h"
#import "HelpViewController.h"
#import "FileTypeTableViewController.h"
#import "SSZipArchive.h"
#import "UnzipFirmware.h"
#import "Utility.h"
//#import "JsonParser.h"
#import "DFUHelper.h"
#include "DFUHelper.h"
#import "SmaTabBarViewController.h"

@interface DFUViewController () {
    NSString *imagePath;
    SmaTabBarViewController *smaTabVc;
    BOOL updSuccess;
    NSTimer *tioutTimer;
    int i;
}

/*!
 * This property is set when the device has been selected on the Scanner View Controller.
 */
@property (strong, nonatomic) CBPeripheral *selectedPeripheral;
@property (strong, nonatomic) DFUHelper *dfuHelper;

@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *firmware;
@property (weak, nonatomic) IBOutlet UILabel *deviceUpdate;
@property (weak, nonatomic) IBOutlet UILabel *fileSize;

@property (weak, nonatomic) IBOutlet UILabel *uploadStatus;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectFileButton;
@property (weak, nonatomic) IBOutlet UIView *uploadPane;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIButton *canBut;
@property (weak, nonatomic) IBOutlet UILabel *fileType;
@property (weak, nonatomic) IBOutlet UIButton *selectFileTypeButton;

@property BOOL isTransferring;
@property BOOL isTransfered;
@property BOOL isTransferCancelled;
@property BOOL isConnected;
@property BOOL isErrorKnown;

- (IBAction)uploadPressed;

@end

@implementation DFUViewController

@synthesize backgroundImage;
@synthesize deviceName;
@synthesize connectButton;
@synthesize selectedPeripheral;
@synthesize dfuOperations;
@synthesize fileName;
@synthesize fileSize;
@synthesize uploadStatus;
@synthesize progress;
@synthesize progressLabel;
@synthesize selectFileButton;
@synthesize uploadButton;
@synthesize uploadPane;
@synthesize fileType;
@synthesize selectedFileType;
@synthesize selectFileTypeButton;
@synthesize bindName;
@synthesize canBut;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        PACKETS_NOTIFICATION_INTERVAL = [[[NSUserDefaults standardUserDefaults] valueForKey:@"dfu_number_of_packets"] intValue];
        NSLog(@"PACKETS_NOTIFICATION_INTERVAL %d",PACKETS_NOTIFICATION_INTERVAL);
        dfuOperations = [[DFUOperations alloc] initWithDelegate:self];
        self.dfuHelper = [[DFUHelper alloc] initWithData:dfuOperations];
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationItem setHidesBackButton:YES];
    i = 0;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OTAnotification) name:@"OTAnotification" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OTAnotPeripheral) name:@"OTAnotPeripheral" object:nil];
    self.selectFileButton.hidden=YES;
    self.selectFileTypeButton.hidden=YES;
    canBut.hidden = YES;
    canBut.enabled = NO;
    deviceName.text = @"DFU";
    self.fileName.text=SmaLocalizedString(@"ota_name");
    self.fileSize.text=SmaLocalizedString(@"ota_size");
    self.fileType.text=SmaLocalizedString(@"ota_type");
    self.name.text = SmaLocalizedString(@"ota_Tname");
    self.size.text = SmaLocalizedString(@"ota_Tsize");
    self.type.text = SmaLocalizedString(@"ota_Ttype");
    self.deviceUpdate.text = SmaLocalizedString(@"ota_device_update");
    self.firmware.text = SmaLocalizedString(@"ota_firm");
     [uploadButton setTitle:SmaLocalizedString(@"ota_upload") forState:UIControlStateNormal];
    if (is4InchesIPhone)
    {
        // 4 inches iPhone
        UIImage *image = [UIImage imageNamed:@"Background4.png"];
        [backgroundImage setImage:image];
    }
    else
    {
        // 3.5 inches iPhone
        UIImage *image = [UIImage imageNamed:@"Background35.png"];
        [backgroundImage setImage:image];
    }
    
    // Rotate the vertical label
    self.verticalLabel.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(-145.0f, 0.0f), (float)(-M_PI / 2));
    NSLog(@"nsstringpath =%@",bindName);
    NSURL *url=[[NSURL alloc]initWithString:self.bindName];
    [self onFileSelected:url];
    

    selectedFileType = @"application";
    NSLog(@"unwindFileTypeSelector, selected Filetype: %@",selectedFileType);
    fileType.text =SmaLocalizedString(@"ota_update");
    [self.dfuHelper setFirmwareType:selectedFileType];
    [self enableUploadButton];
   tioutTimer = [NSTimer scheduledTimerWithTimeInterval:62 target:self selector:@selector(OTAtimeout) userInfo:nil repeats:NO];
 //注意事项
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=-20;
    }

    UILabel *attentionLab = [[UILabel alloc] init];
    
    attentionLab.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
       attentionLab.numberOfLines = -1;
    attentionLab.text = SmaLocalizedString(@"ota_attention");
    CGSize attenSize = [attentionLab.text sizeWithAttributes:@{NSFontAttributeName:attentionLab.font}];
    attentionLab.frame = CGRectMake(self.uploadPane.frame.origin.x, self.uploadPane.frame.origin.y + self.uploadPane.frame.size.height +5+statusBarHeight, attenSize.width, attenSize.height);
    [attentionLab sizeToFit];
 
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    [self.view addSubview:attentionLab];
    
    UILabel *contentLab = [[UILabel alloc] init];
    
    contentLab.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
         contentLab.numberOfLines = -1;
    contentLab.text = SmaLocalizedString(@"ota_atten_content");
    CGSize contenSize = [contentLab.text sizeWithAttributes:@{NSFontAttributeName:contentLab.font}];
    contentLab.frame = CGRectMake(attentionLab.frame.origin.x+attentionLab.frame.size.width+3, self.uploadPane.frame.origin.y + self.uploadPane.frame.size.height +6+statusBarHeight, self.uploadPane.frame.size.width-attentionLab.frame.size.width, contenSize.height);

    [contentLab sizeToFit];
//    [self.view addSubview:contentLab];
    
    UILabel *instrucLab = [[UILabel alloc] init];
    
    instrucLab.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    instrucLab.numberOfLines = -1;
    instrucLab.text = SmaLocalizedString(@"ota_Instructions");
    CGSize instrucSize = [instrucLab.text sizeWithAttributes:@{NSFontAttributeName:instrucLab.font}];
    instrucLab.frame = CGRectMake(attentionLab.frame.origin.x,  self.uploadPane.frame.origin.y + self.uploadPane.frame.size.height +6+statusBarHeight,self.uploadPane.frame.size.width, instrucSize.height);
    [instrucLab sizeToFit];
    [self.view addSubview:instrucLab];
    
    UITextView *stepText = [[UITextView alloc] initWithFrame:CGRectMake(attentionLab.frame.origin.x, instrucLab.frame.origin.y+instrucLab.frame.size.height, self.uploadPane.frame.size.width, 175)];
    stepText.text =  SmaLocalizedString(@"ota_steps");
    stepText.editable = NO;
    stepText.selectable = NO;
    [self.view addSubview:stepText];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSLog(@"unwindFileTypeSelector, selected FiletypeSmaBleMgr.peripheral.state: %ld",(long)SmaBleMgr.peripheral.state);
       NSArray *SystemArr = [SmaBleMgr.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"]]];
   
        
//        [SmaBleMgr connectPeripheral:SmaBleMgr.peripheral Bool:YES];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            MyLog(@"开始进入OTA模式1111___________ %llu",DISPATCH_TIME_NOW);
//            if(SmaBleMgr.peripheral.state==CBPeripheralStateConnected)
//            {
//                if (SmaBleMgr.peripheral.state == CBPeripheralStateConnecting) {
//                    [SmaBleMgr.mgr cancelPeripheralConnection:SmaBleMgr.peripheral];
//                }
//                selectedPeripheral = SmaBleMgr.peripheral;
//                [dfuOperations setCentralManager:SmaBleMgr.mgr];
//                deviceName.text = SmaBleMgr.peripheral.name;
//                [dfuOperations connectDevice:SmaBleMgr.peripheral];
//                //        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(connetcSystemPer) userInfo:nil repeats:YES];
//            }
//            
//        });
//
           });
//    }
}

- (void)OTAtimeout{
    if (tioutTimer && tioutTimer.isValid) {
        [tioutTimer invalidate];
        tioutTimer = nil;
    }
    SmaBleMgr.OTA = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)OTAnotification{
    NSLog(@"接收通知搜索设备");
    canBut.enabled = YES;
//     [SmaBleMgr oneScanBand:YES];
}
- (void)OTAnotPeripheral{
    NSLog(@"接收通知连接设备");
    if(SmaBleMgr.peripheral.state==CBPeripheralStateConnected)
    {
        if (SmaBleMgr.peripheral.state == CBPeripheralStateConnecting) {
            [SmaBleMgr.mgr cancelPeripheralConnection:SmaBleMgr.peripheral];
        }
        if (tioutTimer && tioutTimer.isValid) {
            [tioutTimer invalidate];
            tioutTimer = nil;
        }
        selectedPeripheral = SmaBleMgr.peripheral;
        [dfuOperations setCentralManager:SmaBleMgr.mgr];
        deviceName.text = SmaBleMgr.peripheral.name;
        [dfuOperations connectDevice:SmaBleMgr.peripheral];
    }

}
- (void)connetcSystemPer{
    if (selectedPeripheral.state !=CBPeripheralStateConnected && selectedPeripheral) {
        [dfuOperations connectDevice:SmaBleMgr.peripheral];
    }

}

-(void)viewWillDisappear:(BOOL)animated{

//    SmaBleMgr.OTA = NO;
//    if (!smaTabVc) {
//        smaTabVc = [[SmaTabBarViewController alloc]init];
//    }
//     [smaTabVc.btStateMonitorTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    if (!updSuccess) {
        SmaUserInfo *info = [SmaAccountTool userInfo];
        info.watchName = info.OTAwatchName;
        [SmaAccountTool saveUser:info];
    }
    
//    if ([self isMovingFromParentViewController] && self.isConnected) {
//        [dfuOperations cancelDFU];
//    }
    [super viewDidDisappear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//11111111111111
-(void)uploadPressed
{
    if (self.isTransferring) {
        [dfuOperations cancelDFU];
    }
    else {
        [self performDFU];
    }
}

-(void)performDFU
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self disableOtherButtons];
        uploadStatus.hidden = NO;
        progress.hidden = NO;
        progressLabel.hidden = NO;
        uploadButton.enabled = NO;
    });
    [self.dfuHelper checkAndPerformDFU];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // The 'scan' or 'select' seque will be performed only if DFU process has not been started or was completed.
    //return !self.isTransferring;
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scan"])
    {
        // Set this contoller as scanner delegate
        ScannerViewController *controller = (ScannerViewController *)segue.destinationViewController;
        // controller.filterUUID = dfuServiceUUID; - the DFU service should not be advertised. We have to scan for any device hoping it supports DFU.
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"FileSegue"])
    {
        NSLog(@"performing Select File segue");
        UITabBarController *barController = segue.destinationViewController;
        NSLog(@"BarController %@",barController);
        UINavigationController *navController = [barController.viewControllers firstObject];
        NSLog(@"NavigationController %@",navController);
        AppFilesTableViewController *appFilesVC = (AppFilesTableViewController *)navController.topViewController;
        NSLog(@"AppFilesTableVC %@",appFilesVC);
        appFilesVC.fileDelegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"help"]) {
        HelpViewController *helpVC = [segue destinationViewController];
        helpVC.helpText = [Utility getDFUHelpText];
        helpVC.isDFUViewController = YES;
    }
    else if ([segue.identifier isEqualToString:@"FileTypeSegue"]) {
        NSLog(@"performing FileTypeSegue");
        FileTypeTableViewController *fileTypeVC = [segue destinationViewController];
        fileTypeVC.chosenFirmwareType = selectedFileType;
    }
}

- (void) clearUI
{
    selectedPeripheral = nil;
    deviceName.text = @"DFU";
    uploadStatus.text = SmaLocalizedString(@"ota_wait");
    uploadStatus.hidden = YES;
    progress.progress = 0.0f;
    progress.hidden = YES;
    progressLabel.hidden = YES;
    progressLabel.text = @"";
    [uploadButton setTitle:SmaLocalizedString(@"ota_upload") forState:UIControlStateNormal];
    uploadButton.enabled = NO;
    [self enableOtherButtons];
}

-(void)enableUploadButton
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (selectedFileType && self.dfuHelper.selectedFileSize > 0) {
            if ([self.dfuHelper isValidFileSelected]) {
                NSLog(@" valid file selected");
            }
            else {
                NSLog(@"Valid file not available in zip file");
                [Utility showAlert:[self.dfuHelper getFileValidationMessage]];
                return;
            }
        }
        if (self.dfuHelper.isDfuVersionExist) {
            if (selectedPeripheral && selectedFileType && self.dfuHelper.selectedFileSize > 0 && self.isConnected && self.dfuHelper.dfuVersion > 1) {
                if ([self.dfuHelper isInitPacketFileExist]) {
                    uploadButton.enabled = YES;
                    if (i == 0) {
                        [self performDFU];
                        i ++;
                    }

//                    [self uploadPressed];
                }
                else {
                    [Utility showAlert:[self.dfuHelper getInitPacketFileValidationMessage]];
                }
            }
            else {
                NSLog(@"cant enable Upload button");
            }
        }
        else {
            if (selectedPeripheral && selectedFileType && self.dfuHelper.selectedFileSize > 0 && self.isConnected) {
                uploadButton.enabled = YES;
//                [self uploadPressed];
                if (i == 0) {
                    [self performDFU];
                    i ++;
                }
                
            }
            else {
                NSLog(@"cant enable Upload button");
            }
        }
        
    });
}

-(void)disableOtherButtons
{
    selectFileButton.enabled = NO;
    selectFileTypeButton.enabled = NO;
    connectButton.enabled = NO;
}

-(void)enableOtherButtons
{
    selectFileButton.enabled = YES;
    selectFileTypeButton.enabled = YES;
    connectButton.enabled = YES;
}

-(void)appDidEnterBackground:(NSNotification *)_notification
{
    NSLog(@"appDidEnterBackground");
    if (self.isConnected && self.isTransferring) {
        [Utility showBackgroundNotification:[self.dfuHelper getUploadStatusMessage]];
    }
}

-(void)appDidEnterForeground:(NSNotification *)_notification
{
    NSLog(@"appDidEnterForeground");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark FileType Selector Delegate

- (IBAction)unwindFileTypeSelector:(UIStoryboardSegue*)sender
{
    FileTypeTableViewController *fileTypeVC = [sender sourceViewController];
    selectedFileType = fileTypeVC.chosenFirmwareType;
    NSLog(@"unwindFileTypeSelector, selected Filetype: %@",selectedFileType);
    fileType.text = selectedFileType;
    [self.dfuHelper setFirmwareType:selectedFileType];
    [self enableUploadButton];
}

#pragma mark Device Selection Delegate
-(void)centralManager:(CBCentralManager *)manager didPeripheralSelected:(CBPeripheral *)peripheral
{
    MyLog(@"大可大可大可大可大可大可大可大可大可");
    selectedPeripheral = peripheral;
    [dfuOperations setCentralManager:manager];
    deviceName.text = peripheral.name;
    [dfuOperations connectDevice:peripheral];
}

#pragma mark File Selection Delegate

-(void)onFileSelected:(NSURL *)url
{
    NSLog(@"onFileSelected");
    MyLog(@"大大大大大大大大大大大");
    self.dfuHelper.selectedFileURL = url;
    if (self.dfuHelper.selectedFileURL) {
        NSLog(@"selectedFile URL %@",self.dfuHelper.selectedFileURL);
        NSString *selectedFileName = [[url path]lastPathComponent];
        //NSData *fileData = [NSData dataWithContentsOfURL:url];
        NSData *fileData=[NSData dataWithContentsOfFile:(NSString *)url];
        self.dfuHelper.selectedFileSize = fileData.length;
        NSLog(@"fileSelected %@",selectedFileName);
        
        //get last three characters for file extension
        NSString *extension = [selectedFileName substringFromIndex: [selectedFileName length] - 3];
        NSLog(@"selected file extension is %@",extension);
        if ([extension isEqualToString:@"zip"]) {
            NSLog(@"this is zip file");
            self.dfuHelper.isSelectedFileZipped = YES;
            self.dfuHelper.isManifestExist = NO;
            [self.dfuHelper unzipFiles:self.dfuHelper.selectedFileURL];
        }
        else {
            self.dfuHelper.isSelectedFileZipped = NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            fileName.text = selectedFileName;
            fileSize.text = [NSString stringWithFormat:@"%lu bytes", (unsigned long)self.dfuHelper.selectedFileSize];
            [self enableUploadButton];
        });
    }
    else {
        [Utility showAlert:@"Selected file not exist!"];
    }
}


#pragma mark DFUOperations delegate methods

-(void)onDeviceConnected:(CBPeripheral *)peripheral
{
    NSLog(@"onDeviceConnected %@",peripheral.name);
    self.isConnected = YES;
    self.dfuHelper.isDfuVersionExist = NO;
    [self enableUploadButton];
    //Following if condition display user permission alert for background notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

-(void)onDeviceConnectedWithVersion:(CBPeripheral *)peripheral
{
    NSLog(@"onDeviceConnectedWithVersion %@",peripheral.name);
    self.isConnected = YES;
    self.dfuHelper.isDfuVersionExist = YES;
    [self enableUploadButton];
    //Following if condition display user permission alert for background notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

-(void)onDeviceDisconnected:(CBPeripheral *)peripheral
{
    NSLog(@"device disconnected %@",peripheral.name);
    self.isTransferring = NO;
    self.isConnected = NO;
    
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dfuHelper.dfuVersion != 1) {
            [self clearUI];
            
            if (!self.isTransfered && !self.isTransferCancelled && !self.isErrorKnown) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
                if ([Utility isApplicationStateInactiveORBackground]) {
                    [Utility showBackgroundNotification:[NSString stringWithFormat:@"%@ peripheral is disconnected.",peripheral.name]];
                    
                }
                
                else {
//                    [Utility showAlert:@"The connection has been lost"];
                    
                }
              
            }
            self.isTransferCancelled = NO;
            self.isTransfered = NO;
            self.isErrorKnown = NO;
             SmaBleMgr.OTA = NO;
            if (!updSuccess) {
                SmaUserInfo *info = [SmaAccountTool userInfo];
                info.watchName = info.OTAwatchName;
                [SmaAccountTool saveUser:info];
            }
             [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            double delayInSeconds = 3.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [dfuOperations connectDevice:peripheral];
            });
            
        }
    });
}

-(void)onReadDFUVersion:(int)version
{
    NSLog(@"onReadDFUVersion %d",version);
    self.dfuHelper.dfuVersion = version;
    NSLog(@"DFU Version: %d",self.dfuHelper.dfuVersion);
    if (self.dfuHelper.dfuVersion == 1) {
        [dfuOperations setAppToBootloaderMode];
    }
    [self enableUploadButton];
}

-(void)onDFUStarted
{
    NSLog(@"onDFUStarted");
    self.isTransferring = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        uploadButton.enabled = YES;
        if (i == 0) {
            [self performDFU];
            i ++;
        }

        [uploadButton setTitle:SmaLocalizedString(@"clokadd_can") forState:UIControlStateNormal];
        //         [self performDFU];
        NSString *uploadStatusMessage = [self.dfuHelper getUploadStatusMessage];
        if ([Utility isApplicationStateInactiveORBackground]) {
            [Utility showBackgroundNotification:uploadStatusMessage];
        }
        else {
            uploadStatus.text = uploadStatusMessage;
        }
    });
}

-(void)onDFUCancelled
{
    NSLog(@"onDFUCancelled");
    self.isTransferring = NO;
    self.isTransferCancelled = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self enableOtherButtons];
    });
}

-(void)onSoftDeviceUploadStarted
{
    NSLog(@"onSoftDeviceUploadStarted");
}

-(void)onSoftDeviceUploadCompleted
{
    NSLog(@"onSoftDeviceUploadCompleted");
}

-(void)onBootloaderUploadStarted
{
    NSLog(@"onBootloaderUploadStarted");
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([Utility isApplicationStateInactiveORBackground]) {
            [Utility showBackgroundNotification:@"uploading bootloader ..."];
        }
        else {
            uploadStatus.text = @"uploading bootloader ...";
        }
    });
    
}

-(void)onBootloaderUploadCompleted
{
    NSLog(@"onBootloaderUploadCompleted");
}

-(void)onTransferPercentage:(int)percentage
{
    NSLog(@"onTransferPercentage %d",percentage);
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        progressLabel.text = [NSString stringWithFormat:@"%d %%", percentage];
        [progress setProgress:((float)percentage/100.0) animated:YES];
    });
}

-(void)onSuccessfulFileTranferred
{
    NSLog(@"OnSuccessfulFileTransferred");
    // Scanner uses other queue to send events. We must edit UI in the main queue
//    dispatch_async(dispatch_get_main_queue(), ^{
        self.isTransferring = NO;
        self.isTransfered = YES;
    updSuccess = YES;
    if (tioutTimer && tioutTimer.isValid) {
        [tioutTimer invalidate];
        tioutTimer = nil;
    }
        SmaUserInfo *info = [SmaAccountTool userInfo];
    if ([info.OTAwatchName isEqualToString:@"BLKK"] || [info.OTAwatchName isEqualToString:@"BLKK"]) {
        info.watchName = @"BLKK";
        info.OTAwatchName = @"BLKK";
    }else{
        info.watchName = @"BLKK";
        info.OTAwatchName = @"BLKK";
    }
     [SmaAccountTool saveUser:info];
    NSLog(@"SMA==NAME===%@",[SmaAccountTool userInfo].watchName);
//    [self.navigationController popViewControllerAnimated:YES];
//
//        NSString* message = [NSString stringWithFormat:@"%lu bytes transfered in %lu seconds", (unsigned long)dfuOperations.binFileSize, (unsigned long)dfuOperations.uploadTimeInSeconds];
//        if ([Utility isApplicationStateInactiveORBackground]) {
//            [Utility showBackgroundNotification:message];
//        }
//        else {
//            [Utility showAlert:message];
//        }
//
//    });
}

-(void)onError:(NSString *)errorMessage
{
    NSLog(@"OnError %@",errorMessage);
    self.isErrorKnown = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utility showAlert:errorMessage];
        [self clearUI];
    });
}

-(IBAction)cnaBut:(id)sender{
    [SmaBleMgr oneScanBand:YES];
}
@end