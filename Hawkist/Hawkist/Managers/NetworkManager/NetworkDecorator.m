
#import "NetworkDecorator.h"
#import "const.h"

@interface NetworkDecorator ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;

@end

@implementation NetworkDecorator

#pragma mark - General

- (instancetype) init
{
    self = [super init];
    
    if (self != nil)
    {
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL: [NSURL URLWithString: SERVER_URL]];
        self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.operationManager.requestSerializer setAuthorizationHeaderFieldWithUsername: SERVER_API_KEY
                                                                                password: SERVER_API_PASS];
    }
    
    return self;
}

- (NSURL*) baseUrl
{
    return self.operationManager.baseURL;
}

#pragma mark - Private stuff

- (BOOL) canSendRequest
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

- (NSError*) noConnectionError
{
    return [NSError errorWithDomain: @"Internet connection" code: 499 userInfo: @{NSLocalizedDescriptionKey:@"No Internet connection. You are offline."}];
}

#pragma mark - Public stuff

- (void) addOperation: (AFHTTPRequestOperation*) operation
{
    [self.operationManager.operationQueue addOperation: operation];
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([self canSendRequest])
    {
        return [self.operationManager GET: URLString
                               parameters: parameters
                                  success: success
                                  failure: failure];
    }
    else
    {
        failure(nil, [self noConnectionError]);
        return nil;
    }
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([self canSendRequest])
    {
        return [self.operationManager POST: URLString
                                parameters: parameters
                                   success: success
                                   failure: failure];
    }
    else
    {
        failure(nil, [self noConnectionError]);
        return nil;
    }
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([self canSendRequest])
    {
        return [self.operationManager POST: URLString
                                parameters: parameters
                 constructingBodyWithBlock: block
                                   success: success
                                   failure: failure];
    }
    else
    {
        failure(nil, [self noConnectionError]);
        return nil;
    }
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([self canSendRequest])
    {
        return [self.operationManager PUT: URLString
                               parameters: parameters
                                  success: success
                                  failure: failure];
    }
    else
    {
        failure(nil, [self noConnectionError]);
        return nil;
    }
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([self canSendRequest])
    {
        return [self.operationManager DELETE: URLString
                                  parameters: parameters
                                     success: success
                                     failure: failure];
    }
    else
    {
        failure(nil, [self noConnectionError]);
        return nil;
    }
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([self canSendRequest])
    {
        return [self.operationManager HTTPRequestOperationWithRequest: request
                                                              success: success
                                                              failure: failure];
    }
    else
    {
        failure(nil, [self noConnectionError]);
        return nil;
    }
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                                  error:(NSError *__autoreleasing *)error
{
    return [self.operationManager.requestSerializer multipartFormRequestWithMethod: method
                                                                         URLString: URLString
                                                                        parameters: parameters
                                                         constructingBodyWithBlock: block
                                                                             error: error];
}


@end
