# XTReq
* GET/POST
* 请求缓存


cocoapods
```
pod 'Masonry'
pod 'AFNetworking'
pod ‘YYModel’
pod ‘FMDB’
pod 'SVProgressHUD'
```

* 使用方式
#import "XTReq.h"
* 若需要缓存. 需要在APPdelegate注册并启动XTFMDB

XTRequest
```

@interface XTRequest : NSObject

// set URL string with base url
+ (NSString *)getFinalUrl:(NSString *)strPartOfUrl ;
// get url format baseurl?param1&param2&param3...
+ (NSString *)fullUrl:(NSString *)url
                param:(NSDictionary *)param ;
// param
+ (NSMutableDictionary *)getParameters ;

// status
+ (void)netWorkStatus ;
+ (void)netWorkStatus:(void (^)(NSInteger status))block ;

// async
+ (void)GETWithUrl:(NSString *)url
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail ;

+ (void)GETWithUrl:(NSString *)url
               hud:(BOOL)hud
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail ;

+ (void)GETWithUrl:(NSString *)url
               hud:(BOOL)hud
        parameters:(NSDictionary *)dict
       taskSuccess:(void (^)(NSURLSessionDataTask * task ,id json))success
              fail:(void (^)())fail ;

+ (void)POSTWithUrl:(NSString *)url
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail ;

+ (void)POSTWithUrl:(NSString *)url
                hud:(BOOL)hud
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail ;

+ (void)POSTWithUrl:(NSString *)url
                hud:(BOOL)hud
         parameters:(NSDictionary *)dict
        taskSuccess:(void (^)(NSURLSessionDataTask * task ,id json))success
               fail:(void (^)())fail ;

/**
sync
Must be in the asynchronous thread , or the main thread will getting stuck .
*/
+ (id)syncGetWithUrl:(NSString *)url
parameters:(NSDictionary *)dict ;

+ (id)syncPostWithUrl:(NSString *)url
parameters:(NSDictionary *)dict ;

@end

```


XTCacheRequest
```

@interface XTCacheRequest : XTRequest

+ (void)cacheGET:(NSString *)url
      parameters:(NSDictionary *)param
      completion:(void (^)(id json))completion ;

+ (void)cacheGET:(NSString *)url
      parameters:(NSDictionary *)param
          policy:(XTResponseCachePolicy)cachePolicy
   timeoutIfNeed:(int)timeoutIfNeed
      completion:(void (^)(id json))completion ;

+ (void)cacheGET:(NSString *)url
      parameters:(NSDictionary *)param
             hud:(BOOL)hud
          policy:(XTResponseCachePolicy)cachePolicy
   timeoutIfNeed:(int)timeoutIfNeed
      completion:(void (^)(id json))completion ;


+ (void)cachePOST:(NSString *)url
       parameters:(NSDictionary *)param
       completion:(void (^)(id json))completion ;

+ (void)cachePOST:(NSString *)url
       parameters:(NSDictionary *)param
           policy:(XTResponseCachePolicy)cachePolicy
    timeoutIfNeed:(int)timeoutIfNeed
       completion:(void (^)(id json))completion ;

+ (void)cachePOST:(NSString *)url
       parameters:(NSDictionary *)param
              hud:(BOOL)hud
           policy:(XTResponseCachePolicy)cachePolicy
    timeoutIfNeed:(int)timeoutIfNeed
       completion:(void (^)(id json))completion ;

@end

```



