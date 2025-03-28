import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTravelScreen extends StatefulWidget {
  const UserTravelScreen({super.key});

  @override
  State<UserTravelScreen> createState() => _UserTravelScreenState();
}

class _UserTravelScreenState extends State<UserTravelScreen> {
  static const String userNameKey = 'username';
  static const String userAgeKey = 'user_age';
  static const String userCoutryKey = 'user_country';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informações do Viajante: ')),
      body: _buildUserTravelScreenBody(),
    );
  }
  
  Future<void> _loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _nameController.text = prefs.getString('username') ?? "";
    _ageController.text = prefs.getInt('user_age')?.toString() ?? "";
    _countryController.text = prefs.getString('user_country') ?? "";
  });
}

void _saveUserData() async {
  String name = _nameController.text;
  int age = int.tryParse(_ageController.text) ?? 0;
  String country = _countryController.text;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', name);
  await prefs.setInt('user_age', age);
  await prefs.setString('user_country', country);
}
String getCountryFlag(String countryCode) {
    if (countryCode.length != 2 || !RegExp(r'^[A-Z]{2}$').hasMatch(countryCode)) return '🏳️';
    return String.fromCharCode(0x1F1E6 + countryCode.codeUnitAt(0) - 'A'.codeUnitAt(0)) +
           String.fromCharCode(0x1F1E6 + countryCode.codeUnitAt(1) - 'A'.codeUnitAt(0));
  }
_buildUserTravelScreenBody(){
  return Column(
    children: [
      TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Nome'),
        ),
        TextField(
          controller: _ageController,
          decoration: InputDecoration(labelText: 'Idade'),
          keyboardType: TextInputType.number,
        ),
        TextField(
            controller: _countryController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'País',
              suffixText: getCountryFlag(_countryController.text.toUpperCase()),
            ),
            onChanged: (text) {
              setState(() {}); // Atualiza a bandeira ao digitar
            },
          ),
        Row(
          children: [
            ElevatedButton(onPressed: _saveUserData, child: Text('Salvar dados')),
            ElevatedButton(onPressed: _loadUserData, child: Text('Carregar da memória')),
            ElevatedButton(onPressed: _resetUserData, child: Text('Limpar dados')),
          ],
        )
    ],
  );
}


void _resetUserData() async {
    setState(() {
      _nameController.text = "";
      _ageController.text = "";
      _countryController.text = "";
    });
  }
}

