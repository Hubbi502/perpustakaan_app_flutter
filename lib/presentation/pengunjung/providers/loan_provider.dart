import 'package:flutter/material.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/data/repositories/loan_repository_impl.dart';
import 'package:library_app/domain/entities/loan.dart';
import 'package:library_app/domain/repositories/loan_repository.dart';

/// Loan provider for pengunjung — handles borrowing and viewing loans.
class LoanProvider extends ChangeNotifier {
  final LoanRepository _repository;

  LoanProvider({LoanRepository? repository})
      : _repository = repository ?? LoanRepositoryImpl();

  List<Loan> _loans = [];
  bool _isLoading = false;
  String? _error;

  List<Loan> get loans => _loans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Loan> get activeLoans =>
      _loans.where((l) => l.isApproved || l.isPending).toList();
  List<Loan> get historyLoans =>
      _loans.where((l) => l.isReturned || l.isRejected).toList();

  /// Fetch user's loans.
  Future<void> fetchLoans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _loans = await _repository.getLoans();
    } on AppException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Gagal memuat data peminjaman';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create a new loan (borrow a book).
  Future<Loan> createLoan(int bookId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loan = await _repository.createLoan(bookId: bookId);
      _loans.insert(0, loan);
      _isLoading = false;
      notifyListeners();
      return loan;
    } on AppException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Cancel a pending loan.
  Future<void> cancelLoan(int id) async {
    try {
      await _repository.deleteLoan(id);
      _loans.removeWhere((l) => l.id == id);
      notifyListeners();
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
      rethrow;
    }
  }
}
