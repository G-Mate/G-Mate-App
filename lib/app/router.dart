import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/robot/robot_controller.dart';
import '../features/admin/domain/admin_pin_repository.dart';
import '../features/admin/presentation/admin_pin_page.dart';
import '../features/admin/presentation/admin_place_edit_page.dart';
import '../features/admin/presentation/admin_places_page.dart';
import '../features/admin/presentation/admin_tts_page.dart';
import '../features/admin/presentation/bloc/admin_pin_cubit.dart';
import '../features/admin/presentation/bloc/admin_place_edit_cubit.dart';
import '../features/admin/presentation/bloc/admin_places_cubit.dart';
import '../features/admin/presentation/bloc/admin_tts_cubit.dart';
import '../features/design_gallery/presentation/design_gallery_page.dart';
import '../features/guide/presentation/arrival_page.dart';
import '../features/guide/presentation/bloc/arrival_cubit.dart';
import '../features/guide/presentation/bloc/guide_bloc.dart';
import '../features/guide/presentation/guiding_page.dart';
import '../features/home/presentation/bloc/robot_status_cubit.dart';
import '../features/home/presentation/home_page.dart';
import '../features/place/domain/place_repository.dart';
import '../features/place/presentation/bloc/place_detail_cubit.dart';
import '../features/place/presentation/bloc/place_select_cubit.dart';
import '../features/place/presentation/place_confirm_page.dart';
import '../features/place/presentation/place_select_page.dart';
import '../features/speech/domain/speech_settings_repository.dart';
import 'di.dart';
import 'routes.dart';

export 'routes.dart';

GoRouter createRouter({String initialLocation = AppRoutes.home}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => BlocProvider(
        create: (_) => RobotStatusCubit(getIt<RobotController>())..start(),
        child: const HomePage(),
      ),
    ),

    // 길 찾기
    GoRoute(
      path: AppRoutes.placeSelect,
      builder: (context, state) => BlocProvider(
        create: (_) => PlaceSelectCubit(getIt<PlaceRepository>())..load(),
        child: const PlaceSelectPage(),
      ),
      routes: [
        GoRoute(
          path: ':key',
          builder: (context, state) => BlocProvider(
            create: (_) => PlaceDetailCubit(
              getIt<PlaceRepository>(),
              state.pathParameters['key']!,
            )..load(),
            child: const PlaceConfirmPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/guide/:key',
      builder: (context, state) => BlocProvider(
        create: (_) => GuideBloc(
          robot: getIt<RobotController>(),
          places: getIt<PlaceRepository>(),
          placeKey: state.pathParameters['key']!,
        )..add(const GuideStarted()),
        child: const GuidingPage(),
      ),
    ),
    GoRoute(
      path: '/arrival/:key',
      builder: (context, state) => BlocProvider(
        create: (_) => ArrivalCubit(
          robot: getIt<RobotController>(),
          places: getIt<PlaceRepository>(),
          placeKey: state.pathParameters['key']!,
        )..start(),
        child: const ArrivalPage(),
      ),
    ),

    // 관리 모드. PIN을 지나면 PIN 화면은 쌓아 두지 않도록 형제 경로로 둔다.
    GoRoute(
      path: AppRoutes.adminPin,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminPinCubit(getIt<AdminPinRepository>()),
        child: const AdminPinPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.adminPlaces,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminPlacesCubit(
          robot: getIt<RobotController>(),
          places: getIt<PlaceRepository>(),
        )..start(),
        child: const AdminPlacesPage(),
      ),
      routes: [
        GoRoute(
          path: ':key',
          builder: (context, state) => BlocProvider(
            create: (_) => AdminPlaceEditCubit(
              robot: getIt<RobotController>(),
              places: getIt<PlaceRepository>(),
              placeKey: state.pathParameters['key']!,
            )..load(),
            child: const AdminPlaceEditPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.adminTts,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminTtsCubit(
          robot: getIt<RobotController>(),
          settings: getIt<SpeechSettingsRepository>(),
        )..load(),
        child: const AdminTtsPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.designGallery,
      builder: (context, state) => const DesignGalleryPage(),
    ),
  ],
);

final appRouter = createRouter();
