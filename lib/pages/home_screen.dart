import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ri_bhavuk/bloc/employee_bloc.dart';
import 'package:ri_bhavuk/pages/add_update_employee_data.dart';
import 'package:ri_bhavuk/pages/core/employee_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(title: const Text('Employees')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUpdateEmployeeData(isUpdate: false, index: 0, employeeModel: null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EmployeeBLoC, EmployeeState>(
        buildWhen: (previousState, currentState) {
          return previousState != currentState;
        },
        builder: (context, state) {
          if (state is EmployeeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoadedState) {
            final employees = state.employees;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmployeesList(employees: employees, isCurrentEmployees: true),
                EmployeesList(employees: employees, isCurrentEmployees: false),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Swipe left to delete'),
                ),
              ],
            );
          } else if (state is EmployeeErrorState) {
            return Text('Error: ${state.message}');
          } else if (state is EmployeeNoDataState) {
            return Center(child: Image.asset('assets/images/empty_state.png'));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
