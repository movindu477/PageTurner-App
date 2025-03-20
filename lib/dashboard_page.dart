import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              margin: const EdgeInsets.all(10),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/book20.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                "TRANQUILITY OF BLOOD",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Section: We Think You'll Enjoy
            sectionTitle("We think you'll enjoy"),
            buildHorizontalBookList([
              'assets/images/book1.jpg',
              'assets/images/book3.jpg',
              'assets/images/book4.jpg',
              'assets/images/book5.jpg',
            ]),

            // Section: Your Next Read
            sectionTitle("Your Next Read"),
            buildHorizontalBookList([
              'assets/images/book6.jpg',
              'assets/images/book7.jpg',
              'assets/images/book8.jpg',
              'assets/images/book9.jpg',
            ]),

            // Featured Story
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: ListTile(
                  leading: Image.asset("assets/images/book11.jpg", width: 60),
                  title: const Text("The Way of the Nameless"),
                  subtitle: const Text("65.8K readers"),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Read Now"),
                  ),
                ),
              ),
            ),

            // Section: Picked for You
            sectionTitle("Picked For You"),
            buildHorizontalBookList([
              'assets/images/book10.jpg',
              'assets/images/book12.jpg',
              'assets/images/book13.jpg',
              'assets/images/book14.jpg'
            ]),

            // Downloadable Book Section
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Image.asset("assets/images/book12.jpg", width: 60),
                      title: const Text("To Kill a Mockingbird"),
                      subtitle: const Text("60.8K downloads"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("DOWNLOAD"),
                      ),
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

  // Function to create section title
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Function to create horizontal book list with specific images
  Widget buildHorizontalBookList(List<String> imgPaths) {
    return SizedBox(
      height: 140,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: imgPaths.map((imgPath) => bookItem(imgPath)).toList(),
        ),
      ),
    );
  }

  // Function to create individual book items
  Widget bookItem(String imgPath) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(imgPath, width: 100, fit: BoxFit.cover),
      ),
    );
  }
}