import 'package:flutter/material.dart';

class FerieListPage extends StatelessWidget {
  final String leagueName;
  final String userEmail; // Aggiunto il parametro

  FerieListPage({required this.leagueName, required this.userEmail}); // Modificato il costruttore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ferie")),
      body: Center(
        child: Text("Lega: $leagueName, Email: $userEmail"),
      ),
    );
  }
}
