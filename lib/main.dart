import 'package:flutter/material.dart';
import 'package:personal_task_manager/model/notification_service.dart';
import 'package:personal_task_manager/screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().init();
  runApp(MaterialApp(home: const Home()));
}

