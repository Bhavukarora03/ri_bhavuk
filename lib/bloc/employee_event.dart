part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployeeEvent extends EmployeeEvent {
  const LoadEmployeeEvent(this.employees);

  final List<EmployeeModel> employees;

  @override
  List<Object> get props => [];
}

class AddEmployeeEvent extends EmployeeEvent {
  final EmployeeModel employeeModel;

  const AddEmployeeEvent(this.employeeModel);

  @override
  List<Object> get props => [employeeModel];

  @override
  bool? get stringify => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddEmployeeEvent && runtimeType == other.runtimeType && employeeModel == other.employeeModel;

  @override
  int get hashCode => employeeModel.hashCode;
}

class EditEmployeeEvent extends EmployeeEvent {
  final EmployeeModel employeeModel;

  const EditEmployeeEvent(
    this.employeeModel,
  );

  @override
  List<Object> get props => [
        employeeModel,
      ];

  @override
  bool? get stringify => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditEmployeeEvent && runtimeType == other.runtimeType && employeeModel == other.employeeModel;

  @override
  int get hashCode => employeeModel.hashCode;
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final String employeeId;

  const DeleteEmployeeEvent(this.employeeId);

  @override
  List<Object> get props => [employeeId];
}

class NoEmployeeEvent extends EmployeeEvent {
  @override
  List<Object> get props => [];
}
