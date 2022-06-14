//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ManipulateLayerApi {
  ManipulateLayerApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ColorProp] colorProp (required):
  Future<Response> addColorLayerWithHttpInfo(ColorProp colorProp,) async {
    // ignore: prefer_const_declarations
    final path = r'/layers/add/color';

    // ignore: prefer_final_locals
    Object? postBody = colorProp;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 
  ///
  /// Parameters:
  ///
  /// * [ColorProp] colorProp (required):
  Future<void> addColorLayer(ColorProp colorProp,) async {
    final response = await addColorLayerWithHttpInfo(colorProp,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CropFilterProps] cropFilterProps (required):
  Future<Response> addCropFilterLayerWithHttpInfo(CropFilterProps cropFilterProps,) async {
    // ignore: prefer_const_declarations
    final path = r'/layers/add/filter/crop';

    // ignore: prefer_final_locals
    Object? postBody = cropFilterProps;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 
  ///
  /// Parameters:
  ///
  /// * [CropFilterProps] cropFilterProps (required):
  Future<void> addCropFilterLayer(CropFilterProps cropFilterProps,) async {
    final response = await addCropFilterLayerWithHttpInfo(cropFilterProps,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [TimerProps] timerProps (required):
  Future<Response> addTimerLayerWithHttpInfo(TimerProps timerProps,) async {
    // ignore: prefer_const_declarations
    final path = r'/layers/add/timer';

    // ignore: prefer_final_locals
    Object? postBody = timerProps;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 
  ///
  /// Parameters:
  ///
  /// * [TimerProps] timerProps (required):
  Future<void> addTimerLayer(TimerProps timerProps,) async {
    final response = await addTimerLayerWithHttpInfo(timerProps,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// 
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> addWheelLayerWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/layers/add/wheel';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 
  Future<void> addWheelLayer() async {
    final response = await addWheelLayerWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] uuid (required):
  ///
  /// * [ColorProp] colorProp (required):
  Future<Response> changeColorLayerWithHttpInfo(String uuid, ColorProp colorProp,) async {
    // ignore: prefer_const_declarations
    final path = r'/layers/update/color/';

    // ignore: prefer_final_locals
    Object? postBody = colorProp;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'uuid', uuid));

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 
  ///
  /// Parameters:
  ///
  /// * [String] uuid (required):
  ///
  /// * [ColorProp] colorProp (required):
  Future<void> changeColorLayer(String uuid, ColorProp colorProp,) async {
    final response = await changeColorLayerWithHttpInfo(uuid, colorProp,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] uuid (required):
  Future<Response> deleteByUuidWithHttpInfo(String uuid,) async {
    // ignore: prefer_const_declarations
    final path = r'/layer';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'uuid', uuid));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 
  ///
  /// Parameters:
  ///
  /// * [String] uuid (required):
  Future<void> deleteByUuid(String uuid,) async {
    final response = await deleteByUuidWithHttpInfo(uuid,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] from (required):
  ///
  /// * [int] to (required):
  Future<Response> switchLayersWithHttpInfo(int from, int to,) async {
    // ignore: prefer_const_declarations
    final path = r'/layers/switch';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'from', from));
      queryParams.addAll(_queryParams('', 'to', to));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 
  ///
  /// Parameters:
  ///
  /// * [int] from (required):
  ///
  /// * [int] to (required):
  Future<void> switchLayers(int from, int to,) async {
    final response = await switchLayersWithHttpInfo(from, to,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
