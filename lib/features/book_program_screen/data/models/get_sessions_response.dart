class GetSessionsResponse {
  List<SessionData>? data;
  int? status;
  String? message;

  GetSessionsResponse({this.data, this.status, this.message});

  GetSessionsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SessionData>[];
      json['data'].forEach((v) {
        data!.add(new SessionData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['program_id'] = this.programId;
    data['location_id'] = this.locationId;
    data['instructor_id'] = this.instructorId;
    data['session_date'] = this.sessionDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['max_capacity'] = this.maxCapacity;
    data['current_bookings'] = this.currentBookings;
    data['status'] = this.status;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    data['discount_amount'] = this.discountAmount;
    data['discount_percentage'] = this.discountPercentage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
