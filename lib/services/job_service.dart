class Job {
  final String id;
  final String name;
  final String description;
  final int experience_years;
  final bool isPro;
  final String company_name;


  Job({required this.id, required this.name, this.description = '', this.experience_years = 0, this.isPro = false, this.company_name = ''});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(id: json['id'], name: json['name'], description: json['description'] ?? '', experience_years: json['experience_years'] ?? 0, isPro: json['pro'] ?? false, company_name: json['company_name'] ?? '');
  }
}