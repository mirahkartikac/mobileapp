import 'package:flutter/material.dart';
import 'user_model.dart';


class UserCard extends StatelessWidget {
  final UserModel user;
  final Function(UserModel) onUserEdited;
  final Function(UserModel) onDelete;

  const UserCard({Key? key, required this.user, required this.onUserEdited, required this.onDelete,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text('No Induk: ${user.noInduk}'),
            SizedBox(height: 5),
            Text('Address: ${user.address}'),
            SizedBox(height: 5),
            Text('Date of Birth: ${user.dateOfBirth}'),
            SizedBox(height: 5),
            Text('Phone Number: ${user.phoneNumber}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   // MaterialPageRoute(
                //   //   builder: (context) => EditUserPage(
                //   //     user: user,
                //   //     onUserEdited: (editedUser) {
                //   //       onUserEdited(editedUser);
                //   //     },
                //   //   ),
                //   // ),
                // );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _confirmDeleteUser(context); // Konfirmasi penghapusan pengguna
              },
            ),
          ],
        ),
        
        onTap: () {
          // Do something when card is tapped
        },
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onDelete(user); // Panggil fungsi onDelete dengan pengguna yang dipilih
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}