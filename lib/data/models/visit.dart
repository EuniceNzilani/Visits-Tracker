import 'package:json_annotation/json_annotation.dart';

part 'visit.g.dart';

@JsonSerializable()
class Visit {
  final int id;
  @JsonKey(name: 'customer_id')
  final int customerId;
  @JsonKey(name: 'visit_date')
  final DateTime visitDate;
  final String status;
  final String location;
  final String notes;
  @JsonKey(name: 'activities_done')
  final List<String> activitiesDone;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Visit({
    required this.id,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
    required this.createdAt,
  });

  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);
  Map<String, dynamic> toJson() => _$VisitToJson(this);
}
