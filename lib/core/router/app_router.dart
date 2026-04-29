import 'package:go_router/go_router.dart';
import 'package:booklook/core/router/router_notifier.dart';
import 'package:booklook/presentation/screens/auth/login_screen.dart';
import 'package:booklook/presentation/screens/auth/register_screen.dart';
import 'package:booklook/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:booklook/presentation/screens/exercises/exercises_screen.dart';
import 'package:booklook/presentation/screens/exercises/add_exercise_screen.dart';
import 'package:booklook/presentation/screens/history/history_screen.dart';
import 'package:booklook/presentation/screens/main_shell.dart';
import 'package:booklook/presentation/screens/stats/stats_screen.dart';
import 'package:booklook/presentation/screens/workout/create_workout_screen.dart';
import 'package:booklook/presentation/screens/workout/workout_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: routerNotifier,
  redirect: (context, state) {
    final isLoggedIn = routerNotifier.isLoggedIn;
    final isOnAuthPage = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isLoggedIn && !isOnAuthPage) return '/login';
    if (isLoggedIn && isOnAuthPage) return '/dashboard';
    return null;
  },
  routes: [
    // ── Auth routes ────────────────────────────────────────────────────────
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),

    // ── App shell (requires auth) ──────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/exercises',
            builder: (_, __) => const ExercisesScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, __) => const AddExerciseScreen(),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/workout/create',
            builder: (_, __) => const CreateWorkoutScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/history',
            builder: (_, __) => const HistoryScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/stats',
            builder: (_, __) => const StatsScreen(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/workout/:id',
      builder: (_, state) =>
          WorkoutDetailScreen(workoutId: state.pathParameters['id']!),
    ),
  ],
);
