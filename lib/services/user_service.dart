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
