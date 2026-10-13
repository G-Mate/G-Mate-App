import 'package:flutter/widgets.dart';
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
import '../features/place/domain/place.dart';
import '../features/place/domain/place_repository.dart';
import '../features/place/presentation/bloc/place_detail_cubit.dart';
import '../features/place/presentation/bloc/place_select_cubit.dart';
import '../features/place/presentation/place_confirm_page.dart';
import '../features/place/presentation/place_select_page.dart';
import '../features/speech/domain/speech_settings_repository.dart';
import 'di.dart';
import 'routes.dart';

export 'routes.dart';

/// 장소 확인 → 이동 중 전환 시간 (평면도 Hero가 지도로 커지는 시간).
const guideTransition = Duration(milliseconds: 700);

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
      // 장소 확인의 평면도가 이 화면의 지도로 날아가도록(Hero) 전환 시간을 둔다.
      // 다른 화면은 기본처럼 바로 바뀐다.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: guideTransition,
        reverseTransitionDuration: guideTransition,
        // 평면도가 먼저 날아가고, 새 화면은 그 뒤에 서서히 나타난다.
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0.35, 1, curve: Curves.easeOut),
          ),
          child: child,
        ),
        child: BlocProvider(
          create: (_) => GuideBloc(
            robot: getIt<RobotController>(),
            places: getIt<PlaceRepository>(),
            placeKey: state.pathParameters['key']!,
            initialPlace: state.extra is Place ? state.extra! as Place : null,
          )..add(const GuideStarted()),
          child: const GuidingPage(),
        ),
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
