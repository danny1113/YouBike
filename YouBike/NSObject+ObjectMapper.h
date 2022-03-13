//
//  NSObject+ObjectMapper.h
//  
//
//  Created by 龐達業 on 2022/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ObjectMapper)

- (instancetype)mapObjectWithDictionary:(id)dictionary;

@end

NS_ASSUME_NONNULL_END
