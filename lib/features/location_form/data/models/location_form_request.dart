class LocationFormRequest {
  LocationFormRequest({
    required this.locationId,
    required this.name,
    required this.email,
    required this.phone,
    required this.instagramUsername,
    required this.ageRange,
    required this.preferredClubArea,
    required this.triedAquaFitness,
    required this.mostInterestedIn,
    required this.priorityAccess,
    required this.followedInstagram,
    required this.message,
  });

  final int locationId;
  final String name;
  final String email;
  final String phone;
  final String instagramUsername;
  final String ageRange;
  final String preferredClubArea;
  final bool triedAquaFitness;
  final List<String> mostInterestedIn;
  final String priorityAccess;
  final String followedInstagram;
  final String message;

  Map<String, dynamic> toJson() => {
        'location_id': locationId,
        'name': name,
        'email': email,
        'phone': phone,
        'instagram_username': instagramUsername,
        'age_range': ageRange,
        'preferred_club_area': preferredClubArea,
        'tried_aqua_fitness': triedAquaFitness,
        'most_interested_in': mostInterestedIn,
        'priority_access': [priorityAccess],
        'followed_instagram': followedInstagram,
        'message': message,
      };
}
