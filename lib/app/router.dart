import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/robot/robot_controller.dart';
import '../features/home/presentation/bloc/robot_status_cubit.dart';
import '../features/home/presentation/home_page.dart';
import 'di.dart';

abstract final class AppRoutes {
  static const home = '/';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => BlocProvider(
        create: (_) => RobotStatusCubit(getIt<RobotController>())..start(),
        child: const HomePage(),
      ),
    ),
  ],
);
