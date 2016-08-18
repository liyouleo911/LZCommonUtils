//
//  BaseEntity.m
//  Pods
//
//  Created by Liyou on 16/8/18.
//
//

#import "BaseEntity.h"
#import <objc/runtime.h>

static const void *BEObjectiveTypsKeys = &BEObjectiveTypsKeys;
@implementation BaseEntity

#pragma mark - Private

+ (NSMutableDictionary *)objectivePropertyTypes:(Class)class {
    
    NSMutableDictionary *objectiveTypes = objc_getAssociatedObject(class, BEObjectiveTypsKeys);
    if (!objectiveTypes) {
        Class supperClass = class_getSuperclass(class);
        if (supperClass) {
            objectiveTypes = [self objectivePropertyTypes:supperClass];
            if (objectiveTypes) objectiveTypes = [objectiveTypes mutableCopy];
        }
        objectiveTypes = objectiveTypes ?: [NSMutableDictionary dictionary];
        objc_setAssociatedObject(class, BEObjectiveTypsKeys, objectiveTypes, OBJC_ASSOCIATION_RETAIN);
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(class, &outCount);
        for (i = 0; i < outCount; i++){
            objc_property_t p = properties[i];
            NSString* propertyType = [self getPropertyType:p];
            objectiveTypes[@(property_getName(p))] = propertyType;
        }
    }
    return objectiveTypes;
}

+ (NSString *)getPropertyType:(objc_property_t)property {
    
    if (!property) {
        return nil;
    }
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    NSData *propertyType = nil;
    while ((attribute = strsep(&state, ",")) != NULL){
        if (attribute[0] == 'T' && attribute[1] != '@') {
            propertyType = [NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1];
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            propertyType = [NSData dataWithBytes:"id" length:2];
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            propertyType = [NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4];
        }
    }
    
    return [[NSString alloc] initWithData:propertyType encoding:NSUTF8StringEncoding];
}

#pragma mark - validateStringProperty

+ (void)initialize {
    
    [super initialize];
    [self hydrateModelProperties:[self class] translateDictionary:nil];
}

+ (void)hydrateModelProperties:(Class)class translateDictionary:(NSMutableDictionary *)translateDictionary {
    
    if (!class || class == [NSObject class]){
        return;
    }
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++){
        objc_property_t p = properties[i];
        const char *name = property_getName(p);
        NSString *nsName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        NSString *lowerCaseName = [nsName lowercaseString];
        [translateDictionary setObject:nsName forKey:lowerCaseName];
        NSString *propertyType = [self getPropertyType:p];
        [self addValidatorForProperty:nsName type:propertyType];
    }
    free(properties);
    
    [self hydrateModelProperties:class_getSuperclass(class) translateDictionary:translateDictionary];
}

+ (void)addValidatorForProperty:(NSString *)propertyName type:(NSString *)propertyType {
    
    if ([propertyType isEqualToString:@"NSString"]) {
        NSString *methodName = [self generateValidationMethodName:propertyName];
        class_addMethod([self class], NSSelectorFromString(methodName), (IMP)validateStringProperty, "c@:^@^@");
    }
}

BOOL validateStringProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        return YES;
    } else if (*ioValue == nil) {
        *ioValue = @"";
        return YES;
    } else if ([*ioValue respondsToSelector:@selector(stringValue)]){
        *ioValue = [*ioValue stringValue];
        return YES;
    } else {
        return NO;
    }
}

+(NSString *)generateValidationMethodName:(NSString *)key{
    
    return [NSString stringWithFormat:@"validate%@:error:", [self capitalizeFirstCharacter:key]];
}

+ (NSString *)capitalizeFirstCharacter:(NSString *)string {
    
    NSString *firstCharacter = [[string substringToIndex:1] capitalizedString];
    NSString *cappedString = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstCharacter];
    return cappedString;
}

#pragma mark - MTLJSONSerializing

