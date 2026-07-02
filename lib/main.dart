import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wedding_invitation/firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'presentation/pages/wedding_home_page.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  
  );

  runApp(const WeddingInvitationApp());
}

class WeddingInvitationApp extends StatelessWidget {
  const WeddingInvitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medhat & Nesma — Wedding Invitation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const WeddingHomePage(),
    );
  }
}
