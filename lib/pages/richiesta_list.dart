import 'package:flutter/material.dart';

class RichiestaListPage extends StatelessWidget {
  final String leagueName;
  final String userEmail; // Aggiunto il parametro

  RichiestaListPage({required this.leagueName, required this.userEmail}); // Modificato il costruttore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Richieste")),
      body: Center(
        child: Text("Lega: $leagueName, Email: $userEmail"),
      ),
    );
  }
}
