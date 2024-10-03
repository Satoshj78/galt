import 'package:flutter/material.dart';
import 'package:galt/form/staff_form.dart';

class StaffDetailPage extends StatefulWidget {
  final String staffId;
  final Map<String, dynamic> data;
  final String leagueName;

  StaffDetailPage({
    required this.staffId,
    required this.data,
    required this.leagueName,
  });

  @override
  _StaffDetailPageState createState() => _StaffDetailPageState();
}

class _StaffDetailPageState extends State<StaffDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _photoHeight = 300.0;
  double _opacity = 1.0;
  double _smallAvatarPosition = -50.0;

  late Map<String, dynamic> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.data;
    _scrollController.addListener(() {
      setState(() {
        _photoHeight = (300.0 - _scrollController.offset).clamp(0.0, 300.0);
        _opacity = (_photoHeight / 300.0).clamp(0.0, 1.0);
        _smallAvatarPosition = (_scrollController.offset / 8).clamp(-50.0, 0.0);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 8.0),
              Text(
                'Dettagli',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StaffFormPage(
                    leagueName: widget.leagueName,
                    staffId: widget.staffId,
                    data: _currentData,
                  ),
                ),
              );

              if (updatedData != null) {
                setState(() {
                  _currentData = updatedData; // Update local data
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _photoHeight,
            child: Center(
              child: Opacity(
                opacity: _opacity,
                child: CircleAvatar(
                  radius: 150,
                  backgroundImage: (_currentData['photoUrl'] != null && _currentData['photoUrl'].isNotEmpty)
                      ? NetworkImage(_currentData['photoUrl'])
                      : AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(_smallAvatarPosition, 0),
                  child: Opacity(
                    opacity: 1.0 - _opacity,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: (_currentData['photoUrl'] != null && _currentData['photoUrl'].isNotEmpty)
                          ? NetworkImage(_currentData['photoUrl'])
                          : AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Container(
                    height: 42,
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${_currentData['Cognome'] ?? ''} ${_currentData['Nome'] ?? ''}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
              ],
            ),
          ),
          Container(
            height: 2,
            color: Colors.white,
            margin: EdgeInsets.only(top: 10.0),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGroupContainer(
                      'ID Utente',
                      [
                        _buildDetailRow('Gruppo di Lavoro:', _currentData['Gruppo di Lavoro']),
                        _buildDetailRow('Stato del Rapporto di Lavoro:', _currentData['Stato Rapporto di Lavoro']),
                        _buildDetailRow('Data di Inizio Rapporto:', _currentData['Data di Inizio Rapporto']),
                        _buildDetailRow('Data di Fine Rapporto:', _currentData['Data di Fine Rapporto']),
                        _buildDetailRow('Inquadramento Aziendale:', _currentData['Inquadramento Aziendale']),
                        _buildDetailRow('Codice Interno:', _currentData['Codice Interno']),
                        _buildDetailRow('Codice Esterno:', _currentData['Codice Esterno']),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    _buildGroupContainer(
                      'Dati Anagrafici',
                      [
                        _buildDetailRow('Nazionalità:', _currentData['Nazionalità']),
                        _buildDetailRow(
                            'Nato in:',
                            '${_currentData['Nato in'] ?? ''}, ${_currentData['Nato a'] ?? ''}, ${_currentData['Prov'] ?? ''}'
                        ),
                        _buildDetailRow('Data di Nascita:', _currentData['Data di Nascita']),
                        _buildDetailRow('Indirizzo di Residenza:', _currentData['Indirizzo di Residenza']),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    _buildGroupContainer(
                      'Recapiti',
                      [
                        _buildDetailRow('Telefono Personale:', _currentData['Telefono Personale']),
                        _buildDetailRow('Email Personale:', _currentData['Email Personale']),
                        _buildDetailRow('Telefono Aziendale:', _currentData['Telefono Aziendale']),
                        _buildDetailRow('Email Aziendale:', _currentData['Email Aziendale']),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    _buildGroupContainer(
                      'Dati Fiscali',
                      [
                        _buildDetailRow('Codice Fiscale:', _currentData['Codice Fiscale']),
                        _buildDetailRow('IBAN:', _currentData['IBAN']),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    _buildGroupContainer(
                      'Documenti Personali',
                      [
                        _buildDetailRow('Scadenza Patente:', _currentData['Scadenza Patente']),
                        _buildDetailRow('Scadenza CQC:', _currentData['Scadenza CQC']),
                        _buildDetailRow('Scadenza Carta del Conducente:', _currentData['Scadenza Carta del Conducente']),
                        _buildDetailRow('Documento Di Riconoscimento:', _currentData['Tipo di Documento Di Riconoscimento']),
                        _buildDetailRow('Scadenza Doc. Di Riconoscimento:', _currentData['Scadenza Documento Di Riconoscimento']),
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
  }

  Widget _buildGroupContainer(String title, List<Widget> details) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[200], // You might want to adjust this to use a color from your theme
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 8.0),
          ...details,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
        Text(value ?? 'N/A', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}
