import 'package:flutter/material.dart';
import 'login_page.dart'; // Assuming the login page is in the same directory
import 'addyourbook_page.dart';// Assuming the Add Your Book page is in the same directory

class DashboardPage extends StatefulWidget {
  
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isPanelOpen = false; // Control sliding panel visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Logout Button (Deep Purple Background)
          ElevatedButton(
            onPressed: () {
              // Navigate to the login page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent, // Deep Purple Color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10), // Space after the button

          // Hamburger Menu (Three-Line Icon)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                _isPanelOpen = !_isPanelOpen;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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

          // Sliding Panel (Profile and Plus Icon)
          if (_isPanelOpen)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 250,
              child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "John Doe", // Replace with dynamic name
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "john.doe@example.com", // Replace with dynamic email
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // Plus Icon
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // Navigate to a new page when the plus icon is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DashboardPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      // Floating Action Button (Search and Add Book)
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Search Button
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            child: const Icon(Icons.search),
          ),
          const SizedBox(width: 10),

          // Add Book Button
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              // Navigate to Add Your Book page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddYourBookPage()),
              );
            },
            child: const Icon(Icons.edit),
          ),
        ],
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

// Custom Search Delegate for search functionality
class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text("Searching for: $query"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Suggestions: $query"),
    );
  }
}
