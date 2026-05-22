import 'package:library_app/data/models/book_model.dart';
import 'package:library_app/data/models/user_model.dart';
import 'package:library_app/domain/entities/loan.dart';

/// Loan data model — maps API JSON to domain entity.
class LoanModel {
  final int id;
  final UserModel? user;
  final BookModel? book;
  final int? userId;
  final int? bookId;
  final String status;
  final String? borrowDate;
  final String? dueDate;
  final String? returnDate;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  const LoanModel({
    required this.id,
    this.user,
    this.book,
    this.userId,
    this.bookId,
    required this.status,
    this.borrowDate,
    this.dueDate,
    this.returnDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] ?? 0,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      book: json['book'] != null ? BookModel.fromJson(json['book']) : null,
      userId: json['user_id'],
      bookId: json['book_id'],
      status: json['status'] ?? 'pending',
      borrowDate: json['borrow_date'],
      dueDate: json['due_date'],
      returnDate: json['return_date'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Loan toEntity() {
    return Loan(
      id: id,
      user: user?.toEntity(),
      book: book?.toEntity(),
      userId: userId,
      bookId: bookId,
      status: status,
      borrowDate: borrowDate,
      dueDate: dueDate,
      returnDate: returnDate,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
