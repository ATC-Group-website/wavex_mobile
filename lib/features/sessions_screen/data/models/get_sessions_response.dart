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
  String? discountedPrice;
  String? discountAmount;
  dynamic discountPercentage;
  String? createdAt;
  String? updatedAt;
  bool? isBooked;
  bool? isFree;
  bool? requiresFormSubmission;
  String? formSubmissionStatus;
  Location? location;
  Instructor? instructor;
  Program? program;

  SessionData(
      {this.id,
      this.programId,
      this.locationId,
      this.isFree,
      this.requiresFormSubmission,
      this.formSubmissionStatus,
      this.instructorId,
      this.sessionDate,
      this.startTime,
      this.endTime,
      this.maxCapacity,
      this.isBooked,
      this.currentBookings,
      this.status,
      this.price,
      this.discountedPrice,
      this.discountAmount,
      this.discountPercentage,
      this.createdAt,
      this.updatedAt,
      this.location,
      this.program,
      this.instructor});

  SessionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programId = json['program_id'];
    locationId = json['location_id'];
    instructorId = json['instructor_id'];
    sessionDate = json['session_date'];
    startTime = json['start_time'];
    isBooked = json['is_booked'];
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
    isFree = json['is_free'];
    requiresFormSubmission = json['requires_form_submission'];
    formSubmissionStatus = json['form_submission_status'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    program =
        json['program'] != null ? new Program.fromJson(json['program']) : null;
    instructor = json['instructor'] != null
        ? new Instructor.fromJson(json['instructor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['program_id'] = this.programId;
    data['location_id'] = this.locationId;
    data['instructor_id'] = this.instructorId;
    data['session_date'] = this.sessionDate;
    data['start_time'] = this.startTime;
    data['is_free'] = this.isFree;
    data['requires_form_submission'] = this.requiresFormSubmission;
    data['form_submission_status'] = this.formSubmissionStatus;
    data['is_booked'] = this.isBooked;
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
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.program != null) {
      data['program'] = this.program!.toJson();
    }
    if (this.instructor != null) {
      data['instructor'] = this.instructor!.toJson();
    }
    return data;
  }
}

class Location {
  int? id;
  String? areaName;
  String? venueName;
  String? phone;
  String? fullAddress;
  String? updatedAt;
  bool? isActive;
  bool? requiresFormSubmission;
  String? formSubmissionStatus;

  Location(
      {this.id,
      this.areaName,
      this.venueName,
      this.phone,
      this.fullAddress,
      this.updatedAt,
      this.isActive});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaName = json['area_name'];
    venueName = json['venue_name'];
    phone = json['phone'];
    fullAddress = json['full_address'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    requiresFormSubmission =
        json['requires_form_submission'] ?? json['requires_user_submission'];
    formSubmissionStatus = json['form_submission_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area_name'] = this.areaName;
    data['venue_name'] = this.venueName;
    data['phone'] = this.phone;
    data['full_address'] = this.fullAddress;
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    data['requires_form_submission'] = this.requiresFormSubmission;
    data['form_submission_status'] = this.formSubmissionStatus;
    return data;
  }
}

class Program {
  int? id;
  String? name;

  Program({this.id, this.name});

  Program.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Instructor {
  int? id;
  String? firstName;
  String? lastName;

  Instructor({
    this.id,
    this.firstName,
    this.lastName,
  });

  Instructor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
