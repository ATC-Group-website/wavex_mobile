class UserProfileResponse {
  Data? data;
  int? status;
  String? message;

  UserProfileResponse({this.data, this.status, this.message});

  UserProfileResponse.fromJson(Map<String, dynamic> json) {
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

  Data(
      {this.id,
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['date_of_birth'] = this.dateOfBirth;
    data['device_token'] = this.deviceToken;
    data['emergency_number'] = this.emergencyNumber;
    data['medical_conditions'] = this.medicalConditions;
    data['created_at'] = this.createdAt;
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
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    program =
    json['program'] != null ? new Program.fromJson(json['program']) : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    instructor = json['instructor'] != null
        ? new Instructor.fromJson(json['instructor'])
        : null;
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
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    if (this.program != null) {
      data['program'] = this.program!.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.instructor != null) {
      data['instructor'] = this.instructor!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['session_id'] = this.sessionId;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area_name'] = this.areaName;
    data['venue_name'] = this.venueName;
    data['full_address'] = this.fullAddress;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
