import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            ),
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
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return userTile(userList[index]);
                }),
          ),
        )
      ],
    );
  }

  userTile(User user) {
    return InkWell(
      onTap: () {
        print("${user.name} wurde selektiert");
        setState(() {
          currentUser = user;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(10),
          height: size.height * 0.08,
          width: size.width * 0.04,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Image.asset("assets/images/${user.iconname}")),
              Text(
                user.name,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<User> getUsers() {
    final List<User> users = <User>[
      User("An", "man-user.png"),
      User("Charleen", "businesswoman.png"),
    ];

    return users;
  }

  Widget createContentIcons(List list) {
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
              return index == list.length ? emptyTile() : taskTile(index);
            }),
      ),
    );
  }

  Widget taskTile(int index) {
    Task task = allTaskList[index];
    return InkWell(
      onTap: () {
        setState(() {
          Task task = allTaskList[index];
          currentUser.points = currentUser.points + task.points;
          print("${currentUser.points}");
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
        //openTaskOptions(false);
        createContentIcons(allTaskList);
        setState(() {


        });
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
                  return taskTile(index);
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
}
