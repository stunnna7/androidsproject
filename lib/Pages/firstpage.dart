import 'package:flutter/material.dart';
import "secondpage.dart";

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // List of Members to display
  final List<String> members = [
    "Aliyu Faysal", 
    "Aden Terna", 
    "Agbaragu precious", 
    "Afuye Oluwapelumi", 
    "Chukwura Ofala", 
    "Eruvwedede Nancy",
    "Adelegan Oluwatoni",
    "Adako Gbeminiyi",
    "Akomolafe Oluwaseyi",
    "Afolabi Olayemi",
  ];

  // updates the states
  @override
  void initState() {
    super.initState();
  }

  // Function to navigate to the next page when the button is pressed
  _navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SecondPage()),
    );
  }

  // the below is the UI
  @override
  Widget build(BuildContext context) {
    // Get the screen width to adjust the font size responsively
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.05; // Responsive font size

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 109, 49, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text(
                  'Group Members',
                  style: TextStyle(
                    fontSize: fontSize * 1.2, // Larger font size for the title
                    color: Color.fromARGB(255, 248, 227, 135),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Display the list of members in the center
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevents ListView from scrolling independently
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      members[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize, // Responsive font size
                        color: Color.fromARGB(255, 248, 227, 135),
                      ),
                    ),
                  );
                },
              ),

              // Spacer after the list to push it to the center
              const SizedBox(height: 20),

              // Add an "Okay" button to navigate to the next page
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: ElevatedButton(
                  onPressed: _navigateToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 233, 208, 100), // Background color of the button
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 109, 49, 1), // Font color for the button text
                      fontSize: fontSize * 1.1, // Responsive font size for button text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
