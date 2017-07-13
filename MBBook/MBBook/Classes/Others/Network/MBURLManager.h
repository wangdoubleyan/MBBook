//
//  MBURLManager.h
//  MBBook
//
//  Created by Bing Ma on 7/13/17.
//  Copyright © 2017 Bing Ma (Hannb). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MBAPIType) {
    MBAPITypeFuzzySearch,
    MBAPITypeAutoCompletion,
    MBAPITypeBookCover,
    MBAPITypeBookDetail,
    MBAPITypeRecommendBook,
    MBAPITypeRecommendBookList,
    MBAPITypeBookReview,
    MBAPITypeAuthorAvatar,
    MBAPITypeBookSummary,
    MBAPITypeChaptersLink,
    MBAPITypeChapterContent,
    MBAPITypeBookUpdate,
    MBAPITypeRanking,
    MBAPITypeRankingDetial,
    MBAPITypeTagBookList,
    MBAPITypeAuthorBookList,
    MBAPITypeCatsList,
    MBAPITypeCatsSubList,
    MBAPITypeCatsBookList,
};

@interface MBURLManager : NSObject

+ (NSURL *)getURLWith:(MBAPIType)type parameter:(id)parameter;

@end
