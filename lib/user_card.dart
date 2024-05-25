import 'package:flutter/material.dart';
import 'package:mobileapp/edit_anggota.dart';
import 'package:mobileapp/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final Function(UserModel) onUserEdited;
  final Function(UserModel) onDelete;

  UserCard({
    required this.user,
    required this.onUserEdited,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubtitleText('No Induk: ${user.noInduk}'),
            _buildSubtitleText('Address: ${user.address}'),
            _buildSubtitleText('Date of Birth: ${user.dateOfBirth}'),
            _buildSubtitleText('Phone Number: ${user.phoneNumber}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAnggotaPage(
                      user: user,
                      onUserEdited: onUserEdited,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                onDelete(user);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitleText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }

  
}
