import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:ri_bhavuk/bloc_classes/employee_bloc.dart';
import 'package:ri_bhavuk/components/button.dart';
import 'package:ri_bhavuk/components/date_picker.dart';
import 'package:ri_bhavuk/data/employee_repositery.dart';
import 'package:ri_bhavuk/models/employee_model.dart';
import 'package:ri_bhavuk/theme/theme.dart';

class AddUpdateEmployeeData extends StatefulWidget {
  const AddUpdateEmployeeData({Key? key, required this.isUpdate, this.index, this.employeeModel}) : super(key: key);

  final bool isUpdate;
  final int? index;
  final EmployeeModel? employeeModel;

  @override
  State<AddUpdateEmployeeData> createState() => _AddUpdateEmployeeDataState();
}

class _AddUpdateEmployeeDataState extends State<AddUpdateEmployeeData> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<String> roles = ['Product Designer', 'Flutter Developer', 'QA Tester', 'Product Owner'];
  late int selectedRoleIndex;
  DateTime fromDate = DateTime.now();
  DateTime? toDate = DateTime.now();
  final employeeRepository = EmployeeRepository();

  void _showRolesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: roles.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(roles[index]),
              onTap: () {
                setState(() {
                  selectedRoleIndex = index;
                });
                _formKey.currentState?.fields['role']?.didChange(roles[selectedRoleIndex]);
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          },
        );
      },
    );
  }

  void _fromDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePicker(
          isToDate: false,
          selectedDate: fromDate,
          onDateSelected: (date) {
            final formattedDate = DateFormat('dd-MMMM-yyyy').format(date!);
            setState(() {
              fromDate = date;
              _formKey.currentState?.fields['from_date']?.didChange(formattedDate);
            });
          },
        );
      },
    );
  }

  void _toDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePicker(
          isToDate: true,
          selectedDate: toDate!,
          onDateSelected: (date) {
            setState(() {
              toDate = date;
              _formKey.currentState?.fields['to_date']
                  ?.didChange(date != null ? DateFormat('dd-MMMM-yyyy').format(date) : 'No Date');
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeBloc = BlocProvider.of<EmployeeBLoC>(context);
    return BlocBuilder<EmployeeBLoC, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: Text(widget.isUpdate ? 'Edit Employee Details' : 'Add Employee Details'),
              automaticallyImplyLeading: false,
              actions: widget.isUpdate
                  ? [
                      IconButton(
                          onPressed: () {
                            employeeBloc.add(DeleteEmployeeEvent(widget.employeeModel!.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Employee Deleted Successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete))
                    ]
                  : []),
          body: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        initialValue: widget.isUpdate ? widget.employeeModel!.name : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'employee_name',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(20),
                          FormBuilderValidators.minLength(4)
                        ]),
                        decoration: const InputDecoration(hintText: 'Employee name', prefixIcon: Icon(Icons.person)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                        name: 'role',
                        validator: FormBuilderValidators.required(),
                        onTap: () {
                          _showRolesModal(context);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Select Role',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          prefixIcon: Icon(Icons.work_outline),
                        ),
                        initialValue: widget.isUpdate ? widget.employeeModel!.role : null,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              initialValue: widget.isUpdate
                                  ? DateFormat('dd-MMMM-yyyy').format(widget.employeeModel!.fromDate)
                                  : null,
                              name: 'from_date',
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              readOnly: true,
                              validator: FormBuilderValidators.required(),
                              onTap: () {
                                _fromDate(context);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Joining Date',
                                prefixIcon: Icon(Icons.date_range),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 100,
                            child: Icon(
                              Icons.arrow_forward,
                              color: primaryColor,
                            ),
                          ),
                          Expanded(
                            child: FormBuilderTextField(
                              initialValue: widget.isUpdate && widget.employeeModel!.toDate != null
                                  ? DateFormat('dd-MMMM-yyyy').format(widget.employeeModel!.toDate!)
                                  : null,
                              readOnly: true,
                              name: 'to_date',
                              onTap: () {
                                _toDate(context);
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'No Date',
                                prefixIcon: Icon(Icons.date_range),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Divider(
                          color: Colors.grey.shade300,
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Button(
                                  color: 'secondary',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  label: 'Cancel'),
                              const SizedBox(
                                width: 10,
                              ),
                              Button(
                                onPressed: () {
                                  final formState = _formKey.currentState;
                                  if (formState != null && formState.saveAndValidate()) {
                                    final employee = EmployeeModel(
                                      id: widget.isUpdate ? widget.employeeModel!.id : UniqueKey().toString(),
                                      name: formState.value['employee_name'],
                                      role: formState.value['role'],
                                      fromDate: fromDate,
                                      toDate: formState.value['to_date'] != null ? toDate : null,
                                    );

                                    widget.isUpdate
                                        ? employeeBloc.add(EditEmployeeEvent(employee))
                                        : employeeBloc.add(AddEmployeeEvent(employee));
                                    Navigator.pop(context);
                                  }
                                },
                                label: 'Save',
                                color: 'primary',
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
