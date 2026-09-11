class BookFreeSessionResponse {
  Data? data;
  int? status;
  String? message;

  BookFreeSessionResponse({this.data, this.status, this.message});

  BookFreeSessionResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class Data {
  int? userId;
  int? sessionId;
  int? slots;
  int? bookingsCount;
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
      this.slots,
      this.bookingsCount,
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
    slots = json['slots'];
    bookingsCount = json['bookings_count'];
    bookingReference = json['booking_reference'];
    bookingDate = json['booking_date'];
    bookingStatus = json['booking_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    session =
        json['session'] != null ? Session.fromJson(json['session']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['session_id'] = sessionId;
    data['slots'] = slots;
    data['bookings_count'] = bookingsCount;
    data['booking_reference'] = bookingReference;
    data['booking_date'] = bookingDate;
    data['booking_status'] = bookingStatus;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (session != null) {
      data['session'] = session!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['medical_conditions'] = medicalConditions;
    data['email_verified_at'] = emailVerifiedAt;
    data['image'] = image;
    data['is_active'] = isActive;
    data['device_token'] = deviceToken;
    data['timezone'] = timezone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['emergency_number'] = emergencyNumber;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['program_id'] = programId;
    data['instructor_id'] = instructorId;
    data['location_id'] = locationId;
    data['session_date'] = sessionDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['max_capacity'] = maxCapacity;
    data['current_bookings'] = currentBookings;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['discount_amount'] = discountAmount;
    data['discount_percentage'] = discountPercentage;
    data['is_free'] = isFree;
    data['instructor'] = instructor;
    return data;
  }
}
