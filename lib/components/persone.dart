import 'package:flutter/material.dart';
import 'package:h_tasksday/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonePage extends StatelessWidget {
  const PersonePage({super.key});

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
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () async {
                      const url = 'https://github.com/himanshusharma89';
                      // ignore: deprecated_member_use
                      if (await canLaunch(url)) {
                        // ignore: deprecated_member_use
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        _launchURL();
                      },
                      child: Image(
                        // ignore: dead_code
                        image:
                            Provider.of<ThemeProvider>(context, listen: false)
                                    .isDarkMode
                                ? AssetImage('assets/images/github.png')
                                : AssetImage('assets/images/github_black.png'),
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 200,
                    height: 400,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Данная программа была разработана, для дипломного проекта Носовым Павлом Дмитриевичем. Искодный код программы выложин на github для всех желающих, чтобы перейти на него нажмите на иконку с верху",
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL() async {
    var httpsUri = Uri(
      scheme: 'https',
      host: 'google.com',
    );

    // Uri url = https://github.com/;
    if (await canLaunchUrl(httpsUri)) {
      await launchUrl(httpsUri);
    }
  }
}
