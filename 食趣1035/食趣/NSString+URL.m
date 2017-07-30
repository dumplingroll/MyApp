//
//  NSString+URL.m
//  MY
//
//  Created by 千锋 on 15/10/18.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)URLEncodeString{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    return encodedString;
}


@end
