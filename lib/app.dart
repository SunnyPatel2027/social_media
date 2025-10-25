import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/route_names.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/signup_screen.dart';
import 'features/post/presentation/post_screen.dart';
import 'features/post/data/post_repository.dart';
import 'features/post/cubit/post_cubit.dart';
import 'core/widgets/loading_widget.dart';
import 'features/splash/presentation/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthCubit(context.read<AuthRepository>()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;
  StreamSubscription? _authSub;

  @override
  void initState() {
    super.initState();
    final authRepo = context.read<AuthRepository>();
    final authCubit = context.read<AuthCubit>();

    _router = GoRouter(
      initialLocation: RouteNames.login,
      refreshListenable: GoRouterRefreshStream(authRepo.authStateChanges()),
      routes: [
        GoRoute(
          path: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RouteNames.signup,
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: RouteNames.post,
          builder: (context, state) {
            final user = authCubit.state.user;
            return BlocProvider(
              create: (_) => PostCubit(PostRepository(), user),
              child: const PostScreen(),
            );
          },
        ),
      ],
      redirect: (context, state) {
        final loggedIn = authCubit.state.user != null;
        final loggingIn =
            state.uri.path == RouteNames.login ||
            state.uri.path == RouteNames.signup;

        if (!loggedIn && !loggingIn) return RouteNames.login;
        if (loggedIn && loggingIn) return RouteNames.post;
        return null;
      },
    );

    _authSub = authRepo.authStateChanges().listen((user) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final router = _router; // router ready here
        final currentPath = router.routeInformationProvider.value.uri.path;

        if (user == null) {
          if (currentPath != RouteNames.login) {
            router.go(RouteNames.login);
          }
        } else {
          if (currentPath != RouteNames.post) {
            router.go(RouteNames.post);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;

    return MaterialApp.router(
      title: 'Social Media',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: AppColors.primary),
      routerConfig: _router,
      builder: (context, child) {
        if (state.isLoading && state.user == null) {
          return const SplashScreen();
        }

        return Stack(
          children: [child!, if (state.isLoading) const LoadingWidget()],
        );
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
