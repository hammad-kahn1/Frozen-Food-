import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/config/flavor_config.dart';
import 'app/di/injection_container.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlavorConfig.initialize(
    const FlavorConfig(
      environment: Environment.development,
      firebaseProjectId: 'frozen-food-dev',
      algoliaAppId: 'dev_app_id',
      algoliaSearchKey: 'dev_search_key',
      stripePublishableKey: 'pk_test_123',
      enableCrashlytics: false,
      enableAnalytics: false,
      showDebugBanner: true,
    ),
  );

  await configureDependencies();

  runApp(const FrozenFoodApp());
}

class FrozenFoodApp extends StatelessWidget {
  const FrozenFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate router (normally injected via DI)
    final appRouter = AppRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Frozen Food Delivery',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: FlavorConfig.instance.showDebugBanner,
        routerConfig: appRouter.router,
      ),
    );
  }
}
