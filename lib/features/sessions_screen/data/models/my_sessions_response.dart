class MySessionsResponse {
  Data? data;
  int? status;
  String? message;

  MySessionsResponse({this.data, this.status, this.message});

  MySessionsResponse.fromJson(Map<String, dynamic> json) {
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
  User? user;
  Pagination? pagination;

  Data({this.user, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
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
        sessions!.add(Sessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
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
    data['is_free'] = isFree;
    data['location_id'] = locationId;
    data['session_date'] = sessionDate;
    data['booking_date'] = bookingDate;
    data['is_refundable'] = isRefundable;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['price'] = price;
    data['status'] = status;
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

  Location({this.id, this.areaName});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaName = json['area_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['area_name'] = areaName;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['from'] = from;
    data['to'] = to;
    data['has_more_pages'] = hasMorePages;
    data['next_page_url'] = nextPageUrl;
    data['prev_page_url'] = prevPageUrl;
    return data;
  }
}
