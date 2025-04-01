// book_state.dart
import 'package:flutter/foundation.dart';

class BookState extends ChangeNotifier {
  final Map<String, int> _likeCounts = {};
  final Map<String, bool> _likeStatus = {};
  final Map<String, String> _bookDescriptions = {};

  int getLikeCount(String bookTitle) => _likeCounts[bookTitle] ?? 0;
  bool isLiked(String bookTitle) => _likeStatus[bookTitle] ?? false;
  String getDescription(String bookTitle) => _bookDescriptions[bookTitle] ?? '';

  void toggleLike(String bookTitle) {
    final currentlyLiked = isLiked(bookTitle);
    if (currentlyLiked) {
      _likeCounts[bookTitle] = getLikeCount(bookTitle) - 1;
    } else {
      _likeCounts[bookTitle] = getLikeCount(bookTitle) + 1;
    }
    _likeStatus[bookTitle] = !currentlyLiked;
    notifyListeners();
  }

  void setDescription(String bookTitle, String description) {
    _bookDescriptions[bookTitle] = description;
    notifyListeners();
  }
}
