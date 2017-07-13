//
//  MBNetworkManager.m
//  MBBook
//
//  Created by Bing Ma on 7/13/17.
//  Copyright © 2017 Bing Ma (Hannb). All rights reserved.
//

#import "MBNetworkManager.h"

#import "YBookModel.h"
#import "YBookDetailModel.h"
#import "YBookReviewModel.h"
#import "YRecommendBookModel.h"
#import "YRecommendBookListModel.h"
#import "YBookSummaryModel.h"
#import "YChaptersLinkModel.h"
#import "YChapterContentModel.h"
#import "YBookUpdateModel.h"
#import "YRankingModel.h"
#import "YBookCatsModel.h"
#import "YBookCatsSubModel.h"

@interface MBNetworkManager ()

@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

@end

@implementation MBNetworkManager

static MBNetworkManager *netManager;
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netManager = [[self alloc] init];
    });
    return netManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkStatus = AFNetworkReachabilityStatusNotReachable;
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        cfg.timeoutIntervalForRequest = 15.0;
        cfg.timeoutIntervalForResource = 15.0;
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:cfg];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [self monitorNetWork];
    }
    return self;
}

- (NSURLSessionTask *)getWithAPIType:(MBAPIType)type parameter:(id)parameter success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    NSURL *url = [MBURLManager getURLWith:type parameter:parameter];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    __weak typeof(self) wself = self;
    NSURLSessionTask *task = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (type != MBAPITypeChapterContent) {
            NSLog(@"\n---------------------------------------begin---------------------------------------\n请求地址:%@ \n参数:%@ \n返回:%@  \n---------------------------------------end---------------------------------------",url,parameter,responseObject);
        }
        
        if (error) {
            if (failure) {
                failure([wself formatWithResponseObject:nil error:error]);
            }
        } else {
            id object = [wself parsingResponseObject:responseObject type:type];
            if (object) {
                success(object);
            } else {
                if (failure) {
                    failure([wself formatWithResponseObject:nil error:error]);
                }
            }
        }
    }];
    [task resume];
    return task;
}

