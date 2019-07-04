//
//  DLAppDelegate.m
//  test_ufr_objc
//
//  Created by srkos on 3/13/15.
//  Copyright (c) 2015 D-LOGIC. All rights reserved.
//

#import "DLAppDelegate.h"

#import "uFCoder.h"

@implementation DLAppDelegate
@synthesize sttsLabel;
@synthesize bEraseLastNDEF;
@synthesize bEraseAllNdef;
@synthesize bCardUIDGet;
@synthesize UidTxtField;
@synthesize NdefRecordTxt;
@synthesize bReadNdefRecord;
@synthesize bWritePhone;
@synthesize phoneNumTxt;
@synthesize SmsText;
@synthesize PhoneSMS;
@synthesize btnWriteSMS;
@synthesize UriCmb;
@synthesize UriFieldTxt;
@synthesize bWriteURI;
@synthesize DisplayNameTxt;
@synthesize LastNameTxt;
@synthesize FirstNameTxt;
@synthesize BussinessPhoneTxt;
@synthesize CellPhoneTxt;
@synthesize PrivatePhoneTxt;
@synthesize BussinessEmailTxt;
@synthesize PrivateEmailTxt;
@synthesize WebsiteURLTxt;
@synthesize SkypeNameTxt;
@synthesize bWriteVCard;
@synthesize BluetoothAddrTxt;
@synthesize bWriteBluetoothAddress;

@synthesize eLog;

-(void)updateTextWithMsg: (const char *) msg
{
    NSString *nsMsg = [[NSString alloc] initWithBytes:msg length:strlen(msg) encoding:NSASCIIStringEncoding];
    
    [self.eLog setStringValue:nsMsg];
    
    NSLog(@"%@", nsMsg);
    
    //    [nsMsg release];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    char msg_cstr[64];
    sprintf(msg_cstr, "uFCoder lib v.%s", GetDllVersionStr());
    [self updateTextWithMsg:msg_cstr];
}

