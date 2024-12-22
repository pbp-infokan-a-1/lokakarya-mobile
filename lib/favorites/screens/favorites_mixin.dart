// favorite_mixin.dart

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

mixin FavoriteMixin {
  Future<bool> checkIsFavorite(BuildContext context, String productId) async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/favourites/json/');
      
      if (response is String) {
        final data = jsonDecode(response);
        if (data['favorites'] is List) {
          final favoriteIds = (data['favorites'] as List)
              .map((fav) => fav['id'].toString())
              .toList();
          return favoriteIds.contains(productId);
        }
      }
      return false;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  Future<void> toggleFavorite(BuildContext context, String productId, bool currentlyFavorited) async {
    try {
      final request = context.read<CookieRequest>();
      final endpoint = currentlyFavorited ? 'remove' : 'add';
      
      final response = await request.post(
        'http://127.0.0.1:8000/favourites/$endpoint/',
        jsonEncode({"product_id": productId}),
      );
      
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentlyFavorited ? "Removed from favorites" : "Added to favorites"),
          ),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to update favorite status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      rethrow;
    }
  }

  Future<Set<String>> fetchFavoriteIds(BuildContext context) async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://127.0.0.1:8000/favourites/json/');
      
      if (response is String) {
        final data = jsonDecode(response);
        if (data['favorites'] is List) {
          return (data['favorites'] as List)
              .map((fav) => fav['id'].toString())
              .toSet();
        }
      }
      return {};
    } catch (e) {
      print('Error fetching favorites: $e');
      return {};
    }
  }
}