# openapi.api.ManipulateLayerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addColorLayer**](ManipulateLayerApi.md#addcolorlayer) | **POST** /layers/add/color | 
[**addCropFilterLayer**](ManipulateLayerApi.md#addcropfilterlayer) | **POST** /layers/add/filter/crop | 
[**addTimerLayer**](ManipulateLayerApi.md#addtimerlayer) | **POST** /layers/add/timer | 
[**addWheelLayer**](ManipulateLayerApi.md#addwheellayer) | **POST** /layers/add/wheel | 
[**changeColorLayer**](ManipulateLayerApi.md#changecolorlayer) | **POST** /layers/update/color/ | 
[**deleteByUuid**](ManipulateLayerApi.md#deletebyuuid) | **DELETE** /layer | 
[**switchLayers**](ManipulateLayerApi.md#switchlayers) | **POST** /layers/switch | 


# **addColorLayer**
> addColorLayer(colorProp)





### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: LED-API-KEY
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKeyPrefix = 'Bearer';

final api_instance = ManipulateLayerApi();
final colorProp = ColorProp(); // ColorProp | 

try {
    api_instance.addColorLayer(colorProp);
} catch (e) {
    print('Exception when calling ManipulateLayerApi->addColorLayer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **colorProp** | [**ColorProp**](ColorProp.md)|  | 

### Return type

void (empty response body)

### Authorization

[LED-API-KEY](../README.md#LED-API-KEY)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addCropFilterLayer**
> addCropFilterLayer(cropFilterProps)





### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: LED-API-KEY
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKeyPrefix = 'Bearer';

final api_instance = ManipulateLayerApi();
final cropFilterProps = CropFilterProps(); // CropFilterProps | 

try {
    api_instance.addCropFilterLayer(cropFilterProps);
} catch (e) {
    print('Exception when calling ManipulateLayerApi->addCropFilterLayer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cropFilterProps** | [**CropFilterProps**](CropFilterProps.md)|  | 

### Return type

void (empty response body)

### Authorization

[LED-API-KEY](../README.md#LED-API-KEY)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addTimerLayer**
> addTimerLayer(timerProps)





### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: LED-API-KEY
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKeyPrefix = 'Bearer';

final api_instance = ManipulateLayerApi();
final timerProps = TimerProps(); // TimerProps | 

try {
    api_instance.addTimerLayer(timerProps);
} catch (e) {
    print('Exception when calling ManipulateLayerApi->addTimerLayer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **timerProps** | [**TimerProps**](TimerProps.md)|  | 

### Return type

void (empty response body)

### Authorization

[LED-API-KEY](../README.md#LED-API-KEY)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addWheelLayer**
> addWheelLayer()





### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: LED-API-KEY
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKeyPrefix = 'Bearer';

final api_instance = ManipulateLayerApi();

try {
    api_instance.addWheelLayer();
} catch (e) {
    print('Exception when calling ManipulateLayerApi->addWheelLayer: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[LED-API-KEY](../README.md#LED-API-KEY)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **changeColorLayer**
> changeColorLayer(uuid, colorProp)





### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: LED-API-KEY
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKeyPrefix = 'Bearer';

final api_instance = ManipulateLayerApi();
final uuid = uuid_example; // String | 
final colorProp = ColorProp(); // ColorProp | 

try {
    api_instance.changeColorLayer(uuid, colorProp);
} catch (e) {
    print('Exception when calling ManipulateLayerApi->changeColorLayer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **colorProp** | [**ColorProp**](ColorProp.md)|  | 

### Return type

void (empty response body)

### Authorization

[LED-API-KEY](../README.md#LED-API-KEY)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteByUuid**
> deleteByUuid(uuid)





### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: LED-API-KEY
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKeyPrefix = 'Bearer';

final api_instance = ManipulateLayerApi();
final uuid = uuid_example; // String | 

try {
    api_instance.deleteByUuid(uuid);
} catch (e) {
    print('Exception when calling ManipulateLayerApi->deleteByUuid: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[LED-API-KEY](../README.md#LED-API-KEY)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **switchLayers**
> switchLayers(from, to)





### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: LED-API-KEY
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('LED-API-KEY').apiKeyPrefix = 'Bearer';

final api_instance = ManipulateLayerApi();
final from = 56; // int | 
final to = 56; // int | 

try {
    api_instance.switchLayers(from, to);
} catch (e) {
    print('Exception when calling ManipulateLayerApi->switchLayers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **int**|  | 
 **to** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[LED-API-KEY](../README.md#LED-API-KEY)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

