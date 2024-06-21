import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:h_tasksday/components/drawor.dart';
import 'package:h_tasksday/models/note.dart';
import 'package:h_tasksday/models/note_database.dart';
import 'package:h_tasksday/pages/page_grid_popover.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //создание текс контроллера  (поле ввода)
  final textController = TextEditingController();

  @override
  void initState() {
    //запуск инициализации
    super.initState();
    //запуск функции базы данных readNotes() - чтение
    readNotes();
  }

  //функция создание заметки
  void createNote() {
    //предварительная очистка контроллера ввода
    textController.clear();

    //виджет диалогового окна
    showDialog(
      //передаём context
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9))),
        //присвоение textController в TextField
        content: TextField(
          maxLines: 10,
          minLines: 2,
          controller: textController,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 59, 59, 59),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 59, 59, 59),
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          //позиционирование кнопки
          MaterialButton(
            //действие если кнопку нажать
            onPressed: () {
              //добавление в базу данных значение textController.text то что ввел пользователь

              context.read<NoteDatabase>().addNote(textController.text);
              //повторная очистка контроллера
              textController.clear();
              //событие Navigator передаём context вернёмся на главную страницу
              Navigator.pop(context);
            },
            //текст кнопки
            child: const Text(
              'Создать',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //функция чтения заметки
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //функция обновление заметки
  void updateNote(Note note) {
    //аргументы функции: note
    //замена с текста в контроллере на прошедший в аргументах
    textController.text = note.text.toString();

    //виджет диалогового окна
    showDialog(
      context: context,
      //передаём context
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9))),
        //имя окна диалога
        title: const Text("Update Note"),
        //присвоение textController в TextField
        content: TextField(
          controller: textController,
          maxLines: 12,
          minLines: 1,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 59, 59, 59),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 59, 59, 59),
                width: 2,
              ),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,

        actions: [
          //позиционирование кнопки
          MaterialButton(
            //действие если кнопку нажать
            onPressed: () {
              //перезаписывание в базу данных значение textController.text то что изменил пользователь
              context
                  .read<NoteDatabase>()
                  .updateNote(note.id, textController.text);
              //отчистить ввод от старой заметки в контролере
              textController.clear();
              //клик по context возврат на главную
              Navigator.pop(
                context,
                true,
              );
            },
            //текст кнопки
            child: const Text("Обновить",
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
        ],
      ),
    );
  }

  //функция удаления заметки
  void daleteNote(int id) {
    //функция с аргументами : id
    //удаление заметки из базы данных по id
    context.read<NoteDatabase>().deleteNote(id);
  }

  void test(Note note) {
    context.read<NoteDatabase>().completed(note.id, textController.text);
  }

  @override
  Widget build(BuildContext context) {
    //получение доступа к базе данных
    final noteDatabase = context.watch<NoteDatabase>();
    //получение списка заметок
    List<Note> currentNotes = noteDatabase.currentNotes;

    //возврощяем виджет Scaffold
    return Scaffold(
      //верхняя часть экрана приложения
      appBar: AppBar(
        //нулевая позиция
        elevation: 0,
        //определение цвета фона AppBar
        backgroundColor: Colors.transparent,
        //определение темы виджета
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      //определение цвета фона Scaffold
      backgroundColor: Theme.of(context).colorScheme.background,
      //добавление кнопки "добавить заметку"
      floatingActionButton: FloatingActionButton(
        //вызов функции при нажатии
        onPressed: createNote,
        //иконка кнопки
        child: Icon(
          Icons.add,
          //определение темы виджета
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      //добавление Side nav (боковая панель) MyDrawer
      drawer: const MyDrawer(),

      body: Column(
        //позиционирование относительно context
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //внутренние отступы
          // ignore: avoid_unnecessary_containers
          Container(
            child: Padding(
              //отступы по левому краю дочернего виджета
              padding: const EdgeInsets.only(left: 10.0),
              //текст виджета, стилизация, тема
              child: ListTile(
                title: Text(
                  "Заметки",
                  style: TextStyle(
                    fontSize: (35),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                trailing: Builder(builder: (context) {
                  return IconButton(
                      icon: Icon(
                        Provider.of<toggleViewAVDVVD>(context)._isGrid
                            ? Icons.view_list
                            : Icons.view_module,
                        size: 34,
                      ),
                      onPressed: () =>
                          Provider.of<toggleViewAVDVVD>(context, listen: false)
                              ._toggleView());
                }),
              ),
            ),
          ),
          //отрисовка заметок Expanded - задаёт все доступное пространство со скроллом
          Expanded(
            child: Provider.of<toggleViewAVDVVD>(context)._isGrid
                ? ListView.builder(
                    itemCount: currentNotes.length,
                    itemBuilder: (context, index) {
                      final note = currentNotes[index];
                      return Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Slidable(
                          endActionPane: ActionPane(
                            dragDismissible: true,
                            extentRatio: 0.2,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                flex: 1,
                                onPressed: (context) {
                                  daleteNote(note.id);
                                },
                                // backgroundColor:
                                //     Theme.of(context).colorScheme.background,
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 17, 0),
                                borderRadius: BorderRadius.circular(10),
                                icon: Icons.delete,
                              )
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8)),
                            margin: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Center(
                              child: GestureDetector(
                                  onLongPress: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Текст скопирован'),
                                      ),
                                    );
                                    Clipboard.setData(ClipboardData(
                                        text: note.text.toString()));
                                  },
                                  child: ListTile(
                                    leading: Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: note.completed,
                                        activeColor: Colors.green,
                                        side: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        onChanged: (bool? value) {
                                          test(note);
                                        },
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${note.createdTime!.hour}:${note.createdTime!.minute}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    onTap: () {},
                                    //текст заметки
                                    title: Text(
                                      note.text.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () => updateNote(note),
                                        icon: const Icon(Icons.edit)),
                                  )),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                    ),
                    itemCount: currentNotes.length,
                    itemBuilder: (context, index) {
                      final note = currentNotes[index];
                      return Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onLongPress: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Текст скопирован'),
                                    ),
                                  );
                                  Clipboard.setData(ClipboardData(
                                      text: note.text.toString()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 45, left: 20, right: 25, bottom: 21),
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    //текст заметки
                                    note.text.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              //нужен, если хочешь чтоб у showPopover был свой контекст
                              //чтоб можно было передать showPopover в конкертный Widget
                              child: Builder(
                                builder: (context) => IconButton(
                                  icon: const Icon(Icons.more_horiz, size: 28),
                                  onPressed: () => showPopover(
                                    width: 180,
                                    height: 100,
                                    //Если будет ошибка type 'RenderS1iverGFid' is not а subtype of type • RenderBox?' in type cast
                                    //то передай в context условный this.context ошибка исчезнет (фича)
                                    //но ты не сможешь передать showPopover Builder context который создал выше
                                    //как правило ошибка исчезнет если создать showPopover свой собственный context
                                    //если это не сделать то родителем будет Container и ему он должен присваивается автоматически
                                    context: context,
                                    bodyBuilder: (context) =>
                                        BetaPageGridPopover(
                                      onEditTap: () => updateNote(note),
                                      onDeleteTap: () => daleteNote(note.id),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  //дата заметки
                                  "${note.createdTime!.hour}:${note.createdTime!.minute}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: note.completed,
                                  activeColor: Colors.green,
                                  side: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  onChanged: (bool? value) {
                                    test(note);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class toggleViewAVDVVD extends ChangeNotifier {
  bool _isGrid = false;
  //отслеживание вид отображения заметки
  toggleViewAVDVVD(bool isPageNotes) {
    if (isPageNotes) {
      _isGrid = true;
    } else {
      _isGrid = false;
    }
    notifyListeners();
  }
  //функция для изменения вид отображения заметки
  void _toggleView() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_isGrid == false) {
      _isGrid = true;
      sharedPreferences.setBool("ListGrid", true);
    } else {
      _isGrid = false;
      sharedPreferences.setBool("ListGrid", false);
    }
    notifyListeners();
  }
}
