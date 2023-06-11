import 'dart:convert';

import 'package:ri_bhavuk/models/employee_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeRepository {
  static const String _employeeListKey = 'employee_list';

  Future<List<EmployeeModel>> getEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = prefs.getStringList(_employeeListKey);

    if (jsonStringList != null) {
      return jsonStringList.map((json) => EmployeeModel.fromJson(jsonDecode(json))).toList();
    } else {
      return [];
    }
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    final prefs = await SharedPreferences.getInstance();
    final employeeList = await getEmployees();

    if (employeeList.any((e) => e.id == employee.id)) {
      throw Exception('Employee with ID ${employee.id} already exists.');
    }

    employeeList.add(employee);
    final jsonStringList = employeeList.map((employee) => jsonEncode(employee.toJson())).toList();
    await prefs.setStringList(_employeeListKey, jsonStringList);
  }

  Future<void> updateEmployee(EmployeeModel employee) async {
    final prefs = await SharedPreferences.getInstance();
    final employeeList = await getEmployees();
    final index = employeeList.indexWhere((e) => e.id == employee.id);

    if (index != -1) {
      employeeList[index] = employee;
      final jsonStringList = employeeList.map((employee) => jsonEncode(employee.toJson())).toList();
      await prefs.setStringList(_employeeListKey, jsonStringList);
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    final employeeList = await getEmployees();
    employeeList.removeWhere((e) => e.id == employeeId);
    final jsonStringList = employeeList.map((employee) => jsonEncode(employee.toJson())).toList();
    await prefs.setStringList(_employeeListKey, jsonStringList);
  }
}
