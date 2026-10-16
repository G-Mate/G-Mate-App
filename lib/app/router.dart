import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/robot/robot_controller.dart';
import '../features/admin/domain/admin_pin_repository.dart';
import '../features/admin/domain/place_image_picker.dart';
import '../features/admin/presentation/admin_home_page.dart';
import '../features/admin/presentation/admin_pin_change_page.dart';
import '../features/admin/presentation/admin_pin_page.dart';
import '../features/admin/presentation/admin_place_edit_page.dart';
import '../features/admin/presentation/admin_places_page.dart';
import '../features/admin/presentation/admin_tour_edit_page.dart';
import '../features/admin/presentation/admin_tours_page.dart';
import '../features/admin/presentation/admin_tts_page.dart';
import '../features/admin/presentation/bloc/admin_pin_change_cubit.dart';
import '../features/admin/presentation/bloc/admin_pin_cubit.dart';
import '../features/admin/presentation/bloc/admin_place_edit_cubit.dart';
import '../features/admin/presentation/bloc/admin_places_cubit.dart';
import '../features/admin/presentation/bloc/admin_tour_edit_cubit.dart';
import '../features/admin/presentation/bloc/admin_tours_cubit.dart';
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
import '../features/school/presentation/school_overview_page.dart';
import '../features/school/presentation/school_web_page.dart';
import '../features/speech/domain/speech_settings_repository.dart';
import '../features/speech/presentation/bloc/voice_guide_cubit.dart';
import '../features/speech/presentation/voice_scripts.dart';
import '../features/tour/domain/get_tour_visits.dart';
import '../features/tour/domain/tour_repository.dart';
import '../features/tour/presentation/bloc/tour_bloc.dart';
import '../features/tour/presentation/bloc/tour_detail_cubit.dart';
import '../features/tour/presentation/bloc/tour_select_cubit.dart';
import '../features/tour/presentation/tour_confirm_page.dart';
import '../features/tour/presentation/tour_done_page.dart';
import '../features/tour/presentation/tour_run_page.dart';
import '../features/tour/presentation/tour_select_page.dart';
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
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => RobotStatusCubit(getIt<RobotController>())..start(),
          ),
          BlocProvider(
            create: (_) =>
                _voice()..start(VoiceScripts.home(HomePage.firstCardSpeech)),
          ),
        ],
        child: const HomePage(),
      ),
    ),

    // 길 찾기
    GoRoute(
      path: AppRoutes.placeSelect,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => PlaceSelectCubit(getIt<PlaceRepository>())..load(),
          ),
          BlocProvider(create: (_) => _voice()),
        ],
        child: const PlaceSelectPage(),
      ),
      routes: [
        GoRoute(
          path: ':key',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => PlaceDetailCubit(
                  getIt<PlaceRepository>(),
                  state.pathParameters['key']!,
                )..load(),
              ),
              BlocProvider(create: (_) => _voice()),
            ],
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
        // 화면은 먼저 빠르게 바뀌고, 그 위로 지도 카드가 커지며 자리 잡는다.
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0, 0.3, curve: Curves.easeOut),
          ),
          child: child,
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => GuideBloc(
                robot: getIt<RobotController>(),
                places: getIt<PlaceRepository>(),
                placeKey: state.pathParameters['key']!,
                initialPlace: state.extra is Place
                    ? state.extra! as Place
                    : null,
              )..add(const GuideStarted()),
            ),
            BlocProvider(create: (_) => _voice()),
          ],
          child: const GuidingPage(),
        ),
      ),
    ),
    GoRoute(
      path: '/arrival/:key',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ArrivalCubit(
              robot: getIt<RobotController>(),
              places: getIt<PlaceRepository>(),
              placeKey: state.pathParameters['key']!,
            )..start(),
          ),
          BlocProvider(create: (_) => _voice()),
        ],
        child: const ArrivalPage(),
      ),
    ),

    // 학교 투어
    GoRoute(
      path: AppRoutes.tourSelect,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => TourSelectCubit(getIt<TourRepository>())..load(),
          ),
          BlocProvider(create: (_) => _voice()),
        ],
        child: const TourSelectPage(),
      ),
      routes: [
        GoRoute(
          path: ':key',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => _tourDetail(state.pathParameters['key']!),
              ),
              BlocProvider(create: (_) => _voice()),
            ],
            child: const TourConfirmPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/tour-run/:key',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => TourBloc(
              robot: getIt<RobotController>(),
              tours: getIt<TourRepository>(),
              getVisits: GetTourVisits(getIt<PlaceRepository>()),
              tourKey: state.pathParameters['key']!,
            )..add(const TourStarted()),
          ),
          BlocProvider(create: (_) => _voice()),
        ],
        child: const TourRunPage(),
      ),
    ),
    GoRoute(
      path: '/tour-done/:key',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _tourDetail(state.pathParameters['key']!),
          ),
          BlocProvider(create: (_) => _voice()),
        ],
        child: const TourDonePage(),
      ),
    ),

    // 학교 개요
    GoRoute(
      path: AppRoutes.schoolOverview,
      builder: (context, state) => const SchoolOverviewPage(),
      routes: [
        GoRoute(
          path: 'web',
          builder: (context, state) => SchoolWebPage(
            url: state.uri.queryParameters['url'] ?? '',
            title: state.uri.queryParameters['title'] ?? '',
          ),
        ),
      ],
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
      path: AppRoutes.adminHome,
      builder: (context, state) => const AdminHomePage(),
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
              imagePicker: getIt<PlaceImagePicker>(),
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
      path: AppRoutes.adminPinChange,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminPinChangeCubit(getIt<AdminPinRepository>()),
        child: const AdminPinChangePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.adminTours,
      builder: (context, state) => BlocProvider(
        create: (_) => AdminToursCubit(
          tours: getIt<TourRepository>(),
          places: getIt<PlaceRepository>(),
        )..load(),
        child: const AdminToursPage(),
      ),
      routes: [
        GoRoute(
          path: ':key',
          builder: (context, state) {
            final key = state.pathParameters['key']!;
            return BlocProvider(
              create: (_) => AdminTourEditCubit(
                tours: getIt<TourRepository>(),
                places: getIt<PlaceRepository>(),
                tourKey: key == AppRoutes.newTourKey ? null : key,
                imagePicker: getIt<PlaceImagePicker>(),
              )..load(),
              child: const AdminTourEditPage(),
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.designGallery,
      builder: (context, state) => const DesignGalleryPage(),
    ),
  ],
);

/// 화면마다 새로 만드는 음성 안내. 대본은 화면이 데이터를 불러온 뒤 넘긴다.
VoiceGuideCubit _voice() => VoiceGuideCubit(
  robot: getIt<RobotController>(),
  settings: getIt<SpeechSettingsRepository>(),
);

TourDetailCubit _tourDetail(String key) => TourDetailCubit(
  tours: getIt<TourRepository>(),
  getVisits: GetTourVisits(getIt<PlaceRepository>()),
  tourKey: key,
)..load();

final appRouter = createRouter();
