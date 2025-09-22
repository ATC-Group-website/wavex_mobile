class MySessionsResponse {
  Data? data;
  int? status;
  String? message;

  MySessionsResponse({this.data, this.status, this.message});

  MySessionsResponse.fromJson(Map<String, dynamic> json) {
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
  User? user;
  Pagination? pagination;

  Data({this.user, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? image;
  List<Sessions>? sessions;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.phone,
        this.email,
        this.image,
        this.sessions});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    if (json['sessions'] != null) {
      sessions = <Sessions>[];
      json['sessions'].forEach((v) {
        sessions!.add(new Sessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    if (this.sessions != null) {
      data['sessions'] = this.sessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sessions {
  int? id;
  int? programId;
  int? instructorId;
  int? locationId;
  String? sessionDate;
  String? bookingDate;
  String? startTime;
  String? endTime;
  String? price;
  String? status;
  Program? program;
  dynamic isRefundable;
  dynamic isFree;
  Location? location;
  Instructor? instructor;

  Sessions(
      {this.id,
        this.programId,
        this.bookingDate,
        this.instructorId,
        this.locationId,
        this.sessionDate,
        this.startTime,
        this.isRefundable,
        this.endTime,
        this.price,
        this.status,
        this.program,
        this.location,
        this.instructor});

  Sessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programId = json['program_id'];
    instructorId = json['instructor_id'];
    isFree = json['is_free'];
    locationId = json['location_id'];
    sessionDate = json['session_date'];
    bookingDate = json['booking_date'];
    isRefundable = json['is_refundable'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    price = json['price'];
    status = json['status'];
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
    data['is_free'] = this.isFree;
    data['location_id'] = this.locationId;
    data['session_date'] = this.sessionDate;
    data['booking_date'] = this.bookingDate;
    data['is_refundable'] = this.isRefundable;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['price'] = this.price;
    data['status'] = this.status;
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

  Location({this.id, this.areaName});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaName = json['area_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area_name'] = this.areaName;
    return data;
  }
}

class Instructor {
  int? id;
  String? firstName;
  String? lastName;
  String? image;

  Instructor({this.id, this.firstName, this.lastName, this.image});

  Instructor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? from;
  int? to;
  bool? hasMorePages;
  dynamic nextPageUrl;
  dynamic prevPageUrl;

  Pagination(
      {this.currentPage,
        this.lastPage,
        this.perPage,
        this.total,
        this.from,
        this.to,
        this.hasMorePages,
        this.nextPageUrl,
        this.prevPageUrl});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    from = json['from'];
    to = json['to'];
    hasMorePages = json['has_more_pages'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['from'] = this.from;
    data['to'] = this.to;
    data['has_more_pages'] = this.hasMorePages;
    data['next_page_url'] = this.nextPageUrl;
    data['prev_page_url'] = this.prevPageUrl;
    return data;
  }
}
