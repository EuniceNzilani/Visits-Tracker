import '../models/customer.dart';
import '../services/api_service.dart';

class CustomerRepository {
  final ApiService _apiService;

  CustomerRepository(this._apiService);

  Future<List<Customer>> getAllCustomers() async {
    final response = await _apiService.get('/customers');
    return (response.data as List)
        .map((json) => Customer.fromJson(json))
        .toList();
  }

  Future<Customer> getCustomerById(int id) async {
    final response = await _apiService.get(
      '/customers',
      queryParameters: {'id': 'eq.$id'},
    );
    if ((response.data as List).isEmpty) {
      throw Exception('Customer not found');
    }
    return Customer.fromJson(response.data[0]);
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final response = await _apiService.get(
      '/customers',
      queryParameters: {'name': 'ilike.*$query*'},
    );
    return (response.data as List)
        .map((json) => Customer.fromJson(json))
        .toList();
  }
}
