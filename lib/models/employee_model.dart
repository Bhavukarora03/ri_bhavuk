import 'package:equatable/equatable.dart';

class EmployeeModel extends Equatable {
  final String id;
  final String name;
  final String role;
  final DateTime fromDate;
  final DateTime? toDate;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.fromDate,
    this.toDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      fromDate: DateTime.parse(json['fromDate'] as String),
      toDate: json['toDate'] != null ? DateTime.parse(json['toDate'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, role, fromDate, toDate];
}
