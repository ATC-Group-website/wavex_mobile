class BookFreeSessionResponse {
  Data? data;
  int? status;
  String? message;

  BookFreeSessionResponse({this.data, this.status, this.message});

  BookFreeSessionResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? userId;
  int? sessionId;
  String? bookingReference;
  String? bookingDate;
  String? bookingStatus;
  String? updatedAt;
  String? createdAt;
  int? id;
  User? user;
  Session? session;

  Data(
      {this.userId,
        this.sessionId,
        this.bookingReference,
        this.bookingDate,
        this.bookingStatus,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.user,
        this.session});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    sessionId = json['session_id'];
    bookingReference = json['booking_reference'];
    bookingDate = json['booking_date'];
    bookingStatus = json['booking_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    session =
    json['session'] != null ? new Session.fromJson(json['session']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['session_id'] = this.sessionId;
    data['booking_reference'] = this.bookingReference;
    data['booking_date'] = this.bookingDate;
    data['booking_status'] = this.bookingStatus;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.session != null) {
      data['session'] = this.session!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  dynamic phone;
  String? dateOfBirth;
  String? gender;
  String? medicalConditions;
  dynamic emailVerifiedAt;
  String? image;
  int? isActive;
  String? deviceToken;
  String? timezone;
  String? createdAt;
  String? updatedAt;
  dynamic emergencyNumber;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.dateOfBirth,
        this.gender,
        this.medicalConditions,
        this.emailVerifiedAt,
        this.image,
        this.isActive,
        this.deviceToken,
        this.timezone,
        this.createdAt,
        this.updatedAt,
        this.emergencyNumber});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    medicalConditions = json['medical_conditions'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    isActive = json['is_active'];
    deviceToken = json['device_token'];
    timezone = json['timezone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emergencyNumber = json['emergency_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['medical_conditions'] = this.medicalConditions;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['device_token'] = this.deviceToken;
    data['timezone'] = this.timezone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['emergency_number'] = this.emergencyNumber;
    return data;
  }
}

class Session {
  int? id;
  int? programId;
  dynamic instructorId;
  int? locationId;
  String? sessionDate;
  String? startTime;
  String? endTime;
  int? maxCapacity;
  int? currentBookings;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? price;
  String? discountedPrice;
  String? discountAmount;
  int? discountPercentage;
  bool? isFree;
  dynamic instructor;

  Session(
      {this.id,
        this.programId,
        this.instructorId,
        this.locationId,
        this.sessionDate,
        this.startTime,
        this.endTime,
        this.maxCapacity,
        this.currentBookings,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.price,
        this.discountedPrice,
        this.discountAmount,
        this.discountPercentage,
        this.isFree,
        this.instructor});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programId = json['program_id'];
    instructorId = json['instructor_id'];
    locationId = json['location_id'];
    sessionDate = json['session_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    maxCapacity = json['max_capacity'];
    currentBookings = json['current_bookings'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    price = json['price'];
    discountedPrice = json['discounted_price'];
    discountAmount = json['discount_amount'];
    discountPercentage = json['discount_percentage'];
    isFree = json['is_free'];
    instructor = json['instructor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['program_id'] = this.programId;
    data['instructor_id'] = this.instructorId;
    data['location_id'] = this.locationId;
    data['session_date'] = this.sessionDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['max_capacity'] = this.maxCapacity;
    data['current_bookings'] = this.currentBookings;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    data['discount_amount'] = this.discountAmount;
    data['discount_percentage'] = this.discountPercentage;
    data['is_free'] = this.isFree;
    data['instructor'] = this.instructor;
    return data;
  }
}
