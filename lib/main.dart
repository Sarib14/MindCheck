import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
void main(){
  runApp(const MindCheckApp());
}
class MindCheckApp extends StatelessWidget{
  const MindCheckApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner:false,
    title: 'MindCheck',
    theme: AppTheme.lightTheme,
    home:const HomeScreen(),
    );
  }
}
    