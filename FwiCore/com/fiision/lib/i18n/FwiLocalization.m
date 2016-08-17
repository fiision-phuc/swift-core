#import "FwiLocalization.h"


@interface FwiLocalization () {
}


@end


@implementation FwiLocalization


static FwiLocalization *_SharedInstance = nil;


@synthesize locale=_locale;


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        _bundle = nil;
        _locale = nil;
        [self reset];
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    self.locale = nil;
    self.bundle = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties
- (NSString *)locale {
    return _locale;
}
- (void)setLocale:(NSString *)locale {
    FwiRelease(_locale);
    _locale = FwiRetain(locale);

    // Find path to specific locale
    __autoreleasing NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable"
                                                                     ofType:@"strings"
                                                                inDirectory:nil
                                                            forLocalization:locale];

    // Set new bundle
    if (!_locale || !path) {
        [self reset];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@[_locale] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.bundle = [NSBundle bundleWithPath:[path stringByDeletingLastPathComponent]];
    }
}


#pragma mark - Class's public methods
- (__autoreleasing NSString *)localizedForString:(NSString *)string alternative:(NSString *)alternative {
    return [self.bundle localizedStringForKey:string value:alternative table:nil];
}
- (void)reset {
    __autoreleasing NSArray *languages = [[NSBundle mainBundle] preferredLocalizations];
    if (languages.count > 0) {
        self.locale = languages[0];
    }
    else {
        self.locale = @"en";
    }
}


@end


@implementation FwiLocalization (FwiLocalizationCreation)


#pragma mark - Class's static constructors
+ (__weak FwiLocalization *)sharedInstance {
    /* Condition validation */
    if (_SharedInstance) return _SharedInstance;

    @synchronized (self) {
        if (!_SharedInstance) {
            _SharedInstance = [[self alloc] init];
            [_SharedInstance reset];
        }
    }
    return _SharedInstance;
}


@end
