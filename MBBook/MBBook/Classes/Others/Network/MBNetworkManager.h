//
//  MBNetworkManager.h
//  MBBook
//
//  Created by Bing Ma on 7/13/17.
//  Copyright © 2017 Bing Ma (Hannb). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBURLManager.h"

@interface MBNetworkManager : NSObject

+ (instancetype)shareManager;

- (NSURLSessionTask *)getWithAPIType:(MBAPIType)type parameter:(id)parameter success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

@end
