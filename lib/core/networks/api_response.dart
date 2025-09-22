class ApiResponse {
  int? statusCode;
  dynamic data;
  String? message;

  ApiResponse(this.statusCode, this.data, this.message);
}
