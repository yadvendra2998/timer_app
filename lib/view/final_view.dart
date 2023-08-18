import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_app/components/buttons.dart';
import 'package:timer_app/controller/theme_controller.dart';
import 'package:timer_app/controller/timer.dart';

class FinalView extends StatefulWidget {
  const FinalView({super.key});

  @override
  State<FinalView> createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  var themeController = Get.find<ThemeController>();
  late SharedPreferences sharedPreferences;
  List<NewTimer> list = <NewTimer>[];
  TextEditingController minuteController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  int minutes = 59;
  int seconds = 60;
  final maxSeconds = 60;
  final maxMinutes = 59;
  bool isRunning = false;
  Timer? timer;

  @override
  void dispose() {
    minuteController.dispose();
    secondController.dispose();
    super.dispose();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    
    sharedPreferences.setStringList('timer', stringList);
  }

  void loadData() {
    List<String>? listString = sharedPreferences.getStringList('timer');
    if (listString != null) {
      list = listString
          .map((item) => NewTimer.fromMap(json.decode(item)))
          .toList();
      setState(() {});
    }
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        setState(() {
          seconds = seconds;
        });
      } else {
        if (minutes > 0) {
          minutes--;
          seconds = 59;
          setState(() {
            minutes = minutes;
          });
        } else {
          isRunning = false;
          timer.cancel();
        }
      }
      setState(() {
        minutes = minutes;
        seconds = seconds;
      });
    });
  }

  void cancelTimer() {
    setState(() {
      minutes = 0;
      seconds = 0;
      isRunning = false;
    });
    timer?.cancel();
  }

  void pauseTimer() {
    setState(() {
      isRunning = false;
    });
    timer?.cancel();
  }

  /// is Timer Active?
  bool isTimerRuning() {
    return timer == null ? false : timer!.isActive;
  }

  /// is Timer Completed?
  bool isCompleted() {
    bool minute = minutes == maxMinutes || minutes == 0;
    bool second = seconds == maxSeconds || seconds == 0;

    return minute && second;
  }

  void addTimer(NewTimer item) {
    if (list.length >= 9) {
      list.removeLast();
      list.insert(0, item);
      // setState(() {
      //   minutes = minuteController.text as int;
      //   seconds = secondController.text as int;
      // });
      saveData();
      startTimer();
    } else {
      list.insert(0, item);
      saveData();
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetBuilder<ThemeController>(
                id: 1,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${minutes.toString()} : ${seconds.toString()}',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: isCompleted()
                                  ? const Color.fromARGB(255, 8, 123, 12)
                                  : !isRunning
                                      ? Colors.yellow
                                      : const Color.fromARGB(255, 178, 14, 2),
                            ),
                          ),
                          ButtonWidget(
                            text: "Add",
                            onTap: () {
                              addTimer(NewTimer(
                                  minutes: minutes.toString(),
                                  seconds: seconds.toString()));
                            },
                            color: themeController.isDarkMode
                                ? Colors.black
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 10),
            isTimerRuning() || !isCompleted()
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          text: isTimerRuning() ? "Pause" : "Resume",
                          onTap: () {
                            !isTimerRuning() ? pauseTimer() : startTimer();
                          },
                          color: isTimerRuning() ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                        ButtonWidget(
                          text: 'Cancel',
                          onTap: () {
                            cancelTimer();
                          },
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  )
                : GetBuilder<ThemeController>(
                    init: ThemeController(),
                    id: 1,
                    initState: (_) {},
                    builder: (_) {
                      return ButtonWidget(
                        text: 'Start',
                        onTap: () {
                          startTimer();
                        },
                        color: themeController.isDarkMode
                            ? Colors.black
                            : Colors.cyan,
                        fontWeight: FontWeight.w500,
                      );
                    },
                  ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 600,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.teal[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            list[0].minutes,
                            style: TextStyle(
                              fontSize: 25,
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                              fontSize: 25,
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            list[0].seconds,
                            style: TextStyle(
                              fontSize: 25,
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();
    var textTheme = Theme.of(context).textTheme;
    var iconTheme = Theme.of(context).iconTheme;
    return AppBar(
      title: Text(
        'Timer',
        style: textTheme.displayLarge,
      ),
      backgroundColor: Colors.tealAccent,
      elevation: 0,
      actions: [
        GetBuilder<ThemeController>(
          init: ThemeController(),
          id: 1,
          initState: (_) {},
          builder: (_) {
            return IconButton(
              onPressed: () {
                themeController.changeThemeOfButtons();
                themeController.isDarkMode
                    ? Get.changeThemeMode(ThemeMode.dark)
                    : Get.changeThemeMode(ThemeMode.light);
              },
              icon: Icon(
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: iconTheme.color,
                size: iconTheme.size,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
