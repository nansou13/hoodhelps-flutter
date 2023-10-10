class UserService {
  String? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  bool? isActive;
  String? role;
  String? phoneNumber;

  void updateUser(Map<String, dynamic> userData) {
    id = userData['id'];
    username = userData['username'];
    email = userData['email'];
    firstName = userData['first_name'];
    lastName = userData['last_name'];
    dateOfBirth = userData['date_of_birth'];
    isActive = userData['is_active'];
    role = userData['role'];
    phoneNumber = userData['phone_number'];
  }
}
