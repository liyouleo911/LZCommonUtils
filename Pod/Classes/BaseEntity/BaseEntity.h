//
//  BaseEntity.h
//  Pods
//
//  Created by Liyou on 16/8/18.
//
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

/* 实体通用初始化器，将字典转换成实体 */
@protocol BaseEntityInitializer <NSObject>

+ (NSArray *)entitiesWithValue:(id)value;
+ (NSArray *)entitiesWithArray:(NSArray *)array;

+ (instancetype)entityWithDictionary:(NSDictionary *)dict;
@end

/* 实体通用序列化器，将实体转换成字典 */
@protocol BaseEntitySerializer <NSObject>

- (NSDictionary *)serializationDictionary;
+ (NSArray *)serializationArrayWithModels:(NSArray *)models;
@end

/* 实体通用转换器 */
@protocol BaseEntityTransformer <NSObject>

+ (NSValueTransformer *)stringValueTransformer;
+ (NSValueTransformer *)numberValueTransformer;
+ (NSValueTransformer *)dateValueTransformer;
+ (NSValueTransformer *)arrayValueTransformer;
+ (NSValueTransformer *)mutableArrayValueTransformer;
+ (NSValueTransformer *)dictValueTransformer;
+ (NSValueTransformer *)mutableDictValueTransformer;
+ (NSValueTransformer *)booleanValueTransformer;
+ (NSValueTransformer *)intValueTransformer;
+ (NSValueTransformer *)longValueTransformer;
+ (NSValueTransformer *)longLongValueTransformer;
+ (NSValueTransformer *)floatValueTransformer;
+ (NSValueTransformer *)doubleValueTransformer;
+ (NSValueTransformer *)unsignedIntValueTransformer;
+ (NSValueTransformer *)unsignedLongValueTransformer;
+ (NSValueTransformer *)unsignedLongLongValueTransformer;

@optional
/* 支持下发秒数转日期类型 */
+ (NSDate *)dateValueTransformerWithInterval:(NSTimeInterval)interval;
@end

@interface BaseEntity : MTLModel
<MTLJSONSerializing, BaseEntityInitializer, BaseEntitySerializer, BaseEntityTransformer>

+ (NSMutableDictionary *)mutableKeyPathsByPropertyKey;

@end
