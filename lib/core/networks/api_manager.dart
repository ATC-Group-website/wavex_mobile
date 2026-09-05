import 'dart:convert';
import 'package:dio/dio.dart';
import '../../main.dart';
import '../helper/cache_helper/cache_helper.dart';
import '../route/route_strings/route_strings.dart';
import 'api_response.dart';
import 'request_body.dart';

class ApiException implements Exception {
  final bool isRedirect;
  final String message;

  ApiException(this.isRedirect, this.message);

  @override
  String toString() => message;
}

class ApiManager {
  static final Dio _dio = Dio();
  static const bool _isTestMode = true;
  static const String _baseUrlOverride = String.fromEnvironment('BASE_URL');

  static void init() {
    //  default configs
    _dio.options.baseUrl = ApiManager.getBaseUrl();
    _dio.options.connectTimeout = const Duration(milliseconds: 100000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 100000);
    _dio.options.responseType = ResponseType.plain;
    _dio.options.followRedirects = true;
    _dio.options.validateStatus = (status) {
      return status != null && status < 500; // اعتبر 3xx و 4xx responses valid
    };
    if (_isTestMode) {
      _dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestBody: true,
          error: true,
          requestHeader: false,
          responseHeader: true,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          if (response.statusCode == 401) {
            CacheHelper.removeData(key: "userToken");
            CacheHelper.removeData(key: "userId");
            navigatorKey.currentState?.pushReplacementNamed(
              RouteStrings.loginScreen,
            );
          }
          return handler.next(response);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) {
          // Check if the error response has a status code 401
          if (e.response?.statusCode == 401) {
            CacheHelper.removeData(key: "userToken");
            CacheHelper.removeData(key: "userId");
            navigatorKey.currentState?.pushReplacementNamed(
              RouteStrings.loginScreen,
            );
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Future<ApiResponse?> sendRequest({
    required String link,
    RequestBody? body,
    Map<String, dynamic>? queryParams,
    FormData? formData,
    dynamic rawBody,
    Method method = Method.POST,
  }) async {
    Map<String, dynamic> headers = {};
    headers.putIfAbsent("Content-Type", () => "application/json");
    headers.putIfAbsent("Accept", () => "application/json");

    if (CacheHelper.getdata(key: "userToken") != null) {
      headers.putIfAbsent(
        "Authorization",
        () => "Bearer ${CacheHelper.getdata(key: "userToken").toString()}",
      );
    }

    try {
      Response? response;

      if (method == Method.POST) {
        response = await _dio.post(
          link,
          data: formData ?? rawBody ?? body?.getBody(),
          queryParameters: queryParams,
          options: Options(headers: headers),
        );
      } else if (method == Method.PUT) {
        response = await _dio.put(
          link,
          data: formData ?? body?.getBody(),
          queryParameters: queryParams,
          options: Options(headers: headers),
        );
      } else if (method == Method.GET) {
        response = await _dio.get(
          link,
          queryParameters: queryParams,
          options: Options(headers: headers),
        );
      } else if (method == Method.DELETE) {
        response = await _dio.delete(
          link,
          data: body,
          queryParameters: queryParams,
          options: Options(headers: headers),
        );
      } else if (method == Method.PATCH) {
        response = await _dio.patch(
          link,
          data: formData ?? body?.getBody(),
          queryParameters: queryParams,
          options: Options(headers: headers),
        );
      }

      if (response == null) {
        throw ApiException(false, "No response received from server.");
      }

      final code = response.statusCode ?? 0;

      // ✅ فقط 200 و 201 تعتبر نجاح
      if (code == 200 || code == 201) {
        return ApiResponse(code, response.data, response.statusMessage);
      }

      // ❌ أي statusCode تاني → Error بالـ message اللي راجع
      final message = getErrorMsg(response.data) ?? "Unexpected error";
      throw ApiException(false, message);
    } on DioError catch (e) {
      if (e.response != null) {
        final message = getErrorMsg(e.response?.data) ?? "Request failed";
        throw ApiException(false, message);
      } else {
        throw ApiException(
          false,
          "Cannot reach server. Please check your connection.",
        );
      }
    }
  }

  // static Future<ApiResponse?> sendRequest({
  //   required String link,
  //   RequestBody? body,
  //   Map<String, dynamic>? queryParams,
  //   FormData? formData,
  //   dynamic rawBody, // new param
  //   Method method = Method.POST,
  // }) async
  // {
  //   Map<String, dynamic> headers = {};
  //
  //   // headers.putIfAbsent(
  //   //     "Accept-Language", () => CacheHelper.getdata(key: "lang"));
  //   headers.putIfAbsent("Content-Type", () => "application/json");
  //   headers.putIfAbsent("Accept", () => "application/json");
  //
  //   if (CacheHelper.getdata(key: "userToken") != null) {
  //     // UserData userData =
  //     //     UserData.fromJson(json.decode(CacheManager.getCurrentUser()));
  //
  //     // headers.putIfAbsent("Authorization",
  //     //     () => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjY3Mjc2MTY4YzY5OWJiYjczOGQ4YTc1NCIsImV4cCI6MzMyOTczOTM5NDQsImlzcyI6InlvdXItaXNzdWVyIiwiYXVkIjoieW91ci1hdWRpZW5jZSJ9.pJ-JyHVNBOV9o3J44I6BT_4xG8Y3aZYzxCiCW7MdWQw");
  //     headers.putIfAbsent("Authorization",
  //         () => "Bearer ${CacheHelper.getdata(key: "userToken").toString()}");
  //   }
  //
  //   // if (formData != null) {
  //   //   headers.putIfAbsent("Content-Type",
  //   //       () => "multipart/form-data; boundary=${formData.boundary}");
  //   // }
  //   try {
  //     Response? response;
  //     if (method == Method.POST) {
  //       response = await _dio.post(link,
  //           data: formData ?? rawBody ?? body?.getBody(),
  //           queryParameters: queryParams,
  //           options: Options(headers: headers));
  //       // response = await _dio.post(link,
  //       //     data: formData ?? body?.getBody(),
  //       //     queryParameters: queryParams,
  //       //     options: Options(headers: headers));
  //     } else if (method == Method.PUT) {
  //       response = await _dio.put(link,
  //           data: formData ?? body?.getBody(),
  //           queryParameters: queryParams,
  //           options: Options(headers: headers));
  //     } else if (method == Method.GET) {
  //       response = await _dio.get(link,
  //           queryParameters: queryParams, options: Options(headers: headers));
  //     } else if (method == Method.DELETE) {
  //       response = await _dio.delete(link,
  //           data: body,
  //           queryParameters: queryParams,
  //           options: Options(headers: headers));
  //     } else if (method == Method.PATCH) {
  //       response = await _dio.patch(link,
  //           data: formData ?? body?.getBody(),
  //           queryParameters: queryParams,
  //           options: Options(headers: headers));
  //     }
  //
  //     return ApiResponse(
  //         response!.statusCode, response.data, response.statusMessage);
  //   } on DioError catch (e) {
  //     if (e.response != null && e.response?.statusCode == 401) {
  //       throw ApiException(
  //         e.response!.isRedirect,
  //         getErrorMsg(
  //           e.response?.data,
  //         ),
  //       );
  //     } else if (e.response != null &&
  //         (e.response?.statusCode == 400 ||
  //             e.response?.statusCode == 404 ||
  //             e.response?.statusCode == 402 ||
  //             e.response?.statusCode == 422)) {
  //       throw ApiException(
  //           e.response!.isRedirect, getErrorMsg(e.response?.data));
  //     } else {
  //       // cannot reach server , server may be down or no internet connection.
  //       throw ApiException(false, "Error in server");
  //     }
  //   }
  // }

  static String getBaseUrl() {
    if (_baseUrlOverride.isNotEmpty) {
      return _baseUrlOverride.endsWith('/')
          ? _baseUrlOverride
          : '$_baseUrlOverride/';
    }

    if (_isTestMode) {
      return 'https://dev-api.wavexsports.com/api/';
    } else {
      return 'http://165.232.113.79/api/';
    }
  }

  static String buildFileUrl(String filePatUrl) {
    return getBaseUrl() + filePatUrl;
  }

  // static String getErrorMsg(dynamic data) {
  //   if (data == null || data == "") {
  //     return "Error in server";
  //   }
  //
  //   String error = "";
  //   late Map<String, dynamic> map;
  //
  //   try {
  //     if (data is String) {
  //       map = jsonDecode(data);
  //     } else if (data is Map<String, dynamic>) {
  //       map = data;
  //     } else {
  //       return "Unknown error format";
  //     }
  //   } catch (_) {
  //     return "Error parsing server response";
  //   }
  //
  //   // ✅ Handle "errors"
  //   if (map.containsKey("errors")) {
  //     final errors = map["errors"];
  //     if (errors is Map<String, dynamic>) {
  //       for (var errKey in errors.keys) {
  //         var exceptions = errors[errKey];
  //         if (exceptions is List && exceptions.isNotEmpty) {
  //           error += "${exceptions[0]}\n";
  //         } else {
  //           error += "$exceptions\n";
  //         }
  //       }
  //     } else if (errors is List) {
  //       // Sometimes APIs return errors as a list
  //       error = errors.join("\n");
  //     } else if (errors is String) {
  //       // ✅ handles your refund request case
  //       error = errors;
  //     }
  //   }
  //
  //   // ✅ fallback to message
  //   if (error.isEmpty && map["message"] != null) {
  //     error = map["message"];
  //   }
  //
  //   return error.isEmpty ? "Error in server" : error.trim();
  // }
  /// ✅ Improved error parser
  static String getErrorMsg(dynamic data) {
    if (data == null || data == "") {
      return "Error in server";
    }

    String error = "";
    late Map<String, dynamic> map;

    try {
      if (data is String) {
        map = jsonDecode(data);
      } else if (data is Map<String, dynamic>) {
        map = data;
      } else {
        return "Unknown error format";
      }
    } catch (_) {
      return "Error parsing server response";
    }

    // ✅ Handle "errors"
    if (map.containsKey("errors")) {
      final errors = map["errors"];
      if (errors is Map<String, dynamic>) {
        for (var errKey in errors.keys) {
          var exceptions = errors[errKey];
          if (exceptions is List && exceptions.isNotEmpty) {
            error += "${exceptions[0]}\n";
          } else {
            error += "$exceptions\n";
          }
        }
      } else if (errors is List) {
        error = errors.join("\n");
      } else if (errors is String) {
        error = errors;
      }
    }

    // ✅ fallback to "message" if no errors extracted
    if (error.isEmpty && map["message"] != null) {
      error = map["message"];
    }

    return error.isEmpty ? "Error in server" : error.trim();
  }

  //
  // static String getErrorMsg(dynamic data) {
  //   if (data == null || data == "") {
  //     return "Error in server";
  //   }
  //
  //   String error = "";
  //   late Map<String, dynamic> map;
  //
  //   try {
  //     if (data is String) {
  //       map = jsonDecode(data);
  //     }
  //     else if (data is Map<String, dynamic>) {
  //       map = data;
  //     }
  //     else {
  //       return "Unknown error format";
  //     }
  //   } catch (_) {
  //     return "Error parsing server response";
  //   }
  //
  //   if (map.containsKey("errors")) {
  //     final errors = map['errors'];
  //     if (errors is Map<String, dynamic>) {
  //       for (var errKey in errors.keys) {
  //         var exceptions = errors[errKey] as List<dynamic>;
  //         error += "${exceptions[0]}\n";
  //       }
  //     } else if (errors is String) {
  //       error = errors; // ✅ handles your "Not Found" case
  //     }
  //   }
  //
  //   if (error.isEmpty && map["message"] != null) {
  //     error = map["message"];
  //   }
  //
  //   return error.isEmpty ? "Error in server" : error;
  // }
}

// ignore: constant_identifier_names
enum Method { POST, PUT, GET, DELETE, PATCH }
