#import "FwiRequest.h"
#import "FwiDataParam.h"
#import "FwiFormParam.h"
#import "FwiMultipartParam.h"


#define kHTTP_Copy      @"COPY";
#define kHTTP_Delete    @"DELETE";
#define kHTTP_Get       @"GET";
#define kHTTP_Link      @"LINK";
#define kHTTP_Head      @"HEAD";
#define kHTTP_Options   @"OPTIONS";
#define kHTTP_Patch     @"PATCH";
#define kHTTP_Post      @"POST";
#define kHTTP_Purge     @"PURGE";
#define kHTTP_Put       @"PUT";
#define kHTTP_Unlink    @"UNLINK";


static inline NSString* FwiGenerateUserAgent() {
    __autoreleasing NSDictionary *bundleInfo   = [[NSBundle mainBundle] infoDictionary];
    __autoreleasing UIDevice *deviceInfo       = [UIDevice currentDevice];
    __autoreleasing NSString *bundleExecutable = [bundleInfo objectForKey:(NSString *)kCFBundleExecutableKey];
    __autoreleasing NSString *bundleIdentifier = [bundleInfo objectForKey:(NSString *)kCFBundleIdentifierKey];
    __autoreleasing NSString *bundleVersion    = [bundleInfo objectForKey:(NSString *)kCFBundleVersionKey];
    __autoreleasing NSString *systemVersion    = [deviceInfo systemVersion];
    __autoreleasing NSString *model            = [deviceInfo model];
    
    // Define user-agent
    return [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", (bundleExecutable ? bundleExecutable : bundleIdentifier), bundleVersion, model, systemVersion, [[UIScreen mainScreen] scale]];
}


@interface FwiRequest () {

    // Request type
    FwiHttpMethod    _type;

    // Raw request
    FwiDataParam *_raw;
    // Form request
    NSMutableArray   *_form;
    NSMutableArray   *_upload;
}

@property (nonatomic, strong) FwiDataParam *raw;
@property (nonatomic, strong) NSMutableArray *form;
@property (nonatomic, strong) NSMutableArray *upload;


/** Class's constructors. */
- (id)initWithURL:(NSURL *)url methodType:(FwiHttpMethod)type;


/** Initialize form & upload. */
- (void)_initForm;
- (void)_initUpload;

/** Add form parameter. */
- (void)_addFormParam:(FwiFormParam *)param;

/** Add multipart parameter. */
- (void)_addMultipartParam:(FwiMultipartParam *)param;

@end


@implementation FwiRequest


#pragma mark - Class's constructors
- (id)initWithURL:(NSURL *)url methodType:(FwiHttpMethod)type {
    self = [super initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    if (self) {
        _type = type;
        _raw = nil;
        _form = nil;
        _upload = nil;
        
        // Assign HTTP Method
        switch (_type) {
            case kCopy: {
                self.HTTPMethod = kHTTP_Copy;
                break;
            }
            case kDelete: {
                self.HTTPMethod = kHTTP_Delete;
                break;
            }
            case kHead: {
                self.HTTPMethod = kHTTP_Head;
                break;
            }
            case kLink: {
                self.HTTPMethod = kHTTP_Link;
                break;
            }
            case kOptions: {
                self.HTTPMethod = kHTTP_Options;
                break;
            }
            case kPatch: {
                self.HTTPMethod = kHTTP_Patch;
                break;
            }
            case kPost: {
                self.HTTPMethod = kHTTP_Post;
                break;
            }
            case kPurge: {
                self.HTTPMethod = kHTTP_Purge;
                break;
            }
            case kPut: {
                self.HTTPMethod = kHTTP_Put;
                break;
            }
            case kUnlink: {
                self.HTTPMethod = kHTTP_Unlink;
                break;
            }
            case kGet:
            default: {
                self.HTTPMethod = kHTTP_Get;
                break;
            }
        }
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    self.raw    = nil;
    self.form   = nil;
    self.upload = nil;

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (size_t)prepare {
    __autoreleasing NSDictionary *allHeaders = [self allHTTPHeaderFields];
    if (!allHeaders[@"Accept"]) [self setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    if (!allHeaders[@"Accept-Encoding"]) [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    if (!allHeaders[@"Accept-Charset"]) [self setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset"];
    if (!allHeaders[@"Connection"]) [self setValue:@"close" forHTTPHeaderField:@"Connection"];
    if (!allHeaders[@"User-Agent"]) [self setValue:FwiGenerateUserAgent() forHTTPHeaderField:@"User-Agent"];

    /* Condition validation */
    if (!_raw && _form.count == 0 && _upload.count == 0) return 0;
    size_t length = 0;

    if (_raw) {
        length = [_raw.data length];
        [self setHTTPBody:_raw.data];
        [self setValue:_raw.contentType forHTTPHeaderField:@"Content-Type"];
        [self setValue:[NSString stringWithFormat:@"%zu", length] forHTTPHeaderField:@"Content-Length"];
    }
    else {
        switch (_type) {
            case kPatch:
            case kPost:
            case kPut: {
                if (_form && !_upload) {
                    __autoreleasing NSData *encodedData = [[_form componentsJoinedByString:@"&"] toData];

                    length = [encodedData length];
                    [self setHTTPBody:encodedData];
                    [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                    [self setValue:[NSString stringWithFormat:@"%zu", length] forHTTPHeaderField:@"Content-Length"];
                }
                else {
                    // Define boundary
                    __unsafe_unretained __block NSString *boundary = [NSString stringWithFormat:@"--------%li", (unsigned long) [[NSDate date] timeIntervalSince1970]];
                    __autoreleasing NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];

                    // Define body
                    __unsafe_unretained __block NSMutableData *body = [NSMutableData data];
                    
                    [_form enumerateObjectsUsingBlock:^(FwiFormParam *pair, NSUInteger idx __attribute__((unused)), BOOL *stop __attribute__((unused))) {
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] toData]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", pair.key] toData]];
                        [body appendData:[pair.value toData]];
                    }];
                    [_upload enumerateObjectsUsingBlock:^(FwiMultipartParam *part, NSUInteger idx __attribute__((unused)), BOOL *stop __attribute__((unused))) {
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] toData]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", part.name, part.fileName] toData]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", part.contentType] toData]];
                        [body appendData:part.data];
                    }];
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] toData]];

                    length = [body length];
                    [self setHTTPBody:body];
                    [self setValue:contentType forHTTPHeaderField:@"Content-Type"];
                    [self setValue:[NSString stringWithFormat:@"%zu", length] forHTTPHeaderField:@"Content-Length"];
                }
                break;
            }
            case kDelete:
            case kGet:
            default: {
                __autoreleasing NSString *finalURL = [NSString stringWithFormat:@"%@?%@", self.URL.absoluteString, [_form componentsJoinedByString:@"&"]];
                self.URL = [NSURL URLWithString:finalURL];
                break;
            }
        }
    }
    return length;
}


