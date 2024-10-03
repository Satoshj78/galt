import 'package:flutter/material.dart';
import 'package:galt/pages/staff_list.dart';
import 'package:galt/pages/richiesta_list.dart';
import 'package:galt/pages/ferie_list.dart';
import 'package:galt/pages/mezzi_list.dart';
import 'package:galt/pages/bilancio_list.dart';
import 'package:galt/pages/programma_list.dart';

class HomePage extends StatefulWidget {
  final String leagueName;
  final String userEmail;

  HomePage({required this.leagueName, required this.userEmail});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isCartellinoExpanded = false;
  late AnimationController _controller;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _pages.addAll([
      _buildHomeBody(),
      RichiestaListPage(leagueName: widget.leagueName, userEmail: widget.userEmail),
      FerieListPage(leagueName: widget.leagueName, userEmail: widget.userEmail),
      MezziListPage(leagueName: widget.leagueName, userEmail: widget.userEmail),
      StaffListPage(leagueName: widget.leagueName, userEmail: widget.userEmail),
      BilancioListPage(leagueName: widget.leagueName, userEmail: widget.userEmail),
      ProgrammaListPage(leagueName: widget.leagueName, userEmail: widget.userEmail),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Richieste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'Ferie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Mezzi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Bilancio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Programma',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(), // Occupiamo spazio sopra
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true, // Permette al GridView di occupare solo lo spazio necessario
            physics: NeverScrollableScrollPhysics(), // Disabilita lo scrolling del GridView
            children: [
              _buildHomeButton(Icons.local_gas_station, 'Rifornimento'),
              _buildHomeButton(Icons.local_car_wash, 'Lavaggio'),
              _buildHomeButton(Icons.beach_access, 'Richiesta Ferie'),
              _buildHomeButton(Icons.checkroom, 'Richiesta Attrezzature'),
              _buildHomeButton(Icons.handyman, 'Richiesta Manutenzione'),
              _buildHomeButton(Icons.more_horiz, 'Altro'),
            ],
          ),
          SizedBox(height: 16), // Padding tra i bottoni e il cartellino
          _buildCartellino(),
        ],
      ),
    );
  }

  Widget _buildCartellino() {
    return GestureDetector(
      onTap: _toggleCartellino,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'CARTELLINO',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 0.05),
            SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  border: Border.all(color: Colors.green, width: 3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCartellinoButton('Inizio Lavoro'),
                        _buildCartellinoButton('Fine Lavoro'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCartellino() {
    setState(() {
      _isCartellinoExpanded = !_isCartellinoExpanded;
      if (_isCartellinoExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget _buildHomeButton(IconData icon, String label) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartellinoButton(String label) {
    return GestureDetector(
      onTap: () {
        _showConfirmationDialog(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _showConfirmationDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conferma $action'),
          content: Text('Sei sicuro di voler registrare $action?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Conferma'),
            ),
          ],
        );
      },
    );
  }
}
