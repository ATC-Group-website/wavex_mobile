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
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    program =
        json['program'] != null ? Program.fromJson(json['program']) : null;
    instructor = json['instructor'] != null
        ? Instructor.fromJson(json['instructor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['program_id'] = programId;
    data['location_id'] = locationId;
    data['instructor_id'] = instructorId;
    data['session_date'] = sessionDate;
    data['start_time'] = startTime;
    data['is_free'] = isFree;
    data['requires_form_submission'] = requiresFormSubmission;
    data['form_submission_status'] = formSubmissionStatus;
    data['is_booked'] = isBooked;
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
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (program != null) {
      data['program'] = program!.toJson();
    }
    if (instructor != null) {
      data['instructor'] = instructor!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['area_name'] = areaName;
    data['venue_name'] = venueName;
    data['phone'] = phone;
    data['full_address'] = fullAddress;
    data['updated_at'] = updatedAt;
    data['is_active'] = isActive;
    data['requires_form_submission'] = requiresFormSubmission;
    data['form_submission_status'] = formSubmissionStatus;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
