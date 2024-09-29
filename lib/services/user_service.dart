import 'package:hoodhelps/services/job_service.dart';

class UserService {
  String? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? imageUrl;
  bool? isActive;
  String? role;
  String? phoneNumber;
  List<Group> groups;
  List<Job> jobs;
  String currentGroupId;

  UserService({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.imageUrl,
    this.isActive,
    this.role,
    this.phoneNumber,
    this.groups = const [], // Par défaut, la liste des groupes est vide.
    this.jobs = const [], // Par défaut, la liste des jobs est vide.
    this.currentGroupId = '',
  });

  void updateUser(Map<String, dynamic> userData) {
    id = userData['id'];
    username = userData['username'];
    email = userData['email'];
    firstName = userData['first_name'];
    lastName = userData['last_name'];
    dateOfBirth = userData['date_of_birth'];
    imageUrl = userData['image_url'];
    isActive = userData['is_active'];
    role = userData['role'];
    phoneNumber = userData['phone_number'];
  }

  Map<String, dynamic> getUser() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth,
      'image_url': imageUrl,
      'is_active': isActive,
      'role': role,
      'phone_number': phoneNumber,
    };
  }

  String getUserName() {
    String currentFirstName = firstName ?? '';
      String currentLastName = lastName ?? '';
      String currentUsername = username ?? '';

      if (currentFirstName.isNotEmpty) {
        return '$currentFirstName $currentLastName'; // Concatène le prénom et le nom
      } else {
        return currentUsername; // Utilise le username si pas de first_name
      }
  }

  void addUserGroups(List<dynamic> groupData) {
    groups = groupData.map((data) => Group.fromJson(data)).toList();
  }

  void removeUserGroup(String groupId) {
    groups.removeWhere((group) => group.id == groupId);
  }
  void addUserJobs(List<dynamic> jobData) {
    jobs = jobData.map((data) => Job.fromJson(data)).toList();
  }
  void addNewJob(String jobId, String jobName, String? description, int? experienceYears, bool? isPro, String? company_name) {
  final newJob = Job(
    id: jobId,
    name: jobName,
    description: description ?? '', // Valeur par défaut si la description est null
    experience_years: experienceYears ?? 0, // Valeur par défaut si les années d'expérience sont null
    isPro: isPro ?? false, // Valeur par défaut si le booléen est null
    company_name: company_name ?? '', // Valeur par défaut si le nom de l'entreprise est null
  );

  jobs.add(newJob); // Ajoute le nouveau job à la liste
}

  void updateUserJob(String jobId, String? newDescription, int? newExperienceYears, bool? isPro, String? company_name) {
    for (var i = 0; i < jobs.length; i++) {
      if (jobs[i].id == jobId) {
        jobs[i] = Job(
          id: jobs[i].id, 
          name: jobs[i].name, 
          description: newDescription ?? jobs[i].description, 
          experience_years: newExperienceYears ?? jobs[i].experience_years,
          isPro: isPro ?? jobs[i].isPro,
          company_name: company_name ?? jobs[i].company_name,
        );
        break;
      }
    }
  }
  void removeUserJobs(String jobId) {
    jobs.removeWhere((job) => job.id == jobId);
  }

  void setCurrentGroupId(String groupId) {
    currentGroupId = groupId;
  }
}

class Group {
  String id;
  String name;
  String code;
  String address;
  String cp;
  String city;
  String description;
  String backgroundUrl;
  List<dynamic> users;

  Group({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.cp,
    required this.city,
    required this.description,
    required this.backgroundUrl,
    required this.users,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      address: json['address'] ?? '',
      cp: json['cp'] ?? '',
      city: json['city'] ?? '',
      description: json['description'] ?? '',
      backgroundUrl: json['background_url'] ?? '',
      users: json['users'] ?? [],
    );
  }
}
