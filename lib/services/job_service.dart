class Job {
  final String id;
  final String name;
  final String description;
  final int experience_years;

  Job({required this.id, required this.name, this.description = '', this.experience_years = 0});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(id: json['id'], name: json['name'], description: json['description'] ?? '', experience_years: json['experience_years'] ?? 0);
  }
}