class Coach {
  final String id;
  final String name;
  final String imageUrl;
  final String specialization;
  final List<String> classes;
  final double rating;
  final int experience;
  final String bio;

  const Coach({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.specialization,
    required this.classes,
    required this.rating,
    required this.experience,
    required this.bio,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      specialization: json['specialization'] as String,
      classes: List<String>.from(json['classes'] as List),
      rating: (json['rating'] as num).toDouble(),
      experience: json['experience'] as int,
      bio: json['bio'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'specialization': specialization,
      'classes': classes,
      'rating': rating,
      'experience': experience,
      'bio': bio,
    };
  }
}

// Sample data
final sampleCoaches = [
  Coach(
    id: '1',
    name: 'Menna Mohamed',
    imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
    specialization: 'Water Fitness',
    classes: ['WaveX Flow', 'Aqua Cardio', 'Water Yoga'],
    rating: 4.9,
    experience: 5,
    bio: 'Certified water fitness instructor with 5 years of experience in aquatic training.',
  ),
  Coach(
    id: '2',
    name: 'Sarah Johnson',
    imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80',
    specialization: 'Swimming',
    classes: ['Swim Technique', 'Water Aerobics'],
    rating: 4.8,
    experience: 7,
    bio: 'Former competitive swimmer turned fitness coach specializing in water-based workouts.',
  ),
];