#pragma mark - Class's private methods
- (void)_initForm {
    /* Condition validation */
    if (_form) return;
    _form = [[NSMutableArray alloc] initWithCapacity:9];
}
- (void)_initUpload {
    /* Condition validation */
    if (_upload) return;
    _upload = [[NSMutableArray alloc] initWithCapacity:1];
}

- (void)_addFormParam:(FwiFormParam *)param {
    /* Condition validation */
    if (![param isMemberOfClass:[FwiFormParam class]] || [_form containsObject:param]) return;
    [_form addObject:param];
}

- (void)_addMultipartParam:(FwiMultipartParam *)param {
    /* Condition validation */
    if (![param isMemberOfClass:[FwiMultipartParam class]] || [_upload containsObject:param]) return;
    [_upload addObject:param];
}


@end


@implementation FwiRequest (FwiRequestCreation)


#pragma mark - Class's static constructors
+ (__autoreleasing FwiRequest *)requestWithURL:(NSURL *)url methodType:(FwiHttpMethod)type {
    return FwiAutoRelease([[FwiRequest alloc] initWithURL:url methodType:type]);
}


@end


@implementation FwiRequest (FwiForm)


- (void)setFormParam:(FwiFormParam *)param {
    if (!_form) [self _initForm];
    else [_form removeAllObjects];
    FwiRelease(_raw);
    
    [self _addFormParam:param];
}
- (void)setFormParams:(NSArray *)params {
    if (!_form) [self _initForm];
    else [_form removeAllObjects];
    FwiRelease(_raw);
    
    [params enumerateObjectsUsingBlock:^(FwiFormParam *param, NSUInteger idx __attribute__((unused)), BOOL *stop __attribute__((unused))) {
        [self _addFormParam:param];
    }];
}
- (void)addFormParam:(FwiFormParam *)param {
    if (!_form) [self _initForm];
    FwiRelease(_raw);
    
    [self _addFormParam:param];
}
- (void)addFormParams:(NSArray *)params {
    if (!_form) [self _initForm];
    FwiRelease(_raw);
    
    [params enumerateObjectsUsingBlock:^(FwiFormParam *param, NSUInteger idx __attribute__((unused)), BOOL *stop __attribute__((unused))) {
        [self _addFormParam:param];
    }];
}

- (void)setMultipartParam:(FwiMultipartParam *)param {
    if (!_upload) [self _initUpload];
    else [_upload removeAllObjects];
    FwiRelease(_raw);
    
    [self _addMultipartParam:param];
}
- (void)setMultipartParams:(NSArray *)params {
    if (!_upload) [self _initUpload];
    else [_upload removeAllObjects];
    FwiRelease(_raw);
    
    [params enumerateObjectsUsingBlock:^(FwiMultipartParam *param, NSUInteger idx __attribute__((unused)), BOOL *stop __attribute__((unused))) {
        [self _addMultipartParam:param];
    }];
}
- (void)addMultipartParam:(FwiMultipartParam *)param {
    if (!_upload) [self _initUpload];
    FwiRelease(_raw);
    
    [self _addMultipartParam:param];
}
- (void)addMultipartParams:(NSArray *)params {
    if (!_upload) [self _initUpload];
    FwiRelease(_raw);
    
    [params enumerateObjectsUsingBlock:^(FwiMultipartParam *param, NSUInteger idx __attribute__((unused)), BOOL *stop __attribute__((unused))) {
        [self _addMultipartParam:param];
    }];
}


@end


@implementation FwiRequest (FwiRaw)


- (void)setDataParameter:(FwiDataParam *)parameter {
    /* Condition validation: Validate method type */
    if (!(_type == kPost || _type == kPatch || _type == kPut) || !parameter) return;

    // Release form
    FwiRelease(_form);
    FwiRelease(_upload);

    // Keep new raw
    FwiRelease(_raw);
    _raw = FwiRetain(parameter);
}


@end
