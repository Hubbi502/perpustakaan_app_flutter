import 'package:library_app/core/constants/api_constants.dart';
import 'package:library_app/core/network/api_client.dart';
import 'package:library_app/data/models/loan_model.dart';

/// Remote data source for loan API calls.
class LoanRemoteDatasource {
  final ApiClient _client;

  LoanRemoteDatasource({ApiClient? client}) : _client = client ?? ApiClient.instance;

  Future<List<LoanModel>> getLoans() async {
    final response = await _client.get(ApiConstants.loans);
    return (response['data'] as List)
        .map((e) => LoanModel.fromJson(e))
        .toList();
  }

  Future<LoanModel> getLoan(int id) async {
    final response = await _client.get(ApiConstants.loanById(id));
    return LoanModel.fromJson(response['data']);
  }

  Future<LoanModel> createLoan({required int bookId}) async {
    final response = await _client.post(
      ApiConstants.loans,
      body: {'book_id': bookId},
    );
    return LoanModel.fromJson(response['data']);
  }

  Future<LoanModel> updateLoanStatus(int id, {required String status}) async {
    final response = await _client.put(
      ApiConstants.loanById(id),
      body: {'status': status},
    );
    return LoanModel.fromJson(response['data']);
  }

  Future<LoanModel> returnLoan(int id) async {
    final response = await _client.put(ApiConstants.returnLoan(id));
    return LoanModel.fromJson(response['data']);
  }

  Future<void> deleteLoan(int id) async {
    await _client.delete(ApiConstants.loanById(id));
  }
}
