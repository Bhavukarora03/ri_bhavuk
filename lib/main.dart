import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ri_bhavuk/bloc/employee_bloc.dart';
import 'package:ri_bhavuk/pages/home_screen.dart';
import 'package:ri_bhavuk/repositery/employee_repositery.dart';
import 'package:ri_bhavuk/theme/theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final employeeRepository = EmployeeRepository();
  runApp(MyApp(employeeRepository: employeeRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.employeeRepository}) : super(key: key);

  final EmployeeRepository employeeRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeBLoC>(
      create: (context) => EmployeeBLoC(employeeRepository: employeeRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
