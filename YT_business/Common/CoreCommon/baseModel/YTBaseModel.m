//
//  YTBaseModel.m
//  YTei
//
//  Created by yandi on 15/3/20.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTBaseModelProperty.h"

@interface YTBaseModel()
- (void)setupCachedKeyMapper;
- (void)setupCachedProperties;
@end


#pragma mark - NSArray+YTBaseModel
@interface NSArray (YTBaseModel)
- (NSArray *)modelArrayWithClass:(Class)modelClass;
@end

@implementation NSArray (YTBaseModel)
- (NSArray *)modelArrayWithClass:(Class)modelClass {
    NSMutableArray *modelArray = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [modelArray addObject:[object modelArrayWithClass:modelClass]];
        } else if ([object isKindOfClass:[NSDictionary class]]){
            [modelArray addObject:[[modelClass alloc] initWithJSONDict:object]];
        } else {
            [modelArray addObject:object];
        }
    }
    return modelArray;
}
@end

#pragma mark - NSDictionary+YTBaseModel
@interface NSDictionary (YTBaseModel)
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass;
@end

@implementation NSDictionary (YTBaseModel)
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass{
    NSMutableDictionary *modelDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            [modelDictionary setObject:[[modelClass alloc] initWithJSONDict:object] forKey:key];
        }else if ([object isKindOfClass:[NSArray class]]){
            [modelDictionary setObject:[object modelArrayWithClass:modelClass] forKey:key];
        }else{
            [modelDictionary setObject:object forKey:key];
        }
    }
    return modelDictionary;
}
@end


@implementation YTBaseModel
static const char *YTBaseModelKeyMapperKey;
static const char *YTBaseModelPropertiesKey;

#pragma mark -init
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupCachedKeyMapper];
        [self setupCachedProperties];
    }
    return self;
}

#pragma mark -initWithJSONDict
- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [self init];
    if (self) {
        [self injectJSONData:dict];
    }
    return self;
}

