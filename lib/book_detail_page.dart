import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_state.dart';

class BookDetailPage extends StatefulWidget {
  final String bookImage;
  final String bookTitle;

  const BookDetailPage({
    super.key,
    required this.bookImage,
    required this.bookTitle,
  });

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> reviews = [];
  final TextEditingController _descriptionController = TextEditingController();
  String bookDescription = "";

  @override
  Widget build(BuildContext context) {
    final bookState = Provider.of<BookState>(context);
    final likeCount = bookState.getLikeCount(widget.bookTitle);
    final isLiked = bookState.isLiked(widget.bookTitle);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Purple Banner with Book Image
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.purple,
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          widget.bookImage,
                          width: 120,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Book Overview",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Book Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.bookTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Description Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: bookDescription.isEmpty
                      ? "Enter book description..."
                      : bookDescription,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        bookDescription = _descriptionController.text;
                        _descriptionController.clear();
                      });
                    },
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    bookDescription = value;
                    _descriptionController.clear();
                  });
                },
              ),
            ),

            // Like & Comment Icons with Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          bookState.toggleLike(widget.bookTitle);
                        },
                      ),
                      Text(likeCount.toString()),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.grey),
                        onPressed: () {
                          _showCommentDialog(context);
                        },
                      ),
                      Text(reviews.length.toString()),
                    ],
                  ),
                ],
              ),
            ),

            // Buttons: Add to Favorites & Download
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle add to favorites
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      "Add to Favorites",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle download
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Download",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Display Book Description if available
            if (bookDescription.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  bookDescription,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

            // User Reviews Section
            Padding(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Reviews",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...reviews.map((review) => reviewBox(review)).toList(),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Write a Review"),
          content: TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              hintText: "Enter your comment...",
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_commentController.text.isNotEmpty) {
                    reviews.add(_commentController.text);
                    _commentController.clear();
                  }
                });
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Widget reviewBox(String review) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(review),
        ),
      ),
    );
  }
}