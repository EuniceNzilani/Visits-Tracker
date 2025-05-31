import '../models/activity.dart';
import '../services/api_service.dart';

class ActivityRepository {
  final ApiService _apiService;

  ActivityRepository(this._apiService);

  Future<List<Activity>> getAllActivities() async {
    final response = await _apiService.get('/activities');
    return (response.data as List)
        .map((json) => Activity.fromJson(json))
        .toList();
  }

  Future<Activity> getActivityById(int id) async {
    final response = await _apiService.get(
      '/activities',
      queryParameters: {'id': 'eq.$id'},
    );
    if ((response.data as List).isEmpty) {
      throw Exception('Activity not found');
    }
    return Activity.fromJson(response.data[0]);
  }

  Future<List<Activity>> getActivitiesByIds(List<String> ids) async {
    final response = await _apiService.get(
      '/activities',
      queryParameters: {'id': 'in.(${ids.join(",")})'},
    );
    return (response.data as List)
        .map((json) => Activity.fromJson(json))
        .toList();
  }
}
