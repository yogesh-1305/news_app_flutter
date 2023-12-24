import 'package:flutter_bloc/flutter_bloc.dart';

/// Dashboard cubit
/// purpose -> to handle dashboard's tabs switching
class DashboardCubit extends Cubit<int> {
  DashboardCubit() : super(0);

  void changeTab(int index) {
    emit(index);
  }
}
