import 'package:flutter/material.dart';

class ProgrammaListPage extends StatelessWidget {
  final String leagueName;
  final String userEmail; // Aggiunto il parametro

  ProgrammaListPage({required this.leagueName, required this.userEmail}); // Modificato il costruttore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Programma")),
      body: Center(
        child: Text("Lega: $leagueName, Email: $userEmail"),
      ),
    );
  }
}
