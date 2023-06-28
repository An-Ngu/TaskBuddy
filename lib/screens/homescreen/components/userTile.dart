import 'package:flutter/material.dart';
import 'package:task/utils/User.dart';

class UserTile extends StatelessWidget {
  final User user;
  User currentUser;
  final Function callbackFunction;

  UserTile({Key? key, required this.user, required this.currentUser, required this.callbackFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return InkWell(
      onTap: () {
        print("${user.name} wurde selektiert");
        currentUser = user;
        callbackFunction(currentUser);
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
              Flexible(
                  child: Image.asset("assets/images/${user.iconname}")),
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
}
