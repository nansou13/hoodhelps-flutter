class Job {
  final String id;
  final String name;
  final String description;
  final int experienceYears;
  final bool isPro;
  final String companyName;


  Job({required this.id, required this.name, this.description = '', this.experienceYears = 0, this.isPro = false, this.companyName = ''});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(id: json['id'], name: json['name'], description: json['description'] ?? '', experienceYears: json['experience_years'] ?? 0, isPro: json['pro'] ?? false, companyName: json['company_name'] ?? '');
  }
}