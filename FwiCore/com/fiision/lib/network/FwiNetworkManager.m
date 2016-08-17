#import "FwiNetworkManager.h"


@interface FwiNetworkManager () {

    NSUInteger _counter;
}


/** Handle network error status. */
//- (void)_handleError:(NSError *)error errorMessage:(FwiJson *)errorMessage statusCode:(FwiNetworkStatus)statusCode;

@end


@implementation FwiNetworkManager


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        // Default configuration
        _configuration = FwiRetain([NSURLSessionConfiguration defaultSessionConfiguration]);
        _configuration.allowsCellularAccess = YES;
        _configuration.timeoutIntervalForRequest = 60.0f;
        _configuration.timeoutIntervalForResource = 60.0f;
        _configuration.networkServiceType = NSURLNetworkServiceTypeBackground;
        
        // Cache configuration
        _configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
        _configuration.URLCache = [NSURLCache sharedURLCache];
        _cache = [NSURLCache sharedURLCache];
        
        _session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:[FwiOperation operationQueue]];
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    FwiRelease(_configuration);
    FwiRelease(_session);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (__autoreleasing NSURLRequest *)prepareRequestWithURL:(NSURL *)url method:(FwiHttpMethod)method {
    return [FwiRequest requestWithURL:url methodType:method];
}
- (__autoreleasing NSURLRequest *)prepareRequestWithURL:(NSURL *)url method:(FwiHttpMethod)method params:(NSDictionary *)params {
    FwiRequest *request = [FwiRequest requestWithURL:url methodType:method];

    // Insert data parameters if available
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, __unused BOOL *stop) {
        [request addFormParam:[FwiFormParam paramWithKey:key andValue:value]];
    }];
    return request;
}

