import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p21_api_app/contact.dart';

class RandomContactPage extends StatefulWidget {
  const RandomContactPage({super.key});

  @override
  State<RandomContactPage> createState() => _RandomContactPageState();
}

class _RandomContactPageState extends State<RandomContactPage> {
  late Future<Contact> _contact;
  final bool _loadingContact = false;
  final bool _loadingImage = false;

  @override
  void initState() {
    super.initState();
    _contact = _fetchContact();
  }

  Future<Contact> _fetchContact() async {
    final url = Uri.parse('https://randomuser.me/api/');
    final result = await http.get(url);

    if (result.statusCode != 200) {
      throw Exception('Error: $result.statusCode');
    }

    final data = jsonDecode(result.body);
    final results = data['results'];

    return Contact(
      title: results[0]['name']['title'],
      firstName: results[0]['name']['first'],
      lastName: results[0]['name']['last'],
      street: results[0]['location']['street']['name'],
      number: results[0]['location']['street']['number'],
      city: results[0]['location']['city'],
      state: results[0]['location']['state'],
      country: results[0]['location']['country'],
      postcode: results[0]['location']['postcode'],
      email: results[0]['email'],
      phone: results[0]['phone'],
      cell: results[0]['cell'],
      immageUrl: results[0]['picture']['medium'], 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Hello World!')));
  }
}
