#import <MAMapKit/MAMapKit.h>

@class AMapMarker;

@interface AMapView : MAMapView

@property(nonatomic, copy) RCTBubblingEventBlock onLocation;
@property(nonatomic, copy) RCTBubblingEventBlock onClick;
@property(nonatomic, copy) RCTBubblingEventBlock onLongClick;
@property(nonatomic, copy) RCTBubblingEventBlock onStatusChange;
@property(nonatomic, copy) RCTBubblingEventBlock onStatusChangeComplete;

@property(nonatomic) BOOL loaded;
@property(nonatomic) MACoordinateRegion initialRegion;

- (AMapMarker *)getMarker:(id <MAAnnotation>)annotation;

@end
