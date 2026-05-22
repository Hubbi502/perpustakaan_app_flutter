import 'package:flutter/material.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/data/repositories/loan_repository_impl.dart';
import 'package:library_app/domain/entities/loan.dart';
import 'package:library_app/domain/repositories/loan_repository.dart';

/// Loan management provider for petugas — handles approvals and returns.
class LoanManagementProvider extends ChangeNotifier {
  final LoanRepository _repository;

  LoanManagementProvider({LoanRepository? repository})
      : _repository = repository ?? LoanRepositoryImpl();

  List<Loan> _loans = [];
  bool _isLoading = false;
  String? _error;

  List<Loan> get loans => _loans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Loan> get pendingLoans => _loans.where((l) => l.isPending).toList();
  List<Loan> get activeLoans => _loans.where((l) => l.isApproved).toList();
  List<Loan> get completedLoans => _loans.where((l) => l.isReturned || l.isRejected).toList();
  int get overdueCount => _loans.where((l) => l.isOverdue).length;

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

  Future<void> approveLoan(int id) async {
    final loan = await _repository.updateLoanStatus(id, status: 'approved');
    _updateLoanInList(loan);
  }

  Future<void> rejectLoan(int id) async {
    final loan = await _repository.updateLoanStatus(id, status: 'rejected');
    _updateLoanInList(loan);
  }

  Future<void> returnLoan(int id) async {
    final loan = await _repository.returnLoan(id);
    _updateLoanInList(loan);
  }

  void _updateLoanInList(Loan loan) {
    final index = _loans.indexWhere((l) => l.id == loan.id);
    if (index != -1) {
      _loans[index] = loan;
    }
    notifyListeners();
  }
}
