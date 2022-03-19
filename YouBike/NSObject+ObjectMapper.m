//
//  NSObject+ObjectMapper.m
//  
//
//  Created by 龐達業 on 2022/3/13.
//

#import "NSObject+ObjectMapper.h"
#import "ObjectMapper.h"


@implementation NSObject (ObjectMapper)

- (instancetype)mapObjectWithDictionary:(id)dictionary {
    ObjectMapper *mapper = [ObjectMapper mapper];
    NSError *error;
    
    if ([dictionary isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[dictionary count]];
        
        for (id item in dictionary)
            [result addObject:[mapper mapObject:item toClass:[self class] withError:&error]];
        
        if (!error)
            return result;
    } else if ([dictionary isKindOfClass:[NSDictionary class]]) {
        id result = [mapper mapObject:dictionary toClass:[self class] withError:&error];
        
        if (!error)
            return result;
    }
    
    return nil;
}

@end
