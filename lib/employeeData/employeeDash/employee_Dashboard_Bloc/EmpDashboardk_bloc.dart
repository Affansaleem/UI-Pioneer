import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'EmpDashboardk_event.dart';
part 'EmpDashboardk_state.dart';

class EmpDashboardkBloc extends Bloc<EmpDashboardkEvent, EmpDashboardkState> {
  EmpDashboardkBloc() : super(DashboardkInitial()) {
    on<NavigateToProfileEvent>(navigateToProfileEvent);
    on<NavigateToReportsEvent>(navigateToReportsEvent);
    on<NavigateToLogoutEvent>(navigateToLogoutEvent);
    on<NavigateToHomeEvent>(navigateToHomeEvent);


  }

  FutureOr<void> navigateToProfileEvent(NavigateToProfileEvent event, Emitter<EmpDashboardkState> emit) {

    emit(NavigateToProfileState());

  }


  FutureOr<void> navigateToReportsEvent(NavigateToReportsEvent event, Emitter<EmpDashboardkState> emit) {
    emit(NavigateToReportsState());


  }

  FutureOr<void> navigateToLogoutEvent(NavigateToLogoutEvent event, Emitter<EmpDashboardkState> emit) {
    emit(NavigateToLogoutState());

  }

  FutureOr<void> navigateToHomeEvent(NavigateToHomeEvent event, Emitter<EmpDashboardkState> emit) {
    emit(NavigateToHomeState());
  }
}
