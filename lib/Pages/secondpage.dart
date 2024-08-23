import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Country {
  final String name;
  final int population;
  final String capital;
  final String currency;
  final String subregion;
  final bool independent;
  final String region;
  final String flagUrl;

  Country({
    required this.name,
    required this.population,
    required this.capital,
    required this.currency,
    required this.subregion,
    required this.independent,
    required this.region,
    required this.flagUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] as String,
      population: json['population'] as int,
      capital: json['capital'] != null ? (json['capital'] as List).join(', ') : 'N/A',
      currency: json['currencies'] != null
          ? (json['currencies'] as Map<String, dynamic>).values.first['name']
          : 'N/A',
      subregion: json['subregion'] ?? 'N/A',
      independent: json['independent'] ?? false,
      region: json['region'] as String,
      flagUrl: json['flags']['png'] as String,
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _countrynameController = TextEditingController();
  Country? _countryResult;

  @override
  void dispose() {
    _countrynameController.dispose();
    super.dispose();
  }

  Future<void> fetchCountryData(String countryName) async {
    final String apiUrl = 'https://restcountries.com/v3.1/name/$countryName';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        final country = Country.fromJson(responseData[0]);
        setState(() {
          _countryResult = country;
        });
      } else {
        _showErrorDialog('Country not found.');
      }
    } else {
      _showErrorDialog(
          'Your input is not a country');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 109, 49, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine the width based on the screen size
          double containerWidth = constraints.maxWidth * 
              (constraints.maxWidth < 600 ? 0.8 : 0.6); // 80% for mobile, 60% for desktop

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 13.0),
                  child: Text(
                    'Country Info',
                    style: TextStyle(
                      fontSize: 20, // Larger font size for the title
                      color: Color.fromARGB(255, 248, 227, 135),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: containerWidth,
                          child: TextFormField(
                            controller: _countrynameController,
                            cursorColor: Color.fromARGB(255, 248, 227, 135),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 248, 227, 135), // Text input color
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Enter Country Name',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 248, 227, 135), // Label text color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 248, 227, 135), // Set the border color
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 248, 227, 135), // Set the focused border color
                                width: 2.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 248, 227, 135), // Disabled border color
                                width: 1.5, // Disabled border thickness
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a country name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: containerWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              fetchCountryData(_countrynameController.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 248, 227, 135), // Set the button color
                            textStyle: const TextStyle(
                              fontSize: 18, // Increase the font size
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Check',
                              style: TextStyle(
                                fontSize: 20, // Larger font size for the title
                                color: Color.fromARGB(255, 109, 49, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Conditionally show the country info box
              if (_countryResult != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        width: containerWidth, // Use the same responsive width
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: const Color.fromARGB(255, 248, 227, 135),
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Name: ${_countryResult!.name}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 227, 135),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Capital: ${_countryResult!.capital}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 227, 135),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Population: ${_countryResult!.population}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 227, 135),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Currency: ${_countryResult!.currency}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 227, 135),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Region: ${_countryResult!.region}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 227, 135),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Subregion: ${_countryResult!.subregion}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 227, 135),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Independence: ${_countryResult!.independent}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 227, 135),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Image.network(
                              _countryResult!.flagUrl,
                              height: 100, // Set height for the flag image
                              width: 150,  // Set width for the flag image
                              fit: BoxFit.cover, // Adjust image to fit within the given size
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  'Flag not available',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 248, 227, 135),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}