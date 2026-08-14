import 'package:bloc/bloc.dart';

/// Dashboard state is now derived from the shared TasksCubit in MainShell.
/// This cubit is kept as a minimal stub for potential future use.
class DashboardState {
  const DashboardState();
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());
}
