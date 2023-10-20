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

  void addUserGroups(List<dynamic> groupData) {
    groups = groupData
        .map((groupData) => Group(
              id: groupData['id'],
              name: groupData['name'] ?? "",
              code: groupData['code'] ?? "",
              address: groupData['address'] ?? "",
              cp: groupData['cp'] ?? "",
              city: groupData['city'] ?? "",
              description: groupData['description'] ?? "",
              backgroundUrl: groupData['background_url'] ?? "",
            ))
        .toList();
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

  Group({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.cp,
    required this.city,
    required this.description,
    required this.backgroundUrl,
  });
}
