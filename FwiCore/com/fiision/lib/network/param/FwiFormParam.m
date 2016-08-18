#import "FwiFormParam.h"





@implementation FwiFormParam


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        self.key   = nil;
        self.value = nil;
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    self.key   = nil;
    self.value = nil;

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's override methods
- (BOOL)isEqual:(id)object {
	if (object && [object isKindOfClass:[FwiFormParam class]]) {
        FwiFormParam *other = (FwiFormParam *)object;
        return ([_key isEqualToString:other.key] && [_value isEqualToString:other.value]);
	}
	return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@=%@", _key, [_value encodeHTML]];
}


#pragma mark - Class's public methods
- (NSComparisonResult)compare:(FwiFormParam *)parameter {
    /* Condition validation */
    if (!parameter) return NSOrderedDescending;
    else return [_key compare:parameter.key];
}


#pragma mark - NSCoding's members
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self && aDecoder) {
        _key   = FwiRetain([aDecoder decodeObjectForKey:@"_key"]);
        _value = FwiRetain([aDecoder decodeObjectForKey:@"_value"]);
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (!aCoder) return;
    [aCoder encodeObject:_key forKey:@"_key"];
    [aCoder encodeObject:_value forKey:@"_value"];
}


@end


@implementation FwiFormParam (FwiFormParamCreation)


#pragma mark - Class's static constructors
+ (__autoreleasing FwiFormParam *)paramWithKey:(NSString *)key andValue:(NSString *)value {
    /* Condition validation */
    if (!key || key.length == 0) return nil;
    else return FwiAutoRelease([[FwiFormParam alloc] initWithKey:key andValue:(value ? value : @"")]);
}


#pragma mark - Class's constructors
- (id)initWithKey:(NSString *)key andValue:(NSString *)value {
    self = [self init];
    if (self) {
        self.key = key;
        self.value = value;
    }
    return self;
}


@end
