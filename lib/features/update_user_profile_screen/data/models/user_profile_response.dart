class UserProfileResponse {
  Data? data;
  int? status;
  String? message;

  UserProfileResponse({this.data, this.status, this.message});

  UserProfileResponse.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? phone;
  String? image;
  String? dateOfBirth;
  String? deviceToken;
  String? medicalConditions;
  String? createdAt;
  String? emergencyNumber;
  // List<dynamic>? orders;
  // List<Sessions>? sessions;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.image,
    this.dateOfBirth,
    this.emergencyNumber,
    this.deviceToken,
    this.medicalConditions,
    this.createdAt,
    // this.orders,
    // this.sessions
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    phone = json['phone'];
    image = json['image'];
    dateOfBirth = json['date_of_birth'];
    emergencyNumber = json['emergency_number'];
    deviceToken = json['device_token'];
    medicalConditions = json['medical_conditions'];
    createdAt = json['created_at'];
    // if (json['orders'] != null) {
    //   orders = <Null>[];
    //   json['orders'].forEach((v) {
    //     orders!.add(v);
    //   });
    // }
    // if (json['sessions'] != null) {
    //   sessions = <Sessions>[];
    //   json['sessions'].forEach((v) {
    //     sessions!.add(new Sessions.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['gender'] = gender;
    data['phone'] = phone;
    data['image'] = image;
    data['date_of_birth'] = dateOfBirth;
    data['device_token'] = deviceToken;
    data['emergency_number'] = emergencyNumber;
    data['medical_conditions'] = medicalConditions;
    data['created_at'] = createdAt;
    // if (this.orders != null) {
    //   data['orders'] = this.orders!.map((v) => v).toList();
    // }
    // if (this.sessions != null) {
    //   data['sessions'] = this.sessions!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Sessions {
  int? id;
  int? programId;
  int? instructorId;
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
  dynamic discountedPrice;
  dynamic discountAmount;
  dynamic discountPercentage;
  Pivot? pivot;
  Program? program;
  Location? location;
  Instructor? instructor;

  Sessions(
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
      this.pivot,
      this.program,
      this.location,
      this.instructor});

  Sessions.fromJson(Map<String, dynamic> json) {
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
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
    program =
        json['program'] != null ? Program.fromJson(json['program']) : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    instructor = json['instructor'] != null
        ? Instructor.fromJson(json['instructor'])
        : null;
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
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (program != null) {
      data['program'] = program!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (instructor != null) {
      data['instructor'] = instructor!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? sessionId;

  Pivot({this.userId, this.sessionId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    sessionId = json['session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['session_id'] = sessionId;
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

class Location {
  int? id;
  String? areaName;
  String? venueName;
  String? fullAddress;

  Location({this.id, this.areaName, this.venueName, this.fullAddress});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaName = json['area_name'];
    venueName = json['venue_name'];
    fullAddress = json['full_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['area_name'] = areaName;
    data['venue_name'] = venueName;
    data['full_address'] = fullAddress;
    return data;
  }
}

class Instructor {
  int? id;
  String? firstName;
  String? lastName;

  Instructor({this.id, this.firstName, this.lastName});

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
