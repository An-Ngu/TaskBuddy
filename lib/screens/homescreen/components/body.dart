import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task/screens/homescreen/components/userTile.dart';
import 'package:task/utils/Task.dart';
import 'package:task/utils/User.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List<Task> allTaskList;
  late List<Task> userTaskList = [];
  late User currentUser = userList[0];
  late List<User> userList;

  callback(user) {
    setState(() {
      currentUser = user;
    });
  }

  @override
  void initState() {
    allTaskList = getTasks();
    userList = getUsers();
    userTaskList = [allTaskList[0]];
    super.initState();
  }

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [createContentIcons(userTaskList)],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                userchart(),
                showUser(),
              ],
            ),
          ),
          Expanded(
            child: createCalender(),
          ),
        ],
      ),
    );
  }

  Container userchart() {
    return Container(
      height: size.height * 0.4,
      child: Stack(children: [
        SfCircularChart(
          series: [
            DoughnutSeries<User, String>(
                animationDuration: 100,
                dataSource: userList,
                xValueMapper: (User data, index) => data.name,
                yValueMapper: (User data, index) => data.points,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  connectorLineSettings:
                      ConnectorLineSettings(type: ConnectorType.line),
                  useSeriesColor: false,
                ))
          ],
        ),
        Center(
            child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                height: size.height * 0.14,
                child: Image.asset("assets/images/${currentUser.iconname}")))
      ]),
    );
  }

  List<Task> getTasks() {
    final List<Task> taskData = [
      Task("Staubsaugen", 10, "assets/images/001-vacuum.png"),
      Task("Kochen", 10, "assets/images/001-cooking.png"),
      Task("Müll entsorgen", 10, "assets/images/002-trash.png"),
      Task("Wäsche anmachen", 10, "assets/images/004-laundry-machine.png"),
      Task("Wäsche ausräumen", 10, "assets/images/003-laundry.png"),
      Task("Spülmaschine", 10, "assets/images/005-washing-dishes.png"),
    ];
    return taskData;
  }

  showUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return UserTile(
                    user: userList[index],
                    currentUser: currentUser,
                    callbackFunction: callback,
                  );
                }),
          ),
        )
      ],
    );
  }

  // userTile(User user) {
  //   return InkWell(
  //     onTap: () {
  //       print("${user.name} wurde selektiert");
  //       setState(() {
  //         currentUser = user;
  //       });
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Container(
  //         padding: EdgeInsets.all(10),
  //         height: size.height * 0.08,
  //         width: size.width * 0.04,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(color: Colors.black12)),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Flexible(child: Image.asset("assets/images/${user.iconname}")),
  //             Text(
  //               user.name,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  List<User> getUsers() {
    final List<User> users = <User>[
      User("An", "man-user.png"),
      User("Charleen", "businesswoman.png"),
    ];

    return users;
  }

  Widget createContentIcons(List<Task> list) {
    return Expanded(
      child: Center(
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: list.length + 1,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 3 / 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (BuildContext context, index) {
              return index == list.length
                  ? emptyTile()
                  : taskTile(list[index], false);
            }),
      ),
    );
  }

  Widget taskTile(Task task, bool isAddingToList) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isAddingToList) {
            !userTaskList.contains(task) ? userTaskList.add(task) : null;
          } else {
            currentUser.points = currentUser.points + task.points;
            print("${currentUser.points}");
          }
        });
      },
      onLongPress: () {
        setState(() {
          ;
          userTaskList.remove(task);
        });
      },
      child: Column(
        children: [
          Expanded(child: Image.asset(task.icon)),
          Expanded(
              child: Text(
            task.name,
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }

  InkWell emptyTile() {
    return InkWell(
      onTap: () {
        openTaskOptions(false);
        //createContentIcons(allTaskList);
        setState(() {});
      },
      child: Column(
        children: [
          Expanded(child: Image.asset("assets/images/add-image.png")),
          Text(
            'Add',
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget openTaskOptions(bool isGeneralList) {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Text('Aufgaben'),
        content: Flexible(
          child: Container(
            padding: EdgeInsets.all(20),
            width: size.width * 0.2,
            child: GridView.builder(
                itemCount: allTaskList.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100),
                itemBuilder: (BuildContext context, index) {
                  return taskTile(allTaskList[index], true);
                }),
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });

    return alert;
  }

  Widget createCalender() {

    List<DateTime> presentDates = [
      DateTime(2023, 6, 1),
      DateTime(2023, 6, 3),
      DateTime(2023, 6, 4),
      DateTime(2023, 6, 5),
      DateTime(2023, 6, 6),
      DateTime(2023, 6, 9),
      DateTime(2023, 6, 10),
      DateTime(2023, 6, 11),
      DateTime(2023, 6, 15),
      DateTime(2023, 6, 22),
      DateTime(2023, 6, 23),
    ];
    List<DateTime> absentDates = [
      DateTime(2023, 6, 2),
      DateTime(2023, 6, 7),
      DateTime(2023, 6, 8),
      DateTime(2023, 6, 12),
      DateTime(2023, 6, 13),
      DateTime(2023, 6, 14),
      DateTime(2023, 6, 16),
      DateTime(2023, 6, 17),
      DateTime(2023, 6, 18),
      DateTime(2023, 6, 19),
      DateTime(2023, 6, 20),
    ];

    int len = min(absentDates.length, presentDates.length);

    EventList<Event> _markedDateMap = EventList<Event>(
      events: {},
    );
    
    for (int i = 0; i < len; i++) {
      _markedDateMap.add(
        presentDates[i],
        new Event(
          date: presentDates[i],
          title: 'Event 5',
          icon: _presentIcon(
            presentDates[i].day.toString(),
          ),
        ),
      );
  }

    for (int i = 0; i < len; i++) {
      _markedDateMap.add(
        absentDates[i],
        new Event(
          date: absentDates[i],
          title: 'Event 5',
          icon: _absentIcon(
            absentDates[i].day.toString(),
          ),
        ),
      );
    }
    return CalendarCarousel(
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      weekFormat: false,
      selectedDayBorderColor: Colors.green,
      markedDatesMap: _markedDateMap,
      selectedDayButtonColor: Colors.green,
      selectedDayTextStyle: TextStyle(color: Colors.green),
      todayBorderColor: Colors.transparent,
      weekdayTextStyle: TextStyle(color: Colors.black),
      height: 420.0,
      daysHaveCircularBorder: true,
      todayButtonColor: Colors.indigo,
      locale: 'de',
      onDayPressed: (DateTime time,List<Event> events){
        print(events.length);
        setState(() {
          events.add(Event(date: DateTime.now(),title: "Test"),);
        });
      },
    );
}

  static Widget _presentIcon(String day) => CircleAvatar(
    backgroundColor: Colors.green,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static Widget _absentIcon(String day) => CircleAvatar(
    backgroundColor: Colors.red,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );
}
