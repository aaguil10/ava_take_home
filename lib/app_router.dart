import 'package:ava_take_home/features/employment/cubit/employment_cubit.dart';
import 'package:ava_take_home/features/employment/data/shared_prefs_employment_repository.dart';
import 'package:ava_take_home/features/employment/view/employment_info_page.dart';
import 'package:ava_take_home/features/home/cubit/home_cubit.dart';
import 'package:ava_take_home/features/home/data/mock_home_repository.dart';
import 'package:ava_take_home/features/home/view/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          return BlocProvider(
            create: (_) =>
                HomeCubit(repository: MockHomeRepository())..loadHomeData(),
            child: const HomeScreen(),
          );
        },
      ),
      GoRoute(
        path: '/employment',
        name: 'employment',
        builder: (context, state) => BlocProvider(
          create: (_) =>
              EmploymentCubit(repository: SharedPrefsEmploymentRepository())
                ..load(),
          child: const EmploymentInfoPage(),
        ),
      ),
    ],
  );
}
