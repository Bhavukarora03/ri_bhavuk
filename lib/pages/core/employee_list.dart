import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ri_bhavuk/bloc_classes/employee_bloc.dart';
import 'package:ri_bhavuk/models/employee_model.dart';
import 'package:ri_bhavuk/pages/add_update_employee_data.dart';
import 'package:ri_bhavuk/theme/theme.dart';

class EmployeesList extends StatelessWidget {
  final List<EmployeeModel> employees;
  final bool isCurrentEmployees;

  const EmployeesList({
    Key? key,
    required this.employees,
    required this.isCurrentEmployees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeBloc = BlocProvider.of<EmployeeBLoC>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: employees.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCurrentEmployees &&
                  employees.isNotEmpty &&
                  employees.where((element) => element.toDate == null).isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Current Employees',
                    style: TextStyle(fontSize: 18, color: primaryColor),
                  ),
                ),
              if (!isCurrentEmployees &&
                  employees.isNotEmpty &&
                  employees.where((element) => element.toDate != null).isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Previous Employees',
                    style: TextStyle(fontSize: 18, color: primaryColor),
                  ),
                ),

              BlocConsumer<EmployeeBLoC, EmployeeState>(
                listener: (context, state) {
                  if (state is EmployeeErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is EmployeeLoadedState) {
                    final filteredEmployees = state.employees.where((employee) {
                      if (isCurrentEmployees) {
                        return employee.toDate == null;
                      } else {
                        return employee.toDate != null;
                      }
                    }).toList();

                    return Container(
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredEmployees.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final employee = filteredEmployees[index];
                          return Slidable(
                            key: Key(employee.id),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    employeeBloc.add(DeleteEmployeeEvent(employee.id));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Employee data has been deleted'),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            employeeBloc.add(AddEmployeeEvent(employee));
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddUpdateEmployeeData(
                                      isUpdate: true,
                                      index: index,
                                      employeeModel: employee,
                                    ),
                                  ),
                                );
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: Text(
                                employee.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employee.role,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  if (isCurrentEmployees)
                                    Text(
                                      employee.toDate == null
                                          ? 'from ${DateFormat('dd-MMMM-yyyy').format(employee.fromDate)}'
                                          : 'No Date',
                                      style: const TextStyle(color: Colors.grey),
                                    )
                                  else
                                    Text(
                                      '${DateFormat('dd-MMMM-yyyy').format(employee.fromDate)}'
                                      ' -  ${employee.toDate != null ? DateFormat('dd-MMMM-yyyy').format(employee.toDate!) : 'No Date'}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
