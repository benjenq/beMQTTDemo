//
//  beJSONFromUrl.h
//  beMQTTDemo
//
//  Created by Ben Cheng on 2016/10/9, Tainan City, Taiwan
//  Copyright 2016 Ben Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface beJSONFromUrl : NSObject

typedef NS_ENUM(NSUInteger,httpMethod)
{
    httpMethodIsPOST = 0,
    httpMethodIsGET = 1,
    httpMethodIsPUT = 2
};

+(void)jsonFromURL:(NSString *)urlStr method:(httpMethod)method completion:(void(^)(BOOL success,NSString *errorStr, NSString *resultJsonString, NSDictionary *resultDic))completion;

@end
