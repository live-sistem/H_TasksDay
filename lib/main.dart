import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/notes_page.dart';
import 'package:h_tasksday/models/note_database.dart';
import 'package:h_tasksday/theme/theme_provider.dart';

//Главная функция приложения "точка запуска"
void main() async {
  //инициализация виджетов
  WidgetsFlutterBinding.ensureInitialized();
  //инициализация базы данных
  await NoteDatabase.initialize();
  //подгрузка данных из предпочней
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //создание переменной и присвоение =логического значения
  final isDark = sharedPreferences.getBool('darkMode') ?? false;
  final isPageNotes = sharedPreferences.getBool('ListGrid') ?? false;
  //запуск главной функции runApp
  runApp(
    //передаем значения для отслеживания состояния виджетов
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDark)),
        ChangeNotifierProvider(
            create: (context) => toggleViewAVDVVD(isPageNotes)),
      ],
      //запуск главного класса
      child: MyApp(
        isDark: isDark,
        isPageNotes: isPageNotes,
      ),
    ),
  );
}

//Главный класса MyApp наследуется от StatelessWidget
class MyApp extends StatelessWidget {
  //объявление передаваемой переменной
  final bool isDark;
  final bool isPageNotes;
  //инициализацией формальных параметров для применения их в коде
  const MyApp({
    super.key,
    required this.isDark,
    required this.isPageNotes,
  });
  //ключевого слова @override указывает на то,
  //что функция также определена в классе-предке
  //(не обязательна но желательна)
  @override
  //Widget строительный блок
  //build абстрактный метод
  Widget build(BuildContext context) {
    //контейнер MaterialApp основной MaterialApp
    return MaterialApp(
      debugShowCheckedModeBanner: false, //скрывает Banner дебаг
      home: const NotesPage(), //домашняя страница
      theme: Provider.of<ThemeProvider>(context)
          .themeData, //передаем параметры темы приложения через Provider
    );
  }
}
