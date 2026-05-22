import 'package:library_app/data/datasources/loan_remote_datasource.dart';
import 'package:library_app/domain/entities/loan.dart';
import 'package:library_app/domain/repositories/loan_repository.dart';

/// Concrete implementation of [LoanRepository].
class LoanRepositoryImpl implements LoanRepository {
  final LoanRemoteDatasource _remote;

  LoanRepositoryImpl({LoanRemoteDatasource? remote})
      : _remote = remote ?? LoanRemoteDatasource();

  @override
  Future<List<Loan>> getLoans() async {
    final result = await _remote.getLoans();
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Loan> getLoan(int id) async {
    final result = await _remote.getLoan(id);
    return result.toEntity();
  }

  @override
  Future<Loan> createLoan({required int bookId}) async {
    final result = await _remote.createLoan(bookId: bookId);
    return result.toEntity();
  }

  @override
  Future<Loan> updateLoanStatus(int id, {required String status}) async {
    final result = await _remote.updateLoanStatus(id, status: status);
    return result.toEntity();
  }

  @override
  Future<Loan> returnLoan(int id) async {
    final result = await _remote.returnLoan(id);
    return result.toEntity();
  }

  @override
  Future<void> deleteLoan(int id) async {
    await _remote.deleteLoan(id);
  }
}
