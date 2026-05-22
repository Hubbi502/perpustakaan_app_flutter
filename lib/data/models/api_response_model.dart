/// Generic API response wrapper model.
class ApiResponseModel<T> {
  final bool success;
  final String message;
  final T? data;

  const ApiResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponseModel<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}

/// Paginated API response with meta info.
class PaginatedResponseModel<T> {
  final bool success;
  final String message;
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginatedResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList = (json['data'] as List?)
            ?.map((e) => fromJsonT(e as Map<String, dynamic>))
            .toList() ??
        [];

    final meta = json['meta'] as Map<String, dynamic>? ?? {};

    return PaginatedResponseModel<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataList,
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? 15,
      total: meta['total'] ?? 0,
    );
  }
}
