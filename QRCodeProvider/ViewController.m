//
//  ViewController.m
//  QRCodeProvider
//
//  Created by Jack on 2016/11/21.
//  Copyright © 2016年 mini1. All rights reserved.
//

#import "ViewController.h"
#import "JK_QRCodeProvider.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *QRCode;

@end

@implementation ViewController

//- (void)getAllApps
//{
//    //获取手机上所有的app
//    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
//    NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSArray *apps = [workspace performSelector:@selector(allInstalledApplications)];
//    
//    Class LSApplicationProxy_class = objc_getClass("LSApplicationProxy");
//    for (int i = 0; i < apps.count; i++) {
//        NSObject *temp = apps[i];
//        if ([temp isKindOfClass:LSApplicationProxy_class]) {
//            //应用的bundleId
//            NSString *appBundleId = [temp performSelector:NSSelectorFromString(@"applicationIdentifier")];
//            //应用的名称
//            NSString *appName = [temp performSelector:NSSelectorFromString(@"localizedName")];
//            //应用的类型是系统的应用还是第三方的应用
//            NSString * type = [temp performSelector:NSSelectorFromString(@"applicationType")];
//            //应用的版本
//            NSString * shortVersionString = [temp performSelector:NSSelectorFromString(@"shortVersionString")];
//            
//            NSLog(@"类型=%@应用的BundleId=%@ ++++应用的名称=%@版本号=%@",type,appBundleId,appName,shortVersionString);
//            
//            
//        }
//    }
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *ig = [JK_QRCodeProvider jk_QRCodeFromString:@"HMLG;http://192.168.0.155/wm_postgresql;http://127.0.0.1" withSize:CGSizeMake(300, 300)];
    ig = [JK_QRCodeProvider jk_QRCodeImage:ig renderingBackgroundColor:[UIColor redColor] frontColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
    [self.QRCode setBackgroundImage:ig forState:UIControlStateNormal];
    
//    AVCaptureSession *session = [[ AVCaptureSession alloc ] init ];
//    AVCaptureVideoPreviewLayer *preview =[ AVCaptureVideoPreviewLayer layerWithSession : session ];
//    preview . frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
//    [ self.view. layer insertSublayer : preview atIndex : 0 ];
//    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64, self.view.bounds.size.width, 64)];
//    v.backgroundColor = [UIColor redColor];
//    
//    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
//    b.backgroundColor = [UIColor orangeColor];
//    b.frame = CGRectMake((self.view.bounds.size.width - 50) / 2, (64 - 50) / 2, 50, 50);
//
//    [b addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
//    [v addSubview:b];
//    [self.view addSubview:v];
    
}

- (NSString *) detectQRCode:(UIImage *)qrcode {
    if (qrcode == nil) {
        return nil;
    }
    // 初始化扫描器
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    //
    CIImage *ciImage = qrcode.CIImage;
    if (ciImage == nil) {
        ciImage = [CIImage imageWithCGImage:qrcode.CGImage];
    }
    if (ciImage == nil) {
        return nil;
    }
    // 扫描获取特征组
    NSArray* features = [detector featuresInImage:ciImage];
    // 获取扫描结果
    if (features != nil && features.count > 0) {
        CIQRCodeFeature* feature = [features objectAtIndex:0];
        return feature.messageString;
    } else {
        return nil;
    }
    
    /** 出错
     *
     * 如果UIImage底层是CIImage，那么CGImage为nil；
     * 如果UIImage底层是CGImage，那么CIImage为nil；
     * UIImagePNGRepresentation return image as PNG. May return nil if image has no CGImageRef or invalid bitmap format
     
     一、
     NSData *imageData = UIImagePNGRepresentation([self.QRCode backgroundImageForState:UIControlStateNormal]);
     imageData == nil
     
     NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"test"]);
     imageData != nil
     
     二、
     [UIImage imageNamed:@"test"].CGImage != nil
     [UIImage imageNamed:@"test"].CIImage == nil
     
     三、
     [self.QRCode backgroundImageForState:UIControlStateNormal].CGImage == nil
     [self.QRCode backgroundImageForState:UIControlStateNormal].CIImage != nil

     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked:(id)sender {
    
//    [self getAllApps];
    
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.modalPresentationStyle = UIModalPresentationFormSheet;
//    vc.preferredContentSize = CGSizeMake(300, 280);
//    vc.view.backgroundColor = [UIColor yellowColor];
//
//    [self presentViewController:vc animated:YES completion:nil];
    
    NSLog(@"%@",[self detectQRCode:[UIImage imageNamed:@"jack"]]);
//    NSLog(@"%@",[self detectQRCode:[self.QRCode backgroundImageForState:UIControlStateNormal]]);
}

@end