// main
- (id)parsingResponseObject:(id)response type:(MBAPIType)type {
    if (response == nil) {
        return nil;
    }
    
    if (type == MBAPITypeCatsList) {
        if ([response[@"ok"] boolValue]) {
            NSArray *arr = @[response[@"male"],response[@"female"],response[@"press"]];
            NSMutableArray *maleArr = [NSMutableArray new];
            NSMutableArray *femaleArr = [NSMutableArray new];
            NSMutableArray *pressArr = [NSMutableArray new];
            for (NSInteger i = 0; i < arr.count; i++) {
                for (NSDictionary *dict in arr[i]) {
                    YBookCatsModel *rankingM = [YBookCatsModel yy_modelWithDictionary:dict];
                    if (rankingM) {
                        if (i == 0) {
                            [maleArr addObject:rankingM];
                        } else if (i == 1) {
                            [femaleArr addObject:rankingM];
                        } else if (i == 2) {
                            [pressArr addObject:rankingM];
                        }
                    }
                }
            }
            return @[maleArr,femaleArr,pressArr];
        }
        return nil;
    }
    
    if (type == MBAPITypeCatsSubList) {
        if ([response[@"ok"] boolValue]) {
            NSArray *arr = @[response[@"male"],response[@"female"],response[@"press"]];
            NSMutableArray *maleArr = [NSMutableArray new];
            NSMutableArray *femaleArr = [NSMutableArray new];
            NSMutableArray *pressArr = [NSMutableArray new];
            for (NSInteger i = 0; i < arr.count; i++) {
                for (NSDictionary *dict in arr[i]) {
                    YBookCatsSubModel *rankingM = [YBookCatsSubModel yy_modelWithDictionary:dict];
                    if (rankingM) {
                        if (i == 0) {
                            [maleArr addObject:rankingM];
                        } else if (i == 1) {
                            [femaleArr addObject:rankingM];
                        } else if (i == 2) {
                            [pressArr addObject:rankingM];
                        }
                    }
                }
            }
            return @[maleArr,femaleArr,pressArr];
        }
        return nil;
    }
    
    if (type == MBAPITypeBookDetail) {
        YBookDetailModel *bookD = [YBookDetailModel yy_modelWithJSON:response];
        return bookD;
    }
    if (type == MBAPITypeChapterContent) {
        if ([response[@"ok"] boolValue]) {
            YChapterContentModel *chapter = [YChapterContentModel yy_modelWithJSON:response[@"chapter"]];
            return chapter;
        }
        return nil;
    }
    if (type == MBAPITypeRanking) {
        if ([response[@"ok"] boolValue]) {
            NSArray *arr = @[response[@"male"],response[@"female"]];
            NSMutableArray *maleArr = [NSMutableArray new];
            NSMutableArray *femaleArr = [NSMutableArray new];
            for (NSInteger i = 0; i < arr.count; i++) {
                for (NSDictionary *dict in arr[i]) {
                    YRankingModel *rankingM = [YRankingModel yy_modelWithDictionary:dict];
                    if (rankingM) {
                        if (i == 0) {
                            [maleArr addObject:rankingM];
                        } else {
                            [femaleArr addObject:rankingM];
                        }
                    }
                }
            }
            return @[maleArr,femaleArr];
        }
        return nil;
    }
    
    NSMutableArray *dataArr = [NSMutableArray new];
    NSString *key = nil;
    if (type == MBAPITypeAutoCompletion) {
        key = @"keywords";
    } else if (type == MBAPITypeFuzzySearch || type == MBAPITypeRecommendBook || type == MBAPITypeTagBookList || type == MBAPITypeAuthorBookList || type == MBAPITypeCatsBookList) {
        key = @"books";
    } else if (type == MBAPITypeRecommendBookList) {
        key = @"booklists";
    } else if (type == MBAPITypeBookReview) {
        key = @"reviews";
    } else if (type == MBAPITypeChaptersLink) {
        key = @"chapters";
    } else if (type == MBAPITypeRankingDetial) {
        response = response[@"ranking"];
        if (!response) {
            return  nil;
        }
        key = @"books";
    }
    
    if (type == MBAPITypeAutoCompletion) {
        dataArr = response[key];
        return dataArr;
    }
    
    NSArray *arr = response;
    if (key) {
        arr = response[key];
    }
    
    NSAssert(arr != nil, @"parsingResponseObject error %@  type %zi",response,type);
    for (NSInteger i = 0 ; i < arr.count; i++) {
        YBaseModel *bookM = nil;
        if (type == MBAPITypeFuzzySearch || type == MBAPITypeTagBookList || type == MBAPITypeAuthorBookList || type == MBAPITypeCatsBookList) {
            bookM = [YBookModel yy_modelWithJSON:arr[i]];
        } else if (type == MBAPITypeRecommendBook) {
            bookM = [YRecommendBookModel yy_modelWithJSON:arr[i]];
        } else if (type == MBAPITypeRecommendBookList) {
            bookM = [YRecommendBookListModel yy_modelWithJSON:arr[i]];
        } else if (type == MBAPITypeBookReview) {
            bookM = [YBookReviewModel yy_modelWithJSON:arr[i]];
        } else if (type == MBAPITypeBookSummary) {
            bookM = [YBookSummaryModel yy_modelWithJSON:arr[i]];
        } else if (type == MBAPITypeChaptersLink) {
            bookM = [YChaptersLinkModel yy_modelWithJSON:arr[i]];
        } else if (type == MBAPITypeBookUpdate) {
            bookM = [YBookUpdateModel yy_modelWithJSON:arr[i]];
        } else if (type == MBAPITypeRankingDetial) {
            bookM = [YBookModel yy_modelWithJSON:arr[i]];//先这样
        }
        
        if (!bookM) {
            continue;
        }
        [dataArr addObject:bookM];
    }

    return dataArr;
}

// funcs
- (NSError *)formatWithResponseObject:(id)response error:(NSError *)error {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[error userInfo]];
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable) {
        [userInfo setObject:@"网络中断" forKey:NSLocalizedFailureReasonErrorKey];
    } else if (error.code == kCFURLErrorTimedOut) {
        [userInfo setObject:@"请求超时" forKey:NSLocalizedFailureReasonErrorKey];
    } else if (error.code == kCFURLErrorCannotConnectToHost || error.code == kCFURLErrorCannotFindHost || error.code == kCFURLErrorBadURL || error.code == kCFURLErrorNetworkConnectionLost) {
        [userInfo setObject:@"无法连接服务器" forKey:NSLocalizedFailureReasonErrorKey];
    }
    NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:error.code userInfo:userInfo];
    return formattedError;
}

- (void)monitorNetWork {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            default:
                break;
        }
    }];
}

@end
