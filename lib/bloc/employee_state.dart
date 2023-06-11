part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoadingState extends EmployeeState {}

class EmployeeLoadedState extends EmployeeState {
  final List<EmployeeModel> employees;

  const EmployeeLoadedState(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeeAddingState extends EmployeeState {}

class EmployeeAddedState extends EmployeeState {
  final EmployeeModel employeeModel;

  const EmployeeAddedState(this.employeeModel);

  @override
  List<Object> get props => [employeeModel];
}

class EmployeeEditedState extends EmployeeState {
  final EmployeeModel employeeModel;

  const EmployeeEditedState(this.employeeModel);

  @override
  List<Object> get props => [employeeModel];
}

class EmployeeEditingState extends EmployeeState {}

class EmployeeDeletingState extends EmployeeState {}

class EmployeeDeletedState extends EmployeeState {
  final String employeeId;

  const EmployeeDeletedState(this.employeeId);

  @override
  List<Object> get props => [employeeId];
}

class EmployeeErrorState extends EmployeeState {
  final String message;

  const EmployeeErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class EmployeeNoDataState extends EmployeeState {}