- (void)sendRequest:(NSURLRequest *)request completion:(void(^)(NSData *data, NSError *error, NSInteger statusCode, NSHTTPURLResponse *response))completion {
    if ([request isKindOfClass:[FwiRequest class]]) {
        __weak FwiRequest *customRequest = (FwiRequest *)request;
        [customRequest prepare];
    }
    
    // Check cache if there is any
    __block NSCachedURLResponse *cached = [_cache cachedResponseForRequest:request];
    __weak NSHTTPURLResponse *cachedResponse = (NSHTTPURLResponse *) cached.response;
    
    if (cachedResponse && cachedResponse.allHeaderFields[@"Date"] && [request isKindOfClass:[FwiRequest class]]) {
        __weak FwiRequest *r = (FwiRequest *) request;
        [r setValue:cachedResponse.allHeaderFields[@"Date"] forHTTPHeaderField:@"If-Modified-Since"];
    }

    // Turn on network activity indicator
    @synchronized(self) {
        _counter++;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    __autoreleasing NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = kNone;
        __weak NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        // Validate http status
        if (error) {
            statusCode = error.code;
        }
        else if (response) {
            statusCode = httpResponse.statusCode;

            if (!FwiNetworkStatusIsSuccces(statusCode)) {
                error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:@{NSURLErrorFailingURLErrorKey:[request.URL description], NSURLErrorFailingURLStringErrorKey:[request.URL description], NSLocalizedDescriptionKey:[NSHTTPURLResponse localizedStringForStatusCode:statusCode]}];
            }
            else {
                // Should we cache this request or not
                __autoreleasing NSString *cacheControl = [httpResponse.allHeaderFields[@"Cache-Control"] lowercaseString];
                if (statusCode != 304 && cacheControl && [cacheControl hasPrefix:@"public"]) {
                    // Remove previous cache, remove it anyways
//                    [_cache removeCachedResponseForRequest:request];

                    // Generate new cache
                    __autoreleasing NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                    [_cache storeCachedResponse:cachedResponse forRequest:request];
                }
            }
        }

        // Console log error
        if (error) {
            __autoreleasing NSMutableString *errorMessage = [NSMutableString string];
            [errorMessage appendFormat:@"Domain     : %@\n", request.URL.host];
            [errorMessage appendFormat:@"HTTP Url   : %@\n", request.URL];
            [errorMessage appendFormat:@"HTTP Method: %@\n", request.HTTPMethod];
            [errorMessage appendFormat:@"HTTP Status: %li (%@)\n", (unsigned long) statusCode, error.localizedDescription];
            [errorMessage appendFormat:@"%@", [data toString]];

            NSLog(@"\n\n%@\n\n", errorMessage);
        }
        
        // Turn off activity indicator if neccessary
        @synchronized(self) {
            _counter--;
            if (_counter == 0) [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        // Load cache if http status is 304 or offline
        if (cached && (statusCode == kNotConnectedToInternet || statusCode == 304)) {
            if (completion) completion(cached.data, nil, cachedResponse.statusCode, cachedResponse);
            cached = nil;
            return;
        }

        // Return result
        if (completion) completion(data, error, statusCode, httpResponse);
    }];
    [task resume];
}
- (void)downloadResource:(NSURLRequest *)request completion:(void(^)(NSURL *location, NSError *error, NSInteger statusCode, NSHTTPURLResponse *response))completion {
    if ([request isKindOfClass:[FwiRequest class]]) {
        __weak FwiRequest *customRequest = (FwiRequest *)request;
        [customRequest prepare];
    }
    
    // Turn on network activity indicator
    @synchronized(self) {
        _counter++;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    __autoreleasing NSURLSessionDownloadTask *task = [_session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = kNone;
        __weak NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        // Validate http status
        if (error) {
            statusCode = error.code;
        }
        else if (response) {
            statusCode = httpResponse.statusCode;
            
            if (!FwiNetworkStatusIsSuccces(statusCode)) {
                error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:@{NSURLErrorFailingURLErrorKey:[request.URL description], NSURLErrorFailingURLStringErrorKey:[request.URL description], NSLocalizedDescriptionKey:[NSHTTPURLResponse localizedStringForStatusCode:statusCode]}];
            }
        }
        
        // Console log error
        if (error) {
            __autoreleasing NSMutableString *errorMessage = [NSMutableString string];
            [errorMessage appendFormat:@"Domain     : %@\n", request.URL.host];
            [errorMessage appendFormat:@"HTTP Url   : %@\n", request.URL];
            [errorMessage appendFormat:@"HTTP Method: %@\n", request.HTTPMethod];
            [errorMessage appendFormat:@"HTTP Status: %li (%@)\n", (unsigned long) statusCode, error.localizedDescription];
            [errorMessage appendFormat:@"%@", [location path]];
            
            NSLog(@"\n\n%@\n\n", errorMessage);
        }
        
        // Turn off activity indicator if neccessary
        @synchronized(self) {
            _counter--;
            if (_counter == 0) [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        // Return result
        if (completion) completion(location, error, statusCode, httpResponse);
    }];
    [task resume];
}

- (void)cancelTasks {
    [_session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if (!dataTasks || !dataTasks.count) {
            return;
        }
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}


#pragma mark - Class's private methods
//- (void)_handleError:(NSError *)error errorMessage:(FwiJson *)errorMessage statusCode:(FwiNetworkStatus)statusCode {
//    
//    
//    switch ((NSUInteger) statusCode) {
//        case 400:
//        case 401: {
////            if (errorMessage && ![[errorMessage jsonWithPath:@"title"] isLike:[FwiJson null]] && [[[errorMessage jsonWithPath:@"title"] getString] isEqualToString:kText_Expired] ) {
////                NSString *title = [[errorMessage jsonWithPath:@"title"] getString];
////                if ([title isEqualToString:kText_Expired]) {
////                    [kAppDelegate presentAlertWithTitle:kText_Info message:kText_RenewSubscription delegate:self tag:ALERT_TAG btnCancel:kText_No btnConfirm:kText_Yes];
////                    [kAppController dismissBusyWithCompletion:nil];
////                }
////            }
////            else {
////                if (errorMessage && ![[errorMessage jsonWithPath:@"detail"] isLike:[FwiJson null]]) {
////                    [kAppDelegate presentAlertWithTitle:kText_Warning message:[[errorMessage jsonWithPath:@"detail"] getString]];
////                }
////                else {
////                    [kAppDelegate presentAlertWithTitle:kText_Warning message:@"Unauthorized access."];
////                }
////            }
//            break;
//        }
//        case 402: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Payment Required: %@", detail]];
//            break;
//        }
//        case 403: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Forbidden: %@", detail]];
//            break;
//        }
//        case 404: {
////            NSString *title  = kText_Warning;
////            NSString *detail = @"Resource is not available.";
////            
////            if (errorMessage && ![[errorMessage jsonWithPath:@"detail"] isLike:[FwiJson null]]) {
////                detail = [[errorMessage jsonWithPath:@"detail"] getString];
////            }
////            if (errorMessage && ![[errorMessage jsonWithPath:@"title"] isLike:[FwiJson null]]) {
////                title = [[errorMessage jsonWithPath:@"title"] getString];
////            }
////            [kAppDelegate presentAlertWithTitle:title message:detail];
//            //                    [kAppDelegate presentAlertWithTitle:kText_Warning message:@"Resource is not available."];
//            break;
//        }
//        case 405: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Method Not Allowed: %@", detail]];
//            break;
//        }
//        case 406: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Not Acceptable: %@", detail]];
//            break;
//        }
//        case 407: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Proxy Authentication Required: %@", detail]];
//            break;
//        }
//        case 408: {
////            [kAppDelegate presentAlertWithTitle:kText_Warning message:@"Server is busy at the moment."];
//            break;
//        }
//        case 409: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Conflict: %@", detail]];
//            break;
//        }
//        case 410: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Gone: %@", detail]];
//            break;
//        }
//        case 411: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Length Required: %@", detail]];
//            break;
//        }
//        case 412: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Precondition Failed: %@", detail]];
//            break;
//        }
//        case 413: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Request Entity Too Large: %@", detail]];
//            break;
//        }
//        case 414: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Request-URI Too Large: %@", detail]];
//            break;
//        }
//        case 415: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Unsupported Media Type: %@", detail]];
//            break;
//        }
//        case 416: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Requested range not satisfiable: %@", detail]];
//            break;
//        }
//        case 417: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Expectation Failed: %@", detail]];
//            break;
//        }
//        case 418: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"I'm a teapot: %@", detail]];
//            break;
//        }
//        case 422: {
////            __block NSString *title  = nil;
////            __block NSString *detail = nil;
////            
////            if (![[errorMessage jsonWithPath:@"validation_messages"] isLike:[FwiJson null]]) {
////                FwiJson *validation = [errorMessage jsonWithPath:@"validation_messages"];
////                title = [[errorMessage jsonWithPath:@"detail"] getString];
////                
////                [validation enumerateKeysAndObjectsUsingBlock:^(NSString *key, FwiJson *json, BOOL *stop) {
////                    *stop  = YES;
////                    detail = ([json isLike:[FwiJson object]] ? [[json jsonAtIndex:0] getString] : [json getString]);
////                }];
////            }
////            else {
////                title  = [[errorMessage jsonWithPath:@"title"] getString];
////                detail = [[errorMessage jsonWithPath:@"detail"] getString];
////            }
////            
////            [kAppDelegate presentAlertWithTitle:title message:detail];
//            break;
//        }
//        case 423: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Locked: %@", detail]];
//            break;
//        }
//        case 424: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Failed Dependency: %@", detail]];
//            break;
//        }
//        case 425: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Unordered Collection: %@", detail]];
//            break;
//        }
//        case 426: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Upgrade Required: %@", detail]];
//            break;
//        }
//        case 428: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Precondition Required: %@", detail]];
//            break;
//        }
//        case 429: {
////            [kAppDelegate presentAlertWithTitle:kText_Warning message:@"Server is busy at the moment."];
//            break;
//        }
//        case 431: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Request Header Fields Too Large: %@", detail]];
//            break;
//        }
//        case 500: {
////            [kAppDelegate presentAlertWithTitle:kText_Warning message:@"Server is busy at the moment."];
//            break;
//        }
//        case 501: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Not Implemented: %@", detail]];
//            break;
//        }
//        case 502: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Bad Gateway: %@", detail]];
//            break;
//        }
//        case 503: {
////            [kAppDelegate presentAlertWithTitle:kText_Warning message:@"This service is not available at the moment."];
//            break;
//        }
//        case 504: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Gateway Time-out: %@", detail]];
//            break;
//        }
//        case 505: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"HTTP Version not supported: %@", detail]];
//            break;
//        }
//        case 506: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Variant Also Negotiates: %@", detail]];
//            break;
//        }
//        case 507: {
////            [kAppDelegate presentAlertWithTitle:kText_Warning message:@"Uploaded file had been rejected by server."];
//            break;
//        }
//        case 508: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Loop Detected: %@", detail]];
//            break;
//        }
//        case 511: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Network Authentication Required: %@", detail]];
//            break;
//        }
////        case kNetworkStatus_CannotConnectToHost:
//        default:
////            [kAppDelegate presentAlertWithTitle:kText_Warning message:@"Could not connect to server at the moment."];
//            break;
//    }
//}


#pragma mark - NSURLSessionDelegate's members
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
//        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
//
//        // Verify certificate
//        __autoreleasing NSData *crtData = (NSData *)CFBridgingRelease(SecCertificateCopyData(certificate));
////        __autoreleasing NSArray *paths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"cer" inDirectory:@"."];
////
////        // Load all accepted certificates
////        __autoreleasing NSMutableArray *crts = [NSMutableArray arrayWithCapacity:paths.count];
////        for (NSString *path in paths) {
////            __autoreleasing NSData *data = [NSData dataWithContentsOfFile:path];
////            [crts addObject:data];
////        }
////
////        // Validate the received certificate
////        if ([crts containsObject:crtData]) {
////            __autoreleasing NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
////            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
////        }
////        else {
//        __autoreleasing FwiDer *cert = [crtData decodeDer];
//        __autoreleasing NSDate *today = [NSDate date];
//
//        FwiDer *issuer = [cert derWithPath:@"0/3"];
//        FwiDer *subject = [cert derWithPath:@"0/5"];
//        NSUInteger version = [[cert derWithPath:@"0/0/0"] getInt];
//        NSDate *notBefor = [[cert derWithPath:@"0/4/0"] getTime];
//        NSDate *notAfter = [[cert derWithPath:@"0/4/1"] getTime];
//
//        /* Condition validation */
//        if (version != 2) {
//            if (completionHandler) completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//            return;
//        }
//        if (!issuer || !subject) {
//            if (completionHandler) completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//            return;
//        }
//        if (!notBefor || !notAfter || !(([today compare:notBefor] >= 0 && [today compare:notAfter] < 0))) {
//            if (completionHandler) completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//            return;
//        }
//
////            BOOL shouldAllow = NO;
////            if (self.delegate && [self.delegate respondsToSelector:@selector(service:authenticationChallenge:)])
////                shouldAllow = [(id<FwiServiceDelegate>)self.delegate service:self authenticationChallenge:certificate];
//
////            if (!shouldAllow) {
////                [[challenge sender] cancelAuthenticationChallenge:challenge];
////                if (completionHandler) completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
////            }
////            else {
        __autoreleasing NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
        if (completionHandler) completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
////            }
////        }
    }
    else {
        if (completionHandler) completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}


#pragma mark - NSURLSessionTaskDelegate's members
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {
    if (completionHandler) completionHandler(request);
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler {
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    DLog(@"");
}


#pragma mark - NSURLSessionDataDelegate's members
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    DLog(@"%@", proposedResponse);
}


@end


@implementation FwiNetworkManager (FwiNetworkManagerSingleton)


static FwiNetworkManager *_NetworkManager;


#pragma mark - Environment initialize
+ (void)initialize {
    _NetworkManager = nil;
}


#pragma mark - Class's static constructors
+ (__weak FwiNetworkManager *)sharedInstance {
    if (_NetworkManager) return _NetworkManager;
    
    @synchronized (self) {
        if (!_NetworkManager) _NetworkManager = [[FwiNetworkManager alloc] init];
    }
    return _NetworkManager;
}


@end
