import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol_catalog/core/design_system/app_theme.dart';
import 'package:tech_gadol_catalog/core/design_system/theme_cubit.dart';
import 'package:tech_gadol_catalog/core/network/product_client.dart';
import 'package:tech_gadol_catalog/core/router/app_router.dart';
import 'package:tech_gadol_catalog/features/products/data/datasources/product_local_data_source.dart';
import 'package:tech_gadol_catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:tech_gadol_catalog/features/products/domain/repositories/product_repository.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('products_cache');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
    final productClient = ProductClient(dio);
    final localDataSource = ProductLocalDataSourceImpl(Hive.box('products_cache'));

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(productClient, localDataSource),
        ),
      ],
      child: BlocProvider(
        create: (context) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'Tech Gadol Catalog',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
