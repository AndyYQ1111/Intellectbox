//
//  GetLocalization.m
//  IntelligentBox
//
//  Created by zhihui liang on 2017/11/29.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import "GetLocalization.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface GetLocalization()<CLLocationManagerDelegate>{
    
    
}
@property(nonatomic,strong) CLLocationManager *locationMgr;

@end

@implementation GetLocalization

+(instancetype)sharedInstance{
    
    static GetLocalization *gMe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gMe = [[GetLocalization alloc] init];
    });
    
    return gMe;
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _locationMgr = [[CLLocationManager alloc] init];
        _locationMgr.delegate = self;
        _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationMgr requestWhenInUseAuthorization];//添加这句
        
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        }
    }
    return self;
}

-(void)startUpdateLocalization:(GetLocalizate )result{
    
    self.localBlock = result;
    [_locationMgr startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:locations[0] completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];

             //将获得的所有信息显示到label上
             NSLog(@"placemark.name=%@",placemark.name);
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             NSLog(@"city = %@", city);
             if (self.localBlock) {
                 self.localBlock(city);
                 self.localBlock = nil;
             }
             
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];

    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"无法获取位置信息");
    }
}

@end