#pragma mark - MCBaseModel Configuration
- (void)setupCachedKeyMapper {
    if (objc_getAssociatedObject(self.class, &YTBaseModelKeyMapperKey) == nil) {
        NSDictionary *dict = [self modelKeyJSONKeyMapper];
        if (dict.count) {
            objc_setAssociatedObject(self.class, &YTBaseModelKeyMapperKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)setupCachedProperties{
    if (objc_getAssociatedObject(self.class, &YTBaseModelPropertiesKey) == nil) {
        NSMutableDictionary *propertyMap = [NSMutableDictionary dictionary];
        Class class = [self class];
        while (class != [NSObject class]) {
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++) {
                objc_property_t property = properties[i];
                const char *propertyName = property_getName(property);
                NSString *name = [NSString stringWithUTF8String:propertyName];
                const char *propertyAttrs = property_getAttributes(property);
                NSString *typeString = [NSString stringWithUTF8String:propertyAttrs];
                YTBaseModelProperty *modelProperty = [[YTBaseModelProperty alloc] initWithName:name typeString:typeString];
                if (!modelProperty.isReadonly) {
                    [propertyMap setValue:modelProperty forKey:modelProperty.name];
                }
            }
            free(properties);
            
            class = [class superclass];
        }
        objc_setAssociatedObject(self.class, &YTBaseModelPropertiesKey, propertyMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSDictionary *)modelKeyJSONKeyMapper{
    return @{};
}

#pragma mark -MCBaseModel RuntYTe Injection
- (void)injectJSONData:(id)dataObject {
    NSDictionary *keyMapper = objc_getAssociatedObject(self.class, &YTBaseModelKeyMapperKey);
    NSDictionary *properties = objc_getAssociatedObject(self.class, &YTBaseModelPropertiesKey);
    
    if ([dataObject isKindOfClass:[NSArray class]]) {
        YTBaseModelProperty *arrayProperty = nil;
        Class class = NULL;
        for (YTBaseModelProperty *property in [properties allValues]) {
            NSString *valueProtocol = [property.objectProtocols firstObject];
            class = NSClassFromString(valueProtocol);
            if ([valueProtocol isKindOfClass:[NSString class]] && [class isSubclassOfClass:[YTBaseModel class]]) {
                arrayProperty = property;
                break;
            }
        }
        if (arrayProperty && class) {
            id value = [(NSArray *)dataObject modelArrayWithClass:class];
            [self setValue:value forKey:arrayProperty.name];
        }
    } else if ([dataObject isKindOfClass:[NSDictionary class]]) {
        for (YTBaseModelProperty *property in [properties allValues]) {
            NSString *jsonKey = property.name;
            NSString *mapperKey = [keyMapper objectForKey:jsonKey];
            jsonKey = mapperKey ?: jsonKey;
            
            id jsonValue = [dataObject objectForKey:jsonKey];
            id propertyValue = [self valueForProperty:property withJSONValue:jsonValue];
            
            if (propertyValue) {
                [self setValue:propertyValue forKey:property.name];
            } else {
                id resetValue = (property.valueType == YTClassPropertyTypeObject) ? nil : @(0);
                [self setValue:resetValue forKey:property.name];
            }
        }
    }
}

- (id)valueForProperty:(YTBaseModelProperty *)property withJSONValue:(id)value{
    id resultValue = value;
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        resultValue = nil;
    } else {
        if (property.valueType != YTClassPropertyTypeObject) {
            
            if ([value isKindOfClass:[NSString class]]) {
                if (property.valueType == YTClassPropertyTypeInt ||
                    property.valueType == YTClassPropertyTypeUnsignedInt||
                    property.valueType == YTClassPropertyTypeShort||
                    property.valueType == YTClassPropertyTypeUnsignedShort) {
                    resultValue = [NSNumber numberWithInt:[(NSString *)value intValue]];
                }
                if (property.valueType == YTClassPropertyTypeLong ||
                    property.valueType == YTClassPropertyTypeUnsignedLong ||
                    property.valueType == YTClassPropertyTypeLongLong ||
                    property.valueType == YTClassPropertyTypeUnsignedLongLong){
                    resultValue = [NSNumber numberWithLongLong:[(NSString *)value longLongValue]];
                }
                if (property.valueType == YTClassPropertyTypeFloat) {
                    resultValue = [NSNumber numberWithFloat:[(NSString *)value floatValue]];
                }
                if (property.valueType == YTClassPropertyTypeDouble) {
                    resultValue = [NSNumber numberWithDouble:[(NSString *)value doubleValue]];
                }
                if (property.valueType == YTClassPropertyTypeChar) {
                    resultValue = [NSNumber numberWithBool:[(NSString *)value boolValue]];
                }
            }
        } else {
            Class valueClass = property.objectClass;
            if ([valueClass isSubclassOfClass:[YTBaseModel class]] &&
                [value isKindOfClass:[NSDictionary class]]) {
                resultValue = [[valueClass alloc] initWithJSONDict:value];
            }
            if ([valueClass isSubclassOfClass:[NSString class]] &&
                ![value isKindOfClass:[NSString class]]) {
                resultValue = [NSString stringWithFormat:@"%@",value];
            }
            if ([valueClass isSubclassOfClass:[NSNumber class]] &&
                [value isKindOfClass:[NSString class]]) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                resultValue = [numberFormatter numberFromString:value];
            }
            NSString *valueProtocol = [property.objectProtocols lastObject];
            if ([valueProtocol isKindOfClass:[NSString class]]) {
                Class valueProtocolClass = NSClassFromString(valueProtocol);
                if (valueProtocolClass != nil) {
                    if ([valueProtocolClass isSubclassOfClass:[YTBaseModel class]]) {
                        if ([value isKindOfClass:[NSArray class]]) {
                            resultValue = [(NSArray *)value modelArrayWithClass:valueProtocolClass];
                        }
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            resultValue = [(NSDictionary *)value modelDictionaryWithClass:valueProtocolClass];
                        }
                    }
                }
            }
        }
    }
    return resultValue;
}

@end

