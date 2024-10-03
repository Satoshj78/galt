import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:galt/api/firebase_api.dart'; // Update with your actual Firebase API import
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffFormPage extends StatefulWidget {
  final String leagueName;
  final String staffId;
  final Map<String, dynamic>? data;

  StaffFormPage({
    required this.leagueName,
    required this.staffId,
    this.data,
  });

  @override
  _StaffFormPageState createState() => _StaffFormPageState();
}

class _StaffFormPageState extends State<StaffFormPage> {
  // Controllers for all fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _workGroupController = TextEditingController();
  final TextEditingController _employmentStatusController = TextEditingController();
  final TextEditingController _employmentStartDateController = TextEditingController();
  final TextEditingController _employmentEndDateController = TextEditingController();
  final TextEditingController _companyLevelController = TextEditingController();
  final TextEditingController _internalCodeController = TextEditingController();
  final TextEditingController _externalCodeController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _personalPhoneController = TextEditingController();
  final TextEditingController _personalEmailController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _taxCodeController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _licenseExpiryController = TextEditingController();
  final TextEditingController _cqcExpiryController = TextEditingController();
  final TextEditingController _driverCardExpiryController = TextEditingController();
  final TextEditingController _idDocumentTypeController = TextEditingController();
  final TextEditingController _idDocumentExpiryController = TextEditingController();

