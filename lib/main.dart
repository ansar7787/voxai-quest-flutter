import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voxai_quest/core/presentation/widgets/connectivity_wrapper.dart';

import 'package:voxai_quest/core/theme/app_theme.dart';
import 'package:voxai_quest/core/theme/theme_cubit.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Explicitly enable offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await di.init();

  runApp(const MyApp());

  // Remove splash after app runs
  FlutterNativeSplash.remove();

  // Non-blocking initializations
  di.sl<AdService>().init().then((_) {
    di.sl<AdService>().loadInterstitialAd();
    di.sl<AdService>().loadRewardedAd();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final authBloc = di.sl<AuthBloc>();
      final isPremium = authBloc.state.user?.isPremium ?? false;
      di.sl<AdService>().showAppOpenAdIfAvailable(isPremium: isPremium);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (context) => di.sl<AuthBloc>()),
            BlocProvider<ThemeCubit>(create: (context) => di.sl<ThemeCubit>()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'VoxAI Quest',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: AppRouter.router,
                builder: (context, child) {
                  return ConnectivityWrapper(child: child!);
                },
              );
            },
          ),
        );
      },
    );
  }
}
