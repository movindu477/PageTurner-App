import 'package:flutter/material.dart';

class BookState extends ChangeNotifier {
  final Map<String, int> _likeCounts = {};
  final Map<String, bool> _likeStatus = {};

  int getLikeCount(String bookTitle) => _likeCounts[bookTitle] ?? 0;
  bool isLiked(String bookTitle) => _likeStatus[bookTitle] ?? false;

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
}