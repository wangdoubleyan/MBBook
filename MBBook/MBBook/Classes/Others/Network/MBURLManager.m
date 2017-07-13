//
//  MBURLManager.m
//  MBBook
//
//  Created by Bing Ma on 7/13/17.
//  Copyright © 2017 Bing Ma (Hannb). All rights reserved.
//

#import "MBURLManager.h"
#import <CoreFoundation/CoreFoundation.h>

#define kAPIBaseUrl @"https://api.zhuishushenqi.com/"

@implementation MBURLManager

+ (NSURL *)getURLWith:(MBAPIType)type parameter:(id)parameter {
    NSString *urlStr = nil;
    switch (type) {
        case MBAPITypeFuzzySearch:
            urlStr = [NSString stringWithFormat:@"%@book/fuzzy-search?query=%@&start=0&limit=100",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeAutoCompletion:
            urlStr = [NSString stringWithFormat:@"%@book/auto-complete?query=%@",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeBookCover: {
            if ([parameter hasPrefix:@"/cover/"] || [parameter hasPrefix:@"/ranking-cover/"] || [parameter hasPrefix:@"/agent/" ]) {
                urlStr = [NSString stringWithFormat:@"https://statics.zhuishushenqi.com%@",parameter];
            } else {
                parameter = [self encodeToPercentEscapeString:parameter];
                urlStr = [NSString stringWithFormat:@"https://statics.zhuishushenqi.com/agent/%@-covers",parameter];
            }
        }
            break;
        case MBAPITypeAuthorAvatar:
            urlStr = [NSString stringWithFormat:@"https://statics.zhuishushenqi.com%@",parameter];
            break;
        case MBAPITypeBookDetail:
            urlStr = [NSString stringWithFormat:@"%@book/%@",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeBookReview:
            urlStr = [NSString stringWithFormat:@"%@post/review/best-by-book?book=%@",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeRecommendBook:
            urlStr = [NSString stringWithFormat:@"%@book/%@/recommend",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeRecommendBookList:
            urlStr = [NSString stringWithFormat:@"%@book-list/%@/recommend?limit=3",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeBookSummary:
            urlStr = [NSString stringWithFormat:@"%@atoc?view=summary&book=%@",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeChaptersLink:
            urlStr = [NSString stringWithFormat:@"%@atoc/%@?view=chapters",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeChapterContent: {
            parameter = [self encodeToPercentEscapeString:parameter];
            urlStr = [NSString stringWithFormat:@"https://chapter2.zhuishushenqi.com/chapter/%@",parameter];
            break;
        }
        case MBAPITypeBookUpdate:
            urlStr = [NSString stringWithFormat:@"%@book?view=updated&id=%@",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeRanking:
            urlStr = [NSString stringWithFormat:@"%@ranking/gender",kAPIBaseUrl];
            break;
        case MBAPITypeRankingDetial:
            urlStr = [NSString stringWithFormat:@"%@ranking/%@",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeTagBookList: {
            parameter = [self encodeToPercentEscapeString:parameter];
            urlStr = [NSString stringWithFormat:@"%@book/by-tags?tags=%@",kAPIBaseUrl,parameter];
            break;
        }
        case MBAPITypeAuthorBookList: {
            parameter = [self encodeToPercentEscapeString:parameter];
            urlStr = [NSString stringWithFormat:@"%@book/accurate-search?author=%@",kAPIBaseUrl,parameter];
            break;
        }
        case MBAPITypeCatsList:
            urlStr = [NSString stringWithFormat:@"%@cats/lv2/%@",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeCatsSubList:
            urlStr = [NSString stringWithFormat:@"%@cats/%@",kAPIBaseUrl,parameter];
            break;
        case MBAPITypeCatsBookList: {
            urlStr = [NSString stringWithFormat:@"%@book/by-categories?%@",kAPIBaseUrl,parameter];
            urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        }
        default:
            break;
    }
    
    if (type == MBAPITypeAutoCompletion || type == MBAPITypeFuzzySearch) {
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return [NSURL URLWithString:urlStr];
}

+ (NSString *)encodeToPercentEscapeString:(NSString *)input {
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)input, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return outputStr;
}

@end
