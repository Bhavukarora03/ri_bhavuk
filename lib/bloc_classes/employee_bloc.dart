import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ri_bhavuk/data/employee_repositery.dart';
import 'package:ri_bhavuk/models/employee_model.dart';

part 'employee_event.dart';

part 'employee_state.dart';

class EmployeeBLoC extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBLoC({required this.employeeRepository}) : super(EmployeeInitial()) {
    _loadEmployees();
  }

  final EmployeeRepository employeeRepository;

  Future<void> _loadEmployees() async {
    try {
      final employees = await employeeRepository.getEmployees();
      if (employees.isNotEmpty) {
        add(LoadEmployeeEvent(employees));
      } else {
        add(NoEmployeeEvent());
      }
    } catch (error) {
      //
    }
  }

  EmployeeState get initialState => EmployeeLoadingState();

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is LoadEmployeeEvent) {
      yield* _mapLoadEmployeeToState(event);
    } else if (event is AddEmployeeEvent) {
      yield* _mapAddEmployeeToState(event);
    } else if (event is EditEmployeeEvent) {
      yield* _mapEditEmployeeToState(event);
    } else if (event is DeleteEmployeeEvent) {
      yield* _mapDeleteEmployeeToState(event);
    } else if (event is NoEmployeeEvent) {
      yield EmployeeNoDataState();
    }
  }

  Stream<EmployeeState> _mapLoadEmployeeToState(LoadEmployeeEvent event) async* {
    yield EmployeeLoadedState(event.employees);
  }

  Stream<EmployeeState> _mapAddEmployeeToState(AddEmployeeEvent event) async* {
    yield EmployeeAddingState();
    try {
      final newEmployee = EmployeeModel(
        id: DateTime.now().toString(),
        name: event.employeeModel.name,
        role: event.employeeModel.role,
        fromDate: event.employeeModel.fromDate,
        toDate: event.employeeModel.toDate != null ? event.employeeModel.toDate! : null,
      );
      await employeeRepository.addEmployee(newEmployee);
      _loadEmployees();
    } catch (error) {
      yield EmployeeErrorState(error.toString());
    }
  }

  Stream<EmployeeState> _mapEditEmployeeToState(EditEmployeeEvent event) async* {
    yield EmployeeEditingState();
    try {
      final updatedEmployee = EmployeeModel(
        id: event.employeeModel.id,
        name: event.employeeModel.name,
        role: event.employeeModel.role,
        fromDate: event.employeeModel.fromDate,
        toDate: event.employeeModel.toDate != null ? event.employeeModel.toDate! : null,
      );
      await employeeRepository.updateEmployee(updatedEmployee);
      _loadEmployees();
      final currentState = state;
      if (currentState is EmployeeLoadedState) {
        final updatedEmployees = List<EmployeeModel>.from(currentState.employees);
        final index = updatedEmployees.indexWhere((employee) => employee.id == event.employeeModel.id);
        if (index != -1) {
          updatedEmployees[index] = updatedEmployee;
          yield EmployeeLoadedState(updatedEmployees);
        }
      }
    } catch (error) {
      //yield EmployeeNoDataState(error.toString());
    }
  }

  Stream<EmployeeState> _mapDeleteEmployeeToState(DeleteEmployeeEvent event) async* {
    yield EmployeeDeletingState();
    try {
      await employeeRepository.deleteEmployee(event.employeeId);
      _loadEmployees();
    } catch (error) {
      yield EmployeeErrorState(error.toString());
    }
  }
}
