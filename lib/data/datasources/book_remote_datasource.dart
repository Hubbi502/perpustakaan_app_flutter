import 'dart:io';
import 'package:library_app/core/constants/api_constants.dart';
import 'package:library_app/core/network/api_client.dart';
import 'package:library_app/data/models/book_model.dart';

/// Remote data source for book API calls.
class BookRemoteDatasource {
  final ApiClient _client;

  BookRemoteDatasource({ApiClient? client}) : _client = client ?? ApiClient.instance;

  Future<({List<BookModel> books, int currentPage, int lastPage, int perPage, int total})> getBooks({
    int page = 1,
  }) async {
    final response = await _client.get(
      ApiConstants.books,
      queryParams: {'page': page.toString()},
    );

    final dataList = (response['data'] as List)
        .map((e) => BookModel.fromJson(e))
        .toList();

    final meta = response['meta'] ?? {};

    return (
      books: dataList,
      currentPage: (meta['current_page'] as int?) ?? page,
      lastPage: (meta['last_page'] as int?) ?? 1,
      perPage: (meta['per_page'] as int?) ?? 15,
      total: (meta['total'] as int?) ?? dataList.length,
    );
  }

  Future<BookModel> getBook(int id) async {
    final response = await _client.get(ApiConstants.bookById(id));
    return BookModel.fromJson(response['data']);
  }

  Future<BookModel> createBook({
    required String title,
    required String description,
    required String author,
    required int categoryId,
    File? coverImage,
  }) async {
    final fields = {
      'title': title,
      'description': description,
      'author': author,
      'category_id': categoryId.toString(),
    };

    final files = <String, File>{};
    if (coverImage != null) {
      files['cover_image'] = coverImage;
    }

    final response = await _client.postMultipart(
      ApiConstants.books,
      fields: fields,
      files: files.isNotEmpty ? files : null,
    );

    return BookModel.fromJson(response['data']);
  }

  Future<BookModel> updateBook(
    int id, {
    String? title,
    String? description,
    String? author,
    int? categoryId,
    File? coverImage,
  }) async {
    final fields = <String, String>{};
    if (title != null) fields['title'] = title;
    if (description != null) fields['description'] = description;
    if (author != null) fields['author'] = author;
    if (categoryId != null) fields['category_id'] = categoryId.toString();

    final files = <String, File>{};
    if (coverImage != null) {
      files['cover_image'] = coverImage;
    }

    // If there's a file, use multipart with _method=PUT
    if (files.isNotEmpty) {
      final response = await _client.putMultipart(
        ApiConstants.bookById(id),
        fields: fields,
        files: files,
      );
      return BookModel.fromJson(response['data']);
    }

    // Otherwise, use regular PUT
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (author != null) body['author'] = author;
    if (categoryId != null) body['category_id'] = categoryId;

    final response = await _client.put(
      ApiConstants.bookById(id),
      body: body,
    );
    return BookModel.fromJson(response['data']);
  }

  Future<void> deleteBook(int id) async {
    await _client.delete(ApiConstants.bookById(id));
  }
}
