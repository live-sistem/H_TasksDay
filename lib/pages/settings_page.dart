import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h_tasksday/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //возврощяем виджет Scaffold
    return Scaffold(
      //опредиоение цвета фона виджета
      backgroundColor: Theme.of(context).colorScheme.background,
      //вверхняя часть экрна приложения
      appBar: AppBar(
        // нулевая позиция
        elevation: 0,
        //опредиоение цвета фона AppBar
        backgroundColor: Colors.transparent,
        //определение темы виджета
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      //тело экрана (виджет Container)
      body: Column(
        children: [
          Container(
            //создание рамки вокруг виджета
            decoration: BoxDecoration(
                //цвет рамики
                color: Theme.of(context).colorScheme.primary,
                //скругление рамки
                borderRadius: BorderRadius.circular(10)),
            //внутренний отступ виджета
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            //внешний отступ виджета
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            //дочерний виджет Row - строка
            child: Row(
              //позиционирование spaceBetween по разным углам
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //дочерний элемент
              children: [
                //текст виджета, стилизация
                Text("Dark Mode",
                    style: TextStyle(
                      fontSize: (17),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )),

                //обработчик
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                )
              ],
            ),
          ),
          // Container(
          //   //создание рамки вокруг виджета
          //   decoration: BoxDecoration(
          //       //цвет рамики
          //       color: Theme.of(context).colorScheme.primary,
          //       //скругление рамки
          //       borderRadius: BorderRadius.circular(10)),
          //   //внутренний отступ виджета
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          //   //внешний отступ виджета
          //   margin: const EdgeInsets.only(
          //     left: 20,
          //     right: 20,
          //     top: 10,
          //     bottom: 10,
          //   ),
          //   //дочерний виджет Row - строка
          //   child: Row(
          //     //позиционирование spaceBetween по разным углам
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     //дочерний элемент
          //     children: [
          //       //текст виджета, стилизация
          //       Text("Grid Mode",
          //           style: TextStyle(
          //             fontSize: (17),
          //             fontWeight: FontWeight.bold,
          //             color: Theme.of(context).colorScheme.inversePrimary,
          //           )),
          //       IconButton(
          //         icon: const Icon(Icons.arrow_forward_ios),
          //         onPressed: () {},
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
