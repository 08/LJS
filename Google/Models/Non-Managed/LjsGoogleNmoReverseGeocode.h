#import <Foundation/Foundation.h>

@class LjsLocation;

/**
 Documentation
 */
@interface LjsGoogleNmoReverseGeocode : NSObject 

/** @name Properties */

@property (nonatomic, strong) NSArray *types;
@property (nonatomic, copy) NSString *formattedAddress;
@property (nonatomic, strong) NSArray *addressComponents;
@property (nonatomic, strong) LjsLocation *location;
@property (nonatomic, copy) NSString *locationType;
@property (nonatomic, strong) NSDictionary *viewport;
@property (nonatomic, strong) NSDictionary *bounds;


/** @name Initializing Objects */
- (id) initWithDictionary:(NSDictionary *) aDictionary;
/** @name Handling Notifications, Requests, and Events */

/** @name Utility */

@end
