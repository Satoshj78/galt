import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:galt/detail/staff_detail.dart';
import 'package:galt/form/staff_form.dart';

class StaffListPage extends StatefulWidget {
  final String leagueName;
  final String userEmail;

  StaffListPage({required this.leagueName, required this.userEmail});

  @override
  _StaffListPageState createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Forza la ricostruzione quando cambia tab
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getFilteredStream(int index) {
    Query query = FirebaseFirestore.instance
        .collection('leagues')
        .doc(widget.leagueName)
        .collection('Staff');

    switch (index) {
      case 1:
        query = query.where('Inquadramento Aziendale', isEqualTo: 'Dipendente');
        break;
      case 2:
        query = query.where('Inquadramento Aziendale', isEqualTo: 'Ex Dipendente');
        break;
      case 3:
        query = query.where('Inquadramento Aziendale', isEqualTo: 'Collaboratore');
        break;
      case 4:
        query = query.where('Inquadramento Aziendale', isEqualTo: 'Ex Collaboratore');
        break;
      default:
        break;
    }

    return query.snapshots();
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      icon: Icon(icon),
      text: label,
    );
  }

  int _calculateAge(String birthDateStr) {
    List<String> parts = birthDateStr.split('/');
    if (parts.length == 3) {
      String formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}';
      DateTime birthDate = DateTime.parse(formattedDate);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    }
    return 0;
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.group, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Staff',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StaffFormPage(
                    leagueName: widget.leagueName,
                    staffId: '',
                    data: {},
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.green, width: 3.0),
            ),
          ),
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          tabs: [
            _buildTab(Icons.groups, 'Tutti'),
            _buildTab(Icons.person, 'Dipendenti'),
            _buildTab(Icons.person_off, 'Ex Dipendenti'),
            _buildTab(Icons.handshake, 'Collaboratori'),
            _buildTab(Icons.cancel, 'Ex Collaboratori'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getFilteredStream(_tabController.index),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Caricamento dati, attendere...', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Errore nel caricamento dei dati: ${snapshot.error}', style: TextStyle(color: Colors.red, fontSize: 16)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nessun membro dello staff trovato.'));
          }

          final staff = snapshot.data!.docs;

          return ListView.builder(
            itemCount: staff.length,
            itemBuilder: (context, index) {
              final user = staff[index];
              final data = user.data() as Map<String, dynamic>? ?? {};

              final String cognome = data['Cognome'] ?? '';
              final String nome = data['Nome'] ?? '';
              final String numeroTelefono = data['Telefono Personale'] ?? '';
              final String codiceAutista = data['Codice Esterno Autista'] ?? '';
              final String gruppoLavoro = data['Gruppo di Lavoro'] ?? '';
              final String birthDate = data['Data di Nascita'] ?? '';
              final int eta = (birthDate.isNotEmpty) ? _calculateAge(birthDate) : 0;
              final String profileImageUrl = data['photoUrl'] ?? '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaffDetailPage(
                        leagueName: widget.leagueName,
                        staffId: user.id,
                        data: data,
                      ),
                    ),
                  );
                },
                child: ExpansionTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '$cognome $nome',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _makePhoneCall(numeroTelefono);
                              },
                              child: Icon(Icons.phone, color: Colors.grey),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              numeroTelefono.isNotEmpty ? numeroTelefono : '',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Età: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              eta > 0 ? eta.toString() : '',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 55.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Codice Autista: ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    codiceAutista,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Gruppo di lavoro: ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    gruppoLavoro,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}