+ (NSMutableDictionary *)mutableKeyPathsByPropertyKey {
    NSArray *propertyKeys = [self propertyKeys].allObjects;
    return [NSMutableDictionary dictionaryWithObjects:propertyKeys forKeys:propertyKeys];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    NSString *type = [self objectivePropertyTypes:self][key];
    if (!type) {
        return nil;
    }
    
    if ([type isEqualToString:@"NSURL"]) {
        return [MTLJSONAdapter NSURLJSONTransformer];
    } else if ([type isEqualToString:@"NSString"]) {
        return [self stringValueTransformer];
    } else if ([type isEqualToString:@"NSNumber"]) {
        return [self numberValueTransformer];
    } else if ([type isEqualToString:@"NSDate"]) {
        return [self dateValueTransformer];
    } else if ([type isEqualToString:@"NSArray"]) {
        return [self arrayValueTransformer];
    } else if ([type isEqualToString:@"NSMutableArray"]) {
        return [self mutableArrayValueTransformer];
    } else if ([type isEqualToString:@"NSDictionary"]) {
        return [self dictValueTransformer];
    } else if ([type isEqualToString:@"NSMutableDictionary"]) {
        return [self mutableDictValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(BOOL)]]) {
        return [self booleanValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(int)]]) {
        return [self intValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(long)]]) {
        return [self longValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(long long)]]) {
        return [self longLongValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(float)]]) {
        return [self floatValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(double)]]) {
        return [self doubleValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(unsigned int)]]) {
        return [self unsignedIntValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(unsigned long)]]) {
        return [self unsignedLongValueTransformer];
    } else if ([type isEqualToString:[NSString stringWithFormat:@"%s", @encode(unsigned long long)]]) {
        return [self unsignedLongLongValueTransformer];
    } else if (NSClassFromString(type)) {
        return [MTLJSONAdapter dictionaryTransformerWithModelClass:(NSClassFromString(type))];
    }
    
    NSLog(@"Property \"%@\" of class \"%@\" doesn't have default value transformer", key, NSStringFromClass([self class]));
    return nil;
}

#pragma mark - EntityInitializer

+ (NSArray *)entitiesWithValue:(id)value {
    
    NSParameterAssert(value);
    if ([value isKindOfClass:[NSDictionary class]]) {
        return @[[[self class] entityWithDictionary:(NSDictionary *)value]];
    } else if ([value isKindOfClass:[NSArray class]]) {
        return [[self class] entitiesWithArray:(NSArray *)value];
    }
    
    return [NSArray array];
}

+ (NSArray *)entitiesWithArray:(NSArray *)array {
    
    NSParameterAssert([array isKindOfClass:[NSArray class]]);
    NSError *error = nil;
    NSArray *entities = [MTLJSONAdapter modelsOfClass:self.class fromJSONArray:array error:&error];
    if (error) {
        NSLog(@"Error (%@): %@", NSStringFromSelector(_cmd), error);
    }
    return entities;
}

+ (instancetype)entityWithDictionary:(NSDictionary *)dict {
    
    NSParameterAssert([dict isKindOfClass:[NSDictionary class]]);
    NSError *error = nil;
    id ret = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:dict error:&error];
    if (error) {
        NSLog(@"Error (%@): %@", NSStringFromSelector(_cmd), error);
    }
    return ret;
}

#pragma mark - EntitySerializer

- (NSDictionary *)serializationDictionary {
    
    NSError *error = nil;
    NSDictionary *ret = [MTLJSONAdapter JSONDictionaryFromModel:self error:&error];
    if (error) {
        NSLog(@"Error (%@): %@", NSStringFromSelector(_cmd), error);
    }
    return ret;
}

+ (NSArray *)serializationArrayWithModels:(NSArray *)models {
    
    NSError *error = nil;
    NSArray *ret = [MTLJSONAdapter JSONArrayFromModels:models error:&error];
    if (error) {
        NSLog(@"Error (%@): %@", NSStringFromSelector(_cmd), error);
    }
    return ret;
}

#pragma mark - EntityTransformer

+ (NSValueTransformer *)stringValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else if ([value respondsToSelector:@selector(stringValue)]) {
            return [value stringValue];
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSString) value", value);
        }
        return @"";
    }];
}

+ (NSValueTransformer *)numberValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }
        
        NSString *stringValue = @"0";
        if ([value isKindOfClass:[NSString class]]){
            stringValue = value;
        } else if ([value respondsToSelector:@selector(stringValue)]){
            stringValue = [value stringValue];
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber) value", value);
        }
        return [NSDecimalNumber decimalNumberWithString:stringValue];
    }];
}

+ (NSValueTransformer *)dateValueTransformer {
    static NSDateFormatter *dateFormatter;
    static NSDateFormatter *dateFormatterUTC;
    static dispatch_once_t onceToken;
    static dispatch_queue_t dateQueue;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatterUTC = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatterUTC setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        dateQueue = dispatch_queue_create("com.Oxen.datequeue", NULL);
    });
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]){
            if ([self respondsToSelector:@selector(dateValueTransformerWithInterval:)]) {
                return [self dateValueTransformerWithInterval:[value doubleValue]];
            } else {
                return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];  // 单位：秒
            }
        }

        NSString *stringDate;
        if ([value isKindOfClass:[NSString class]]){
            stringDate = value;
        } else if ([value respondsToSelector:@selector(stringValue)]) {
            stringDate = [value stringValue];
        }
        if (stringDate) {
            __block NSDate *date;
            dispatch_sync(dateQueue, ^{
                date = [dateFormatterUTC dateFromString:stringDate];
                if (date == nil) {
                    date = [dateFormatter dateFromString:stringDate];
                }
            });
            return date;
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSDate) value", value);
        }
        return nil;
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSDate class]]) {
            __block NSString *stringDate;
            dispatch_sync(dateQueue, ^{
                stringDate = [dateFormatterUTC stringFromDate:value];
            });
            return stringDate;
        }
        
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else if ([value respondsToSelector:@selector(stringValue)]) {
            return [value stringValue];
        }
        
        NSLog(@"%@ is not a (NSDate) value", value);
        return nil;
    }];
}

