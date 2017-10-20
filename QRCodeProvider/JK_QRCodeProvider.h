//
//  JK_QRCodeProvider.h
//  QRCodeProvider
//
//  Created by Jack on 2016/11/21.
//  Copyright © 2016年 mini1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JK_QRCodeProvider : NSObject

+ (UIImage *)jk_QRCodeFromString:(NSString *)string withSize:(CGSize)size;

+ (UIImage *)jk_QRCodeImage:(UIImage *)QRcodeImage renderingBackgroundColor:(UIColor *)backgroundColor frontColor:(UIColor *)frontColor;

+ (UIImage *)jk_QRCodeImage:(UIImage *)QRCodeImage withThumb:(UIImage *)thumb;

+ (NSString *) detectQRCode:(UIImage *)qrcode;

@end
