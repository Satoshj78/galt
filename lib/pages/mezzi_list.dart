import 'package:flutter/material.dart';

class MezziListPage extends StatelessWidget {
  final String leagueName;
  final String userEmail; // Aggiunto il parametro

  MezziListPage({required this.leagueName, required this.userEmail}); // Modificato il costruttore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mezzi")),
      body: Center(
        child: Text("Lega: $leagueName, Email: $userEmail"),
      ),
    );
  }
}
