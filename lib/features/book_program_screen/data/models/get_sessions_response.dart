class GetSessionsResponse {
  List<SessionData>? data;
  int? status;
  String? message;

  GetSessionsResponse({this.data, this.status, this.message});

  GetSessionsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SessionData>[];
      json['data'].forEach((v) {
        data!.add(SessionData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class SessionData {
  int? id;
  int? programId;
  int? locationId;
  int? instructorId;
  String? sessionDate;
  String? startTime;
  String? endTime;
  int? maxCapacity;
  int? currentBookings;
  String? status;
  String? price;
  dynamic discountedPrice;
  dynamic discountAmount;
  dynamic discountPercentage;
  String? createdAt;
  String? updatedAt;

  SessionData(
      {this.id,
      this.programId,
      this.locationId,
      this.instructorId,
      this.sessionDate,
      this.startTime,
      this.endTime,
      this.maxCapacity,
      this.currentBookings,
      this.status,
      this.price,
      this.discountedPrice,
      this.discountAmount,
      this.discountPercentage,
      this.createdAt,
      this.updatedAt});

  SessionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programId = json['program_id'];
    locationId = json['location_id'];
    instructorId = json['instructor_id'];
    sessionDate = json['session_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    maxCapacity = json['max_capacity'];
    currentBookings = json['current_bookings'];
    status = json['status'];
    price = json['price'];
    discountedPrice = json['discounted_price'];
    discountAmount = json['discount_amount'];
    discountPercentage = json['discount_percentage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['program_id'] = programId;
    data['location_id'] = locationId;
    data['instructor_id'] = instructorId;
    data['session_date'] = sessionDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['max_capacity'] = maxCapacity;
    data['current_bookings'] = currentBookings;
    data['status'] = status;
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['discount_amount'] = discountAmount;
    data['discount_percentage'] = discountPercentage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