-(IBAction)bReaderOpen: (id)sender
{
    UFR_STATUS status;
    
    if (_chkAdvanced.state == NSOnState)
    {
        NSString *reader_type = _txtReaderType.stringValue;
        NSString *port_name = _txtPortName.stringValue;
        NSString *port_interface = _txtPortInterface.stringValue;
        NSString *arg = _txtOpenARg.stringValue;
        
        const char * reader_type_str = reader_type.UTF8String;
        uint32 reader_type_int = atoi(reader_type_str);
        uint32_t port_interface_int = 0;
        
        if ([_txtPortInterface.stringValue isEqualToString:@"U"])
        {
            port_interface_int = 85;
        }
        else if ([_txtPortInterface.stringValue isEqualToString:@"T"])
        {
            port_interface_int = 84;
        }
        else
        {
            port_interface_int = atoi(port_interface.UTF8String);
        }
        
        const char * port_name_str = port_name.UTF8String;
        
        const char * arg_str = arg.UTF8String;
        
        status = ReaderOpenEx(reader_type_int, port_name_str, port_interface_int,(void*)arg_str);
        
        
    } else {
        status = ReaderOpen();
    }
    
    if (status == 0)
    {
        ReaderUISignal(1,1);
        
    }
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

-(IBAction)bReaderClose: (id)sender
{
    UFR_STATUS status;
    
    status = ReaderClose();
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

-(IBAction)bGetCardUID:(id)sender
{
    UFR_STATUS status;
    
    status = ndef_card_initialization();
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)EraseLastNDEFRecordInCard:(id)sender
{
    UFR_STATUS status;
    
    status = erase_last_ndef_record(1);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)EraseAllNDEFRecordsInCard:(id)sender
{
    UFR_STATUS status;
    
    status = erase_all_ndef_records(1);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)NDEFCardUIDGet:(id)sender
{
    UFR_STATUS status;
    uint8_t uid[10];
    uint8_t CardType;
    uint8_t uidSize;
    
    status = GetCardIdEx(&CardType, uid, &uidSize);
    
    char msg_cstr[64];
    
    if(status)
    {
        sprintf(msg_cstr, "%s", "");
    }
    else
    {
        sprintf(msg_cstr, "Card UID[%d bytes] = ", uidSize);
        
        for(uint8_t i = 0; i < uidSize; i++)
        {
            char hex[4] = "";
            sprintf(hex, "%02X", uid[i]);
            strcat(msg_cstr, hex);
        }
    }
    
    UidTxtField.stringValue = @(msg_cstr);
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)ReadNdefRecord:(id)sender
{
    NdefRecordTxt.stringValue = @"";
    UFR_STATUS status;
    uint8_t message_cnt, record_cnt, empty_record_cnt;
    uint8 record_array[100];
    uint8_t tnf;
    uint8_t type[256];
    uint8_t rec_id[256];
    uint8_t payload[256];
    uint8_t type_length;
    uint8_t id_length;
    uint32_t payload_length;
    
    status = get_ndef_record_count(&message_cnt, &record_cnt, record_array, &empty_record_cnt);
    
    if(status)
    {
        sttsLabel.stringValue = @(UFR_Status2String(status));
        NdefRecordTxt.stringValue = @"";
        return;
    }
    
    for(uint8_t record_nr = 1; record_nr < record_cnt + 1; record_nr++)
    {
        status = read_ndef_record(1, record_nr, &tnf, type, &type_length, rec_id, &id_length, payload, &payload_length);
        
        if(!status)
        {
            NSString *str_type = [NSString stringWithFormat:@"%c", type[0]];
            NSString *str_payload = [NSString stringWithUTF8String:(char *)payload];
            NSString *str_payload_len = [NSString stringWithFormat:@"%d", payload_length];
            NSString *str_record_nr = [NSString stringWithFormat:@"%d", record_nr];
            
            NSString *string3 = [NSString stringWithFormat:@"record number: %@\ntype: %@ \nlength: %@\npayload: %@",str_record_nr, str_type, str_payload_len, str_payload];
            
            NdefRecordTxt.stringValue = string3;
        }
        else
        {
            NdefRecordTxt.stringValue = @"";
        }
    }
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)WritePhoneToCard:(id)sender
{
    NSString *phone = phoneNumTxt.stringValue;
    
    const char * theUniChar = phone.UTF8String;
    
    uint8_t data[50] = {0};
    data[0] = 5;
    uint8_t i = 1;
    
    for(uint8_t j = 0; j < strlen(theUniChar); j++)
    {
        data[i] = (uint8_t)theUniChar[j];
        i++;
    }
    
    UFR_STATUS status;
    uint8_t card_form;
    uint8_t tnf = 1;
    uint8_t type= 'U';
    uint8_t type_len = 1;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = (uint32_t)strlen(theUniChar) + 1;
   
    status = write_ndef_record(1, &tnf, &type, &type_len, rec_id, &id_length, data, &payload_length, &card_form);

    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)writeSMStoCard:(id)sender
{
    NSString *phoneNum = PhoneSMS.stringValue;
    NSString *sms = SmsText.stringValue;
    
    const char *PHONE_NUMBER = phoneNum.UTF8String;
    const char *SMS = sms.UTF8String;
    char data[500];
    
    sprintf(data,"sms: %s?body=%s", PHONE_NUMBER, SMS);
    
    uint8_t payload[500];
    payload[0] = 0;
    uint32_t i = 1;
    
    for(uint32_t j = 0; j < strlen(PHONE_NUMBER) + strlen(SMS) + 12; j++)
    {
        payload[i] = (uint8_t)data[j];
        i++;
    }
    
    UFR_STATUS status;
    uint8_t card_form;
    uint8_t tnf = 1;
    uint8_t type= 'U';
    uint8_t type_len = 1;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = (uint32_t)strlen(PHONE_NUMBER) + (uint32_t)strlen(SMS) + 12;
    
    status = write_ndef_record(1, &tnf, &type, &type_len, rec_id, &id_length, payload, &payload_length, &card_form);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
    
}

- (IBAction)WriteURIToCard:(id)sender
{
    uint8_t selected = UriCmb.indexOfSelectedItem + 1;
    NSString *url = UriFieldTxt.stringValue;
    
    const char *URL = url.UTF8String;
    
    uint8_t data[50] = {0};
    data[0] = selected;
    uint8_t i = 1;
    
    for(uint8_t j = 0; j < strlen(URL); j++)
    {
        data[i] = (uint8_t)URL[j];
        i++;
    }
    
    UFR_STATUS status;
    uint8_t card_form;
    uint8_t tnf = 1;
    uint8_t type= 'U';
    uint8_t type_len = 1;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = (uint32_t)strlen(URL) + 1;
    
    status = write_ndef_record(1, &tnf, &type, &type_len, rec_id, &id_length, data, &payload_length, &card_form);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)WriteVCardToCard:(id)sender
{
    NSString *Disp_Name = DisplayNameTxt.stringValue;
    NSString *First_Name = FirstNameTxt.stringValue;
    NSString *Last_Name = LastNameTxt.stringValue;
    NSString *Bussiness_Phone = BussinessPhoneTxt.stringValue;
    NSString *Cell_Phone = CellPhoneTxt.stringValue;
    NSString *Private_Phone = PrivatePhoneTxt.stringValue;
    NSString *Website_URL = WebsiteURLTxt.stringValue;
    NSString *Skype_Name = SkypeNameTxt.stringValue;
    NSString *Bussiness_Email = BussinessEmailTxt.stringValue;
    NSString *Private_Email = PrivateEmailTxt.stringValue;
    
    const char *DisplayName = Disp_Name.UTF8String;
    const char *FirstName = First_Name.UTF8String;
    const char *LastName = Last_Name.UTF8String;
    const char *BussinessPhone = Bussiness_Phone.UTF8String;
    const char *CellPhone = Cell_Phone.UTF8String;
    const char *PrivatePhone = Private_Phone.UTF8String;
    const char *WebsiteURL = Website_URL.UTF8String;
    const char *SkypeName = Skype_Name.UTF8String;
    const char *BussinesEmail = Bussiness_Email.UTF8String;
    const char *PrivateEmail = Private_Email.UTF8String;
    
    char data[1000];
    
    if(Disp_Name.length == 0 || Last_Name.length == 0)
    {
        sttsLabel.stringValue = @"Display Name and Last Name fields are mandatory!";
        return;
    }
    
    sprintf(data,"%s%sN:%s;%s;;;\r\nFN:%s\r\n", "BEGIN:VCARD\r\n", "VERSION:3.0\r\n",
            LastName, FirstName, DisplayName);
    
    if(Cell_Phone.length != 0)
    {
        strcat(data, "TEL;CELL:");
        strcat(data, CellPhone);
        strcat(data, "\r\n");
    }
    
    if(Bussiness_Phone.length != 0)
    {
        strcat(data, "TEL;WORK:");
        strcat(data, BussinessPhone);
        strcat(data, "\r\n");
    }
    
    if(Private_Phone.length != 0)
    {
        strcat(data, "TEL;HOME:");
        strcat(data, PrivatePhone);
        strcat(data, "\r\n");
    }
    
    if(Bussiness_Email.length != 0)
    {
        strcat(data, "EMAIL;WORK:");
        strcat(data, BussinesEmail);
        strcat(data, "\r\n");
    }
    
    if(Private_Email.length != 0)
    {
        strcat(data, "EMAIL;HOME:");
        strcat(data, PrivateEmail);
        strcat(data, "\r\n");
    }
    
    if(Website_URL.length != 0)
    {
        strcat(data, "URL:");
        strcat(data, WebsiteURL);
        strcat(data, "\r\n");
    }
    
    if(Skype_Name.length != 0)
    {
        strcat(data, "X-SKYPE:");
        strcat(data, SkypeName);
        strcat(data, "\r\n");
    }
    
    strcat(data, "END:VCARD");
    
    uint8_t payload[1000];
    
    for(uint32_t j = 0; j < strlen(data); j++)
    {
        payload[j] = (uint8_t)data[j];
    }
    
    UFR_STATUS status;
    uint8_t card_form;
    uint8_t tnf = 2;
    uint8_t type[12] = {'t','e','x','t','/','x','-','v','C','a','r','d'};
    uint8_t type_len = 12;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = (uint32_t)strlen(data);
    
    status = write_ndef_record(1, &tnf, type, &type_len, rec_id, &id_length, payload, &payload_length, &card_form);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
    
}

size_t hex2bin(uint8_t *dst, const char *src) {
    size_t dst_len = 0;
    char s_tmp[3];
    
    s_tmp[2] = '\0';
    
    while (*src) {
        while (((char)*src < '0' || (char)*src > '9')
               && ((char)*src < 'a' || (char)*src > 'f')
               && ((char)*src < 'A' || (char)*src > 'F'))
            src++; // skip delimiters, white spaces, etc.
        
        s_tmp[0] = (char) *src++;
        
        // Must be pair of the hex digits:
        if (!(*src))
            break;
        
        // And again, must be pair of the hex digits:
        if (((char)*src < '0' || (char)*src > '9')
            && ((char)*src < 'a' || (char)*src > 'f')
            && ((char)*src < 'A' || (char)*src > 'F'))
            break;
        
        s_tmp[1] = (char) *src++;
        
        *dst++ = strtoul(s_tmp, NULL, 16);
        dst_len++;
    }
    
    return dst_len;
}


- (IBAction)WriteBluetoothAddressToCard:(id)sender
{
    NSString *BL_Address = BluetoothAddrTxt.stringValue;
    const char *BluetoothAddress = BL_Address.UTF8String;
    uint8_t bl_addr[6];
    size_t str_len;
    
    str_len = hex2bin(bl_addr, BluetoothAddress);
    
    if(str_len != 6)
    {
        sttsLabel.stringValue = @"Bluetooth address must be 6 bytes long!";
        return;
    }
    
    uint8_t payload[8];
    payload[0] = 8;
    payload[1] = 0;
    uint8_t cnt = 2;
    
    for(uint8_t j = 0; j < 6; j++)
    {
        payload[cnt] = bl_addr[j];
        cnt++;
    }
    
    UFR_STATUS status;
    uint8_t card_form;
    uint8_t tnf = 2;
    uint8_t type[32] = {'a','p','p','l','i','c','a','t','i','o','n','/','v','n','d','.','b','l','u','e','t','o','o','t','h','.','e','p','.','o','o','b'};
    uint8_t type_len = 32;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = 8;
    
    status = write_ndef_record(1, &tnf, type, &type_len, rec_id, &id_length, payload, &payload_length, &card_form);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)bStartDedicatedTagEmulation:(id)sender
{
    UFR_STATUS status;
    
    status = TagEmulationStart();
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)StartCombinedTagEmulation:(id)sender
{
    UFR_STATUS status;
    
    status = CombinedModeEmulationStart();
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)StopTagEmulation:(id)sender
{
    UFR_STATUS status;
    
    status = TagEmulationStop();
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)StorePhoneToReaderForTagEmulation:(id)sender
{
    NSString *phone = phoneNumTxt.stringValue;
    
    const char * theUniChar = phone.UTF8String;
    
    uint8_t data[50] = {0};
    data[0] = 5;
    uint8_t i = 1;
    
    for(uint8_t j = 0; j < strlen(theUniChar); j++)
    {
        data[i] = (uint8_t)theUniChar[j];
        i++;
    }
    
    UFR_STATUS status;
    uint8_t tnf = 1;
    uint8_t type[2] = {'U', 0};
    uint8_t type_len = 1;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = (uint32_t)strlen(theUniChar) + 1;
    
    status = WriteEmulationNdef(tnf, type, type_len, rec_id, id_length, data, payload_length);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)StoreSMSIntoReader:(id)sender
{
    NSString *phoneNum = PhoneSMS.stringValue;
    NSString *sms = SmsText.stringValue;
    
    const char *PHONE_NUMBER = phoneNum.UTF8String;
    const char *SMS = sms.UTF8String;
    char data[500];
    
    sprintf(data,"sms: %s?body=%s", PHONE_NUMBER, SMS);
    
    uint8_t payload[500];
    payload[0] = 0;
    uint32_t i = 1;
    
    for(uint32_t j = 0; j < strlen(PHONE_NUMBER) + strlen(SMS) + 12; j++)
    {
        payload[i] = (uint8_t)data[j];
        i++;
    }
    
    UFR_STATUS status;
    uint8_t tnf = 1;
    uint8_t type[2] = {'U', 0};
    uint8_t type_len = 1;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = (uint32_t)strlen(PHONE_NUMBER) + (uint32_t)strlen(SMS) + 12;
    
    status = WriteEmulationNdef(tnf, type, type_len, rec_id, id_length, payload, payload_length);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)bStoreURIIntoReader:(id)sender
{
    uint8_t selected = UriCmb.indexOfSelectedItem + 1;
    NSString *url = UriFieldTxt.stringValue;
    
    const char *URL = url.UTF8String;
    
    uint8_t data[50] = {0};
    data[0] = selected;
    uint8_t i = 1;
    
    for(uint8_t j = 0; j < strlen(URL); j++)
    {
        data[i] = (uint8_t)URL[j];
        i++;
    }
    
    UFR_STATUS status;
    uint8_t tnf = 1;
    uint8_t type[2] = {'U', 0};
    uint8_t type_len = 1;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = (uint32_t)strlen(URL) + 1;
    
    status = WriteEmulationNdef(tnf, type, type_len, rec_id, id_length, data, payload_length);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}


- (IBAction)StoreVCardIntoReader:(id)sender
{
    NSString *Disp_Name = DisplayNameTxt.stringValue;
    NSString *First_Name = FirstNameTxt.stringValue;
    NSString *Last_Name = LastNameTxt.stringValue;
    NSString *Bussiness_Phone = BussinessPhoneTxt.stringValue;
    NSString *Cell_Phone = CellPhoneTxt.stringValue;
    NSString *Private_Phone = PrivatePhoneTxt.stringValue;
    NSString *Website_URL = WebsiteURLTxt.stringValue;
    NSString *Skype_Name = SkypeNameTxt.stringValue;
    NSString *Bussiness_Email = BussinessEmailTxt.stringValue;
    NSString *Private_Email = PrivateEmailTxt.stringValue;
    
    const char *DisplayName = Disp_Name.UTF8String;
    const char *FirstName = First_Name.UTF8String;
    const char *LastName = Last_Name.UTF8String;
    const char *BussinessPhone = Bussiness_Phone.UTF8String;
    const char *CellPhone = Cell_Phone.UTF8String;
    const char *PrivatePhone = Private_Phone.UTF8String;
    const char *WebsiteURL = Website_URL.UTF8String;
    const char *SkypeName = Skype_Name.UTF8String;
    const char *BussinesEmail = Bussiness_Email.UTF8String;
    const char *PrivateEmail = Private_Email.UTF8String;
    
    char data[1000];
    
    if(Disp_Name.length == 0 || Last_Name.length == 0)
    {
        sttsLabel.stringValue = @"Display Name and Last Name fields are mandatory!";
        return;
    }
    
    sprintf(data,"%s%sN:%s;%s;;;\r\nFN:%s\r\n", "BEGIN:VCARD\r\n", "VERSION:3.0\r\n",
            LastName, FirstName, DisplayName);
    
    if(Cell_Phone.length != 0)
    {
        strcat(data, "TEL;CELL:");
        strcat(data, CellPhone);
        strcat(data, "\r\n");
    }
    
    if(Bussiness_Phone.length != 0)
    {
        strcat(data, "TEL;WORK:");
        strcat(data, BussinessPhone);
        strcat(data, "\r\n");
    }
    
    if(Private_Phone.length != 0)
    {
        strcat(data, "TEL;HOME:");
        strcat(data, PrivatePhone);
        strcat(data, "\r\n");
    }
    
    if(Bussiness_Email.length != 0)
    {
        strcat(data, "EMAIL;WORK:");
        strcat(data, BussinesEmail);
        strcat(data, "\r\n");
    }
    
    if(Private_Email.length != 0)
    {
        strcat(data, "EMAIL;HOME:");
        strcat(data, PrivateEmail);
        strcat(data, "\r\n");
    }
    
    if(Website_URL.length != 0)
    {
        strcat(data, "URL:");
        strcat(data, WebsiteURL);
        strcat(data, "\r\n");
    }
    
    if(Skype_Name.length != 0)
    {
        strcat(data, "X-SKYPE:");
        strcat(data, SkypeName);
        strcat(data, "\r\n");
    }
    
    strcat(data, "END:VCARD");
    
    uint8_t payload[1000];
    
    for(uint32_t j = 0; j < strlen(data); j++)
    {
        payload[j] = (uint8_t)data[j];
    }
    
    UFR_STATUS status;
    uint8_t tnf = 2;
    uint8_t type[12] = {'t','e','x','t','/','x','-','v','C','a','r','d'};
    uint8_t type_len = 12;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = (uint32_t)strlen(data);
    
    status = WriteEmulationNdef(tnf, type, type_len, rec_id, id_length, payload, payload_length);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}

- (IBAction)WriteBluetoothAddressToReader:(id)sender
{
    NSString *BL_Address = BluetoothAddrTxt.stringValue;
    const char *BluetoothAddress = BL_Address.UTF8String;
    uint8_t bl_addr[6];
    size_t str_len;
    
    str_len = hex2bin(bl_addr, BluetoothAddress);
    
    if(str_len != 6)
    {
        sttsLabel.stringValue = @"Bluetooth address must be 6 bytes long!";
        return;
    }
    
    uint8_t payload[8];
    payload[0] = 8;
    payload[1] = 0;
    uint8_t cnt = 2;
    
    for(uint8_t j = 0; j < 6; j++)
    {
        payload[cnt] = bl_addr[j];
        cnt++;
    }
    
    UFR_STATUS status;
    uint8_t tnf = 2;
    uint8_t type[32] = {'a','p','p','l','i','c','a','t','i','o','n','/','v','n','d','.','b','l','u','e','t','o','o','t','h','.','e','p','.','o','o','b'};
    uint8_t type_len = 32;
    uint8_t rec_id[10];
    uint8_t id_length = 0;
    uint32_t payload_length = 8;
    
    status = WriteEmulationNdef(tnf, type, type_len, rec_id, id_length, payload, payload_length);
    
    sttsLabel.stringValue = @(UFR_Status2String(status));
}


@end