  String? _photoUrl;
  String _nameError = '';
  String _surnameError = '';
  String _phoneError = '';
  String _emailError = '';

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      // Initialize all controllers with existing data
      _nameController.text = widget.data!['Nome'] ?? '';
      _surnameController.text = widget.data!['Cognome'] ?? '';
      _phoneController.text = widget.data!['Telefono Personale'] ?? '';
      _emailController.text = widget.data!['Email Personale'] ?? '';
      _workGroupController.text = widget.data!['Gruppo di Lavoro'] ?? '';
      _employmentStatusController.text = widget.data!['Stato Rapporto di Lavoro'] ?? '';
      _employmentStartDateController.text = widget.data!['Data di Inizio Rapporto'] ?? '';
      _employmentEndDateController.text = widget.data!['Data di Fine Rapporto'] ?? '';
      _companyLevelController.text = widget.data!['Inquadramento Aziendale'] ?? '';
      _internalCodeController.text = widget.data!['Codice Interno'] ?? '';
      _externalCodeController.text = widget.data!['Codice Esterno'] ?? '';
      _nationalityController.text = widget.data!['Nazionalità'] ?? '';
      _birthPlaceController.text = widget.data!['Nato in'] ?? '';
      _birthDateController.text = widget.data!['Data di Nascita'] ?? '';
      _addressController.text = widget.data!['Indirizzo di Residenza'] ?? '';
      _personalPhoneController.text = widget.data!['Telefono Personale'] ?? '';
      _personalEmailController.text = widget.data!['Email Personale'] ?? '';
      _companyPhoneController.text = widget.data!['Telefono Aziendale'] ?? '';
      _companyEmailController.text = widget.data!['Email Aziendale'] ?? '';
      _taxCodeController.text = widget.data!['Codice Fiscale'] ?? '';
      _ibanController.text = widget.data!['IBAN'] ?? '';
      _licenseExpiryController.text = widget.data!['Scadenza Patente'] ?? '';
      _cqcExpiryController.text = widget.data!['Scadenza CQC'] ?? '';
      _driverCardExpiryController.text = widget.data!['Scadenza Carta del Conducente'] ?? '';
      _idDocumentTypeController.text = widget.data!['Tipo di Documento Di Riconoscimento'] ?? '';
      _idDocumentExpiryController.text = widget.data!['Scadenza Documento Di Riconoscimento'] ?? '';
      _photoUrl = widget.data!['photoUrl'];
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String url = await FirebaseApi.uploadImage(image); // Assuming FirebaseApi.uploadImage is defined in your Firebase API
      setState(() {
        _photoUrl = url;
      });
    }
  }

  void _validateFields() {
    List<String> emptyFields = [];

    if (_nameController.text.isEmpty) {
      emptyFields.add('Nome');
      setState(() {
        _nameError = 'Campo obbligatorio';
      });
    }
    if (_surnameController.text.isEmpty) {
      emptyFields.add('Cognome');
      setState(() {
        _surnameError = 'Campo obbligatorio';
      });
    }
    if (_phoneController.text.isEmpty) {
      emptyFields.add('Telefono Personale');
      setState(() {
        _phoneError = 'Campo obbligatorio';
      });
    }
    if (_emailController.text.isEmpty) {
      emptyFields.add('Email Personale');
      setState(() {
        _emailError = 'Campo obbligatorio';
      });
    }

    if (emptyFields.isNotEmpty) {
      _showErrorSnackbar(emptyFields);
    } else {
      _saveData();
    }
  }

  void _showErrorSnackbar(List<String> emptyFields) {
    final snackBar = SnackBar(
      content: Text(
        'ATTENZIONE! I seguenti campi sono obbligatori: ${emptyFields.join(", ")}',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red[300]!,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      padding: EdgeInsets.all(3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _saveData() async {
    final updatedData = {
      'Nome': _nameController.text,
      'Cognome': _surnameController.text,
      'Telefono Personale': _phoneController.text,
      'Email Personale': _emailController.text,
      'photoUrl': _photoUrl,
      // Add more fields to save here
      'Gruppo di Lavoro': _workGroupController.text,
      'Stato Rapporto di Lavoro': _employmentStatusController.text,
      'Data di Inizio Rapporto': _employmentStartDateController.text,
      'Data di Fine Rapporto': _employmentEndDateController.text,
      'Inquadramento Aziendale': _companyLevelController.text,
      'Codice Interno': _internalCodeController.text,
      'Codice Esterno': _externalCodeController.text,
      'Nazionalità': _nationalityController.text,
      'Nato in': _birthPlaceController.text,
      'Data di Nascita': _birthDateController.text,
      'Indirizzo di Residenza': _addressController.text,
      'Telefono Personale': _personalPhoneController.text,
      'Email Personale': _personalEmailController.text,
      'Telefono Aziendale': _companyPhoneController.text,
      'Email Aziendale': _companyEmailController.text,
      'Codice Fiscale': _taxCodeController.text,
      'IBAN': _ibanController.text,
      'Scadenza Patente': _licenseExpiryController.text,
      'Scadenza CQC': _cqcExpiryController.text,
      'Scadenza Carta del Conducente': _driverCardExpiryController.text,
      'Tipo di Documento Di Riconoscimento': _idDocumentTypeController.text,
      'Scadenza Documento Di Riconoscimento': _idDocumentExpiryController.text,
    };

    try {
      if (widget.staffId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('leagues')
            .doc(widget.leagueName)
            .collection('Staff')
            .doc(widget.staffId)
            .update(updatedData);
      } else {
        await FirebaseFirestore.instance
            .collection('leagues')
            .doc(widget.leagueName)
            .collection('Staff')
            .add(updatedData);
      }
      Navigator.pop(context, updatedData);
    } catch (e) {
      print('Errore durante il salvataggio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica Staff'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              FocusScope.of(context).unfocus();
              _validateFields();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
                      ? NetworkImage(_photoUrl!)
                      : AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                ),
              ),
              SizedBox(height: 20),

              // Campo per Nome
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  errorText: _nameError.isNotEmpty ? _nameError : null,
                ),
              ),
              SizedBox(height: 10),

              // Campo per Cognome
              TextField(
                controller: _surnameController,
                decoration: InputDecoration(
                  labelText: 'Cognome',
                  errorText: _surnameError.isNotEmpty ? _surnameError : null,
                ),
              ),
              SizedBox(height: 10),

              // Campo per Telefono Personale
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefono Personale',
                  errorText: _phoneError.isNotEmpty ? _phoneError : null,
                ),
              ),
              SizedBox(height: 10),

              // Campo per Email Personale
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Personale',
                  errorText: _emailError.isNotEmpty ? _emailError : null,
                ),
              ),
              SizedBox(height: 10),

              // Campo per Gruppo di Lavoro
              TextField(
                controller: _workGroupController,
                decoration: InputDecoration(labelText: 'Gruppo di Lavoro'),
              ),
              SizedBox(height: 10),

              // Campo per Stato Rapporto di Lavoro
              TextField(
                controller: _employmentStatusController,
                decoration: InputDecoration(labelText: 'Stato Rapporto di Lavoro'),
              ),
              SizedBox(height: 10),

              // Campo per Data di Inizio Rapporto
              TextField(
                controller: _employmentStartDateController,
                decoration: InputDecoration(labelText: 'Data di Inizio Rapporto'),
              ),
              SizedBox(height: 10),

              // Campo per Data di Fine Rapporto
              TextField(
                controller: _employmentEndDateController,
                decoration: InputDecoration(labelText: 'Data di Fine Rapporto'),
              ),
              SizedBox(height: 10),

              // Campo per Inquadramento Aziendale
              TextField(
                controller: _companyLevelController,
                decoration: InputDecoration(labelText: 'Inquadramento Aziendale'),
              ),
              SizedBox(height: 10),

              // Campo per Codice Interno
              TextField(
                controller: _internalCodeController,
                decoration: InputDecoration(labelText: 'Codice Interno'),
              ),
              SizedBox(height: 10),

              // Campo per Codice Esterno
              TextField(
                controller: _externalCodeController,
                decoration: InputDecoration(labelText: 'Codice Esterno'),
              ),
              SizedBox(height: 10),

              // Campo per Nazionalità
              TextField(
                controller: _nationalityController,
                decoration: InputDecoration(labelText: 'Nazionalità'),
              ),
              SizedBox(height: 10),

              // Campo per Nato in
              TextField(
                controller: _birthPlaceController,
                decoration: InputDecoration(labelText: 'Nato in'),
              ),
              SizedBox(height: 10),

              // Campo per Data di Nascita
              TextField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: 'Data di Nascita'),
              ),
              SizedBox(height: 10),

              // Campo per Indirizzo di Residenza
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Indirizzo di Residenza'),
              ),
              SizedBox(height: 10),

              // Campo per Telefono Personale
              TextField(
                controller: _personalPhoneController,
                decoration: InputDecoration(labelText: 'Telefono Personale'),
              ),
              SizedBox(height: 10),

              // Campo per Email Personale
              TextField(
                controller: _personalEmailController,
                decoration: InputDecoration(labelText: 'Email Personale'),
              ),
              SizedBox(height: 10),

              // Campo per Telefono Aziendale
              TextField(
                controller: _companyPhoneController,
                decoration: InputDecoration(labelText: 'Telefono Aziendale'),
              ),
              SizedBox(height: 10),

              // Campo per Email Aziendale
              TextField(
                controller: _companyEmailController,
                decoration: InputDecoration(labelText: 'Email Aziendale'),
              ),
              SizedBox(height: 10),

              // Campo per Codice Fiscale
              TextField(
                controller: _taxCodeController,
                decoration: InputDecoration(labelText: 'Codice Fiscale'),
              ),
              SizedBox(height: 10),

              // Campo per IBAN
              TextField(
                controller: _ibanController,
                decoration: InputDecoration(labelText: 'IBAN'),
              ),
              SizedBox(height: 10),

              // Campo per Scadenza Patente
              TextField(
                controller: _licenseExpiryController,
                decoration: InputDecoration(labelText: 'Scadenza Patente'),
              ),
              SizedBox(height: 10),

              // Campo per Scadenza CQC
              TextField(
                controller: _cqcExpiryController,
                decoration: InputDecoration(labelText: 'Scadenza CQC'),
              ),
              SizedBox(height: 10),

              // Campo per Scadenza Carta del Conducente
              TextField(
                controller: _driverCardExpiryController,
                decoration: InputDecoration(labelText: 'Scadenza Carta del Conducente'),
              ),
              SizedBox(height: 10),

              // Campo per Tipo di Documento di Riconoscimento
              TextField(
                controller: _idDocumentTypeController,
                decoration: InputDecoration(labelText: 'Tipo di Documento di Riconoscimento'),
              ),
              SizedBox(height: 10),

              // Campo per Scadenza Documento di Riconoscimento
              TextField(
                controller: _idDocumentExpiryController,
                decoration: InputDecoration(labelText: 'Scadenza Documento di Riconoscimento'),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
