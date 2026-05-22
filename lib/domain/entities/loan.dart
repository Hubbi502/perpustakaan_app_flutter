import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/domain/entities/user.dart';

/// Loan entity — domain layer representation.
class Loan {
  final int id;
  final User? user;
  final Book? book;
  final int? userId;
  final int? bookId;
  final String status;
  final String? borrowDate;
  final String? dueDate;
  final String? returnDate;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  const Loan({
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

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isReturned => status == 'returned';
  bool get isRejected => status == 'rejected';

  bool get isOverdue {
    if (!isApproved || dueDate == null) return false;
    try {
      return DateTime.parse(dueDate!).isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  Loan copyWith({
    int? id,
    User? user,
    Book? book,
    int? userId,
    int? bookId,
    String? status,
    String? borrowDate,
    String? dueDate,
    String? returnDate,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) {
    return Loan(
      id: id ?? this.id,
      user: user ?? this.user,
      book: book ?? this.book,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      status: status ?? this.status,
      borrowDate: borrowDate ?? this.borrowDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
