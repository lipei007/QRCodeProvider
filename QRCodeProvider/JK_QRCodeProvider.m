//
//  JK_QRCodeProvider.m
//  QRCodeProvider
//
//  Created by Jack on 2016/11/21.
//  Copyright © 2016年 mini1. All rights reserved.
//

#import "JK_QRCodeProvider.h"

@implementation JK_QRCodeProvider

+(UIImage *)jk_QRCodeFromString:(NSString *)string withSize:(CGSize)size {
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // The data to be encoded as a QR code. An NSData object whose display name is Message.
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    // QR码有容错能力，QR码图形如果有破损，仍然可以被机器读取内容,Default value: M
    // 相对而言，容错率愈高，QR码图形面积愈大。所以一般折衷使用15%容错能力。
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    /**
     L水平 7%的字码可被修正

     M水平 15%的字码可被修正
     
     Q水平 25%的字码可被修正
     
     H水平 30%的字码可被修正
     */
    
    CIImage *qrImage = qrFilter.outputImage;
    
    //放大二维码
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
    
}

+ (UIImage *)jk_QRCodeImage:(UIImage *)QRcodeImage renderingBackgroundColor:(UIColor *)backgroundColor frontColor:(UIColor *)frontColor {
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",[CIImage imageWithCGImage:QRcodeImage.CGImage],
                             @"inputColor0",[CIColor colorWithCGColor:frontColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    return [UIImage imageWithCIImage:colorFilter.outputImage];
    
}

+(UIImage *)jk_QRCodeImage:(UIImage *)QRCodeImage withThumb:(UIImage *)thumb {
    
    UIGraphicsBeginImageContext(QRCodeImage.size);
    [QRCodeImage drawInRect:CGRectMake(0, 0, QRCodeImage.size.width, QRCodeImage.size.height)];
    
    CGFloat imageW = 50;
    CGFloat imageX = (QRCodeImage.size.width - imageW) * 0.5;
    CGFloat imgaeY = (QRCodeImage.size.height - imageW) * 0.5;
    [thumb drawInRect:CGRectMake(imageX, imgaeY, imageW, imageW)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
    
}

+ (NSString *) detectQRCode:(UIImage *)qrcode {
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

@end