+ (NSDate *)dateValueTransformerWithInterval:(NSTimeInterval)interval {
    return [NSDate dateWithTimeIntervalSince1970:interval];  // 单位：秒
}

+ (NSValueTransformer *)arrayValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSArray class]]) {
            return value;
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSArray) value", value);
        }
        return nil;
    }];
}

+ (NSValueTransformer *)mutableArrayValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSMutableArray class]]) {
            return value;
        }
        
        if ([value isMemberOfClass:[NSArray class]]) {
            return [NSMutableArray arrayWithArray:value];
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSMutableArray) value", value);
        }
        return nil;
    }];
}

+ (NSValueTransformer *)dictValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            return value;
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSDictionary) value", value);
        }
        return nil;
    }];
}

+ (NSValueTransformer *)mutableDictValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSMutableDictionary class]]) {
            return value;
        }
        
        if ([value isMemberOfClass:[NSDictionary class]]) {
            return [NSMutableDictionary dictionaryWithDictionary:value];
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSMutableDictionary) dict value", value);
        }
        return nil;
    }];
}

+ (NSValueTransformer *)booleanValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return @([(NSNumber *)value boolValue]);
        }
        
        NSString *stringValue = @"NO";
        if ([value isKindOfClass:[NSString class]]) {
            stringValue = value;
        } else if ([value respondsToSelector:@selector(stringValue)]) {
            stringValue = [value stringValue];
        }
        
        if ([stringValue caseInsensitiveCompare:@"true"] == NSOrderedSame ||
            [stringValue caseInsensitiveCompare:@"yes"] == NSOrderedSame ||
            [stringValue caseInsensitiveCompare:@"y"] == NSOrderedSame ||
            [stringValue caseInsensitiveCompare:@"1"] == NSOrderedSame) {
            return @YES;
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - boolean) value", value);
        }
        return @NO;
    }];
}

+ (NSValueTransformer *)intValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value respondsToSelector:@selector(intValue)]) {
            return @([value intValue]);
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - int) value", value);
        }
        return @0;
    }];
}

+ (NSValueTransformer *)longValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value respondsToSelector:@selector(longValue)]) {
            return @([value longValue]);
        } else if ([value isKindOfClass:[NSString class]]) {
            // NSString无法响应longValue方法
            return [NSDecimalNumber decimalNumberWithString:value];
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - long) value", value);
        }
        return @0L;
    }];
}

+ (NSValueTransformer *)longLongValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value respondsToSelector:@selector(longLongValue)]) {
            return @([value longLongValue]);
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - long long) value", value);
        }
        return @0LL;
    }];
}

+ (NSValueTransformer *)floatValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value respondsToSelector:@selector(floatValue)]) {
            return @([value floatValue]);
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - float) value", value);
        }
        return @0.0;
    }];
}

+ (NSValueTransformer *)doubleValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value respondsToSelector:@selector(doubleValue)]) {
            return @([value doubleValue]);
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - double) value", value);
        }
        return @0.0;
    }];
}

+ (NSValueTransformer *)unsignedIntValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value respondsToSelector:@selector(unsignedIntValue)]) {
            return @([value unsignedIntValue]);
        }

        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - unsigned int) value", value);
        }
        return @0U;
    }];
}

+ (NSValueTransformer *)unsignedLongValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value respondsToSelector:@selector(unsignedLongValue)]) {
            return @([value unsignedLongValue]);
        } else if ([value isKindOfClass:[NSString class]]) {
            // NSString无法响应unsignedLongValue方法
            return [NSDecimalNumber decimalNumberWithString:value];
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - unsigned long) value", value);
        }
        return @0UL;
    }];
}

+ (NSValueTransformer *)unsignedLongLongValueTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value respondsToSelector:@selector(unsignedLongLongValue)]) {
            return @([value unsignedLongLongValue]);
        } else if ([value isKindOfClass:[NSString class]]) {
            // NSString无法响应unsignedLongLongValue方法
            return [NSDecimalNumber decimalNumberWithString:value];
        }
        
        if (value != nil) {
            NSLog(@"%@ is not a (NSNumber - unsigned long long) value", value);
        }
        return @0ULL;
    }];
}

@end
