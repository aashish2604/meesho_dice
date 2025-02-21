import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/services/auth_service.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            await AuthService().signOut();
          },
          child: Text(
            "logout",
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
        ),
      ),
    );
  }
}
