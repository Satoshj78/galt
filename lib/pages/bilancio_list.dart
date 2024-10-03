import 'package:flutter/material.dart';

class BilancioListPage extends StatelessWidget {
  final String leagueName;
  final String userEmail; // Aggiunto il parametro

  BilancioListPage({required this.leagueName, required this.userEmail}); // Modificato il costruttore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bilancio")),
      body: Center(
        child: Text("Lega: $leagueName, Email: $userEmail"),
      ),
    );
  }
}
