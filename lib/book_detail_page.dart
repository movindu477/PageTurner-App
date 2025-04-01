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
  bool _showDescriptionInput = false;

  @override
  void initState() {
    super.initState();
    final bookState = Provider.of<BookState>(context, listen: false);
    final existingDescription = bookState.getDescription(widget.bookTitle);
    if (existingDescription.isNotEmpty) {
      _descriptionController.text = existingDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookState = Provider.of<BookState>(context);
    final likeCount = bookState.getLikeCount(widget.bookTitle);
    final isLiked = bookState.isLiked(widget.bookTitle);
    final bookDescription = bookState.getDescription(widget.bookTitle);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Book Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Book Cover Image
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.deepPurple[800],
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    widget.bookImage,
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Book Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.bookTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Description Section
            if (bookDescription.isEmpty || _showDescriptionInput)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Enter book description...",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.check, color: Colors.deepPurple[800]),
                      onPressed: () => _submitDescription(bookState),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16, height: 1.5),
                  onSubmitted: (_) => _submitDescription(bookState),
                ),
              ),

            if (bookDescription.isNotEmpty && !_showDescriptionInput)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        bookDescription,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showDescriptionInput = true;
                          _descriptionController.text = bookDescription;
                        });
                      },
                      child: Text(
                        "Edit Description",
                        style: TextStyle(
                          color: Colors.deepPurple[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Like Button
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.red : Colors.grey[600],
                    ),
                    label: Text(
                      likeCount.toString(),
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    onPressed: () => bookState.toggleLike(widget.bookTitle),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey[800],
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),

                  // Comment Button
                  ElevatedButton.icon(
                    icon: Icon(Icons.comment, color: Colors.grey[600]),
                    label: Text(
                      reviews.length.toString(),
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    onPressed: () => _showCommentDialog(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey[800],
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[800],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Add to Favorites",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Download",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Reviews Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Row(
                children: [
                  Text(
                    "Reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showCommentDialog(context),
                    child: Text(
                      "Add Review",
                      style: TextStyle(
                        color: Colors.deepPurple[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...reviews.map((review) => reviewBox(review)),
          ],
        ),
      ),
    );
  }

  void _submitDescription(BookState bookState) {
    if (_descriptionController.text.isNotEmpty) {
      bookState.setDescription(widget.bookTitle, _descriptionController.text);
      setState(() {
        _showDescriptionInput = false;
      });
    }
  }

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Write a Review",
            style: TextStyle(color: Colors.deepPurple[800]),
          ),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: "Enter your review...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  setState(() {
                    reviews.add(_commentController.text);
                    _commentController.clear();
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[800],
              ),
              child:
                  const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget reviewBox(String review) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            review,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
      ),
    );
  }
}
