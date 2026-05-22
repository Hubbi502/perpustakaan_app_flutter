import 'package:library_app/domain/entities/loan.dart';

/// Abstract loan repository interface.
abstract class LoanRepository {
  Future<List<Loan>> getLoans();
  Future<Loan> getLoan(int id);
  Future<Loan> createLoan({required int bookId});
  Future<Loan> updateLoanStatus(int id, {required String status});
  Future<Loan> returnLoan(int id);
  Future<void> deleteLoan(int id);
}
