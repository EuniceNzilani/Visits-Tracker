import '../models/visit.dart';
import '../services/api_service.dart';

class VisitRepository {
  final ApiService _apiService;

  VisitRepository(this._apiService);

  Future<List<Visit>> getVisits({Map<String, dynamic>? filters}) async {
    final response = await _apiService.get('/visits', queryParameters: filters);
    return (response.data as List).map((json) => Visit.fromJson(json)).toList();
  }

  Future<Visit> createVisit(Visit visit) async {
    final response = await _apiService.post('/visits', data: visit.toJson());
    return Visit.fromJson(response.data);
  }

  Future<List<Visit>> getVisitsForCustomer(int customerId) async {
    return getVisits(filters: {'customer_id': 'eq.$customerId'});
  }

  Future<Map<String, int>> getVisitStatistics() async {
    final visits = await getVisits();
    return {
      'total': visits.length,
      'completed': visits.where((v) => v.status == 'Completed').length,
      'pending': visits.where((v) => v.status == 'Pending').length,
      'cancelled': visits.where((v) => v.status == 'Cancelled').length,
    };
  }
}
