//
//  DLAppDelegate.h
//  test_ufr_objc
//
//  Created by srkos on 3/13/15.
//  Copyright (c) 2015 D-LOGIC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DLAppDelegate : NSObject <NSApplicationDelegate> {
    __weak NSTextField *sttsLabel;
    __weak NSButtonCell *bEraseLastNDEF;
    __weak NSButtonCell *bEraseAllNdef;
    __weak NSButton *bCardUIDGet;
    __weak NSTextField *UidTxtField;
    __weak NSTextField *NdefRecordTxt;
    __weak NSButton *bReadNdefRecord;
    __weak NSView *bWritePhone;
    __weak NSTextField *phoneNumTxt;
    __weak NSTextField *SmsText;
    __weak NSTextField *PhoneSMS;
    __weak NSButton *btnWriteSMS;
    __weak NSComboBox *UriCmb;
    __weak NSTextField *UriFieldTxt;
    __weak NSButton *bWriteURI;
    __weak NSTextField *DisplayNameTxt;
    __weak NSTextField *LastNameTxt;
    __weak NSTextField *FirstNameTxt;
    __weak NSTextField *BussinessPhoneTxt;
    __weak NSTextField *CellPhoneTxt;
    __weak NSTextField *PrivatePhoneTxt;
    __weak NSTextField *BussinessEmailTxt;
    __weak NSTextField *PrivateEmailTxt;
    __weak NSTextField *WebsiteURLTxt;
    __weak NSTextField *SkypeNameTxt;
    __weak NSButton *bWriteVCard;
    __weak NSTextField *BluetoothAddrTxt;
    __weak NSButton *bWriteBluetoothAddress;
}


@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *eLog;

-(IBAction)bReaderOpen: (id)sender;
-(IBAction)bReaderClose: (id)sender;

-(IBAction)bGetCardUID: (id)sender;

-(void)updateTextWithMsg: (const char *) msg;
@property (weak) IBOutlet NSTextField *sttsLabel;

@property (weak) IBOutlet NSButtonCell *bEraseLastNDEF;

@property (weak) IBOutlet NSButtonCell *bEraseAllNdef;

@property (weak) IBOutlet NSButton *bCardUIDGet;

@property (weak) IBOutlet NSTextField *UidTxtField;

@property (weak) IBOutlet NSTextField *NdefRecordTxt;

@property (weak) IBOutlet NSButton *bReadNdefRecord;

@property (weak) IBOutlet NSView *bWritePhone;

@property (weak) IBOutlet NSTextField *phoneNumTxt;

@property (weak) IBOutlet NSTextField *SmsText;

@property (weak) IBOutlet NSTextField *PhoneSMS;

@property (weak) IBOutlet NSButton *btnWriteSMS;

@property (weak) IBOutlet NSComboBox *UriCmb;
@property (weak) IBOutlet NSTextField *UriFieldTxt;

@property (weak) IBOutlet NSButton *bWriteURI;

@property (weak) IBOutlet NSTextField *DisplayNameTxt;

@property (weak) IBOutlet NSTextField *LastNameTxt;

@property (weak) IBOutlet NSTextField *FirstNameTxt;

@property (weak) IBOutlet NSTextField *BussinessPhoneTxt;

@property (weak) IBOutlet NSTextField *CellPhoneTxt;

@property (weak) IBOutlet NSTextField *PrivatePhoneTxt;

@property (weak) IBOutlet NSTextField *BussinessEmailTxt;

@property (weak) IBOutlet NSTextField *PrivateEmailTxt;

@property (weak) IBOutlet NSTextField *WebsiteURLTxt;

@property (weak) IBOutlet NSTextField *SkypeNameTxt;

@property (weak) IBOutlet NSButton *bWriteVCard;

@property (weak) IBOutlet NSTextField *BluetoothAddrTxt;

@property (weak) IBOutlet NSButton *bWriteBluetoothAddress;

@property (weak) IBOutlet NSButton *bStartDedicated;

@property (weak) IBOutlet NSButton *bStartCombined;

@property (weak) IBOutlet NSButton *bStopTagEmulation;

@property (weak) IBOutlet NSButton *bUnlockNV;

@property (weak) IBOutlet NSButton *bLockNV;

@property (weak) IBOutlet NSTextField *PasswordTxt;

@property (weak) IBOutlet NSButton *bStorePhoneToReader;

@property (weak) IBOutlet NSButton *bStoreSMSReader;

@property (weak) IBOutlet NSButton *bStoreURIReader;

@property (weak) IBOutlet NSButton *bStorevCardReader;

@property (weak) IBOutlet NSButton *bWriteBLToReader;

@property (weak) IBOutlet NSButton *chkAdvanced;

@property (weak) IBOutlet NSTextField *txtReaderType;

@property (weak) IBOutlet NSTextField *txtPortName;

@property (weak) IBOutlet NSTextField *txtPortInterface;

@property (weak) IBOutlet NSTextField *txtOpenARg;


@end
