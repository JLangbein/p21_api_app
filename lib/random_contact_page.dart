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
  bool _loadingContact = false;

  @override
  void initState() {
    super.initState();
    _contact = _fetchContact();
  }

  Future<Contact> _fetchContact() async {
    setState(() {
      _loadingContact = true;
    });
    final url = Uri.parse('https://randomuser.me/api/');
    final result = await http.get(url);

    if (result.statusCode != 200) {
      setState(() {
        _loadingContact = false;
      });
      throw Exception('Error: $result.statusCode');
    }

    final data = jsonDecode(result.body);
    final results = data['results'];

    setState(() {
      _loadingContact = false;
    });
    return Contact(
      title: results[0]['name']['title'],
      firstName: results[0]['name']['first'],
      lastName: results[0]['name']['last'],
      street: results[0]['location']['street']['name'],
      number: results[0]['location']['street']['number'],
      city: results[0]['location']['city'],
      state: results[0]['location']['state'],
      country: results[0]['location']['country'],
      // [x] This can be either string or int!
      // Just used the toString() method, since int and String both have them
      postcode: results[0]['location']['postcode'].toString(),
      email: results[0]['email'],
      phone: results[0]['phone'],
      cell: results[0]['cell'],
      immageUrl: results[0]['picture']['medium'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _contact,
      builder: (context, contactSnapshot) {
        // waiting
        if (contactSnapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Random Contact'),
              actions: [
                IconButton(onPressed: null, icon: Icon(Icons.refresh_rounded)),
                IconButton(onPressed: null, icon: Icon(Icons.save_outlined)),
              ],
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // success
        if (contactSnapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Random Contact'),
              actions: [
                IconButton(
                  onPressed: _loadingContact
                      ? null
                      : () {
                          _contact = _fetchContact();
                        },
                  icon: Icon(Icons.refresh_rounded),
                ),
                IconButton(onPressed: null, icon: Icon(Icons.save_outlined)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pic and Name
                    PicAndName(
                      name:
                          '${contactSnapshot.data!.title} ${contactSnapshot.data!.firstName} ${contactSnapshot.data!.lastName}',
                      imamgeUrl: contactSnapshot.data!.immageUrl,
                    ),
                    // Street Address
                    Card(
                      elevation: 4.0,
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: Icon(Icons.location_on_outlined),
                        isThreeLine: true,
                        title: Text(
                          '${contactSnapshot.data!.street} ${contactSnapshot.data!.number}',
                        ),
                        subtitle: Text(
                          '${contactSnapshot.data!.city}, ${contactSnapshot.data!.postcode}\n${contactSnapshot.data!.state}, ${contactSnapshot.data!.country}',
                        ),
                      ),
                    ),
                    // Email
                    Card(
                      elevation: 4.0,
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: Icon(Icons.email_outlined),
                        isThreeLine: false,
                        title: Text(contactSnapshot.data!.email),
                        subtitle: Text('Private'),
                      ),
                    ),
                    // Phone
                    Card(
                      elevation: 4.0,
                      child: Column(
                        spacing: 0.0,
                        children: [
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            leading: Icon(Icons.phone_outlined),
                            isThreeLine: false,
                            title: Text(contactSnapshot.data!.phone),
                            subtitle: Text('Home'),
                          ),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            leading: Icon(Icons.phone_android_outlined),
                            isThreeLine: false,
                            title: Text(contactSnapshot.data!.cell),
                            subtitle: Text('Mobile'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // all has failed
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Random Contact'),
            actions: [
              IconButton(onPressed: null, icon: Icon(Icons.refresh_rounded)),
              IconButton(onPressed: null, icon: Icon(Icons.save_outlined)),
            ],
          ),
          body: Center(child: Icon(Icons.report_outlined)),
        );
      },
    );
  }
}

class PicAndName extends StatefulWidget {
  final String name;
  final String imamgeUrl;

  const PicAndName({super.key, required this.name, required this.imamgeUrl});

  @override
  State<PicAndName> createState() => _PicAndNameState();
}

class _PicAndNameState extends State<PicAndName> {
  String getInitials() {
    List<String> parts = widget.name.split(' ');
    return '${parts[1][0].toUpperCase()}${parts[2][0].toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 64.0,
                foregroundImage: NetworkImage(widget.imamgeUrl),
                child: Text(
                  getInitials(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(widget.name, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
