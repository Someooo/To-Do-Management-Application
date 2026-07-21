import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/config/app_routes.dart';
import 'package:my_template/config/app_theme.dart';
import 'package:my_template/core/utils/toast_utils.dart';
import 'package:my_template/core/widgets/connectivity_banner_widget.dart';
import 'package:my_template/core/bloc/theme_bloc.dart';
import 'package:my_template/core/bloc/theme_event.dart';
import 'package:my_template/core/bloc/theme_state.dart';
import 'package:my_template/di.dart';

class AppEntrypoint extends StatelessWidget {
  const AppEntrypoint({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocProvider<ThemeBloc>(
          create: (context) =>
              getIt<ThemeBloc>()..add(const ThemeLoadStarted()),
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'My Template App',
                debugShowCheckedModeBanner: false,
                scaffoldMessengerKey: ToastUtils.messengerKey,
                initialRoute: AppRoutes.initial,
                routes: AppRoutes.routes,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: state.themeMode,
                builder: (context, child) {
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Column(
                      children: [
                        const ConnectivityBannerWidget(),
                        Expanded(child: child ?? const SizedBox()),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
