import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'app/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: FoodokoApp(),
    ),
  );
}

class FoodokoApp extends StatelessWidget {
  const FoodokoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_dc74e0fd57cb46cd93832aee0a507256",
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: ThemeData.dark(),
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
        );
      },
    );
  }
}
