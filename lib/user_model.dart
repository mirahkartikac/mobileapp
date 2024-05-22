class UserModel {
  final int? id;
  final String noInduk;
  final String name;
  final String address;
  final String dateOfBirth;
  final String phoneNumber;

  UserModel({
    this.id,
    required this.noInduk,
    required this.name,
    required this.address,
    required this.dateOfBirth,
    required this.phoneNumber,
  });
}