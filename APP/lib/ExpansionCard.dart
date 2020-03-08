import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpansionCard extends StatefulWidget {
  final item;
  final myColor;
  ExpansionCard(this.item, this.myColor);

  @override
  _ExpansionCardState createState() => _ExpansionCardState();
}

class _ExpansionCardState extends State<ExpansionCard>
    with TickerProviderStateMixin {
  AnimationController _arrowController;
  AnimationController _containerController;
  Animation _containerAnimation;
  DateTime _timeInit;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // print(widget.item["users"]);
    _timeInit = DateTime.parse(widget.item["timeInit"]);

    _arrowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    _containerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    _containerAnimation =
        Tween<double>(begin: 0.0, end: 180.0).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: _containerController,
    ));

    _arrowController.forward();
    _containerController.forward();
    _arrowController.reverse();
    _containerController.reverse();
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: widget.myColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: new Offset(4.0, 4.0),
            blurRadius: 4.0,
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              if (_isExpanded) {
                _arrowController.forward(from: 0.0);
                _containerController.forward(from: 0.0);
              } else {
                _arrowController.reverse();
                _containerController.reverse();
              }
            },
            child: Container(
              height: 80,
              // margin: EdgeInsets.only(top: 15,left: 15, right: 15),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8), ),
                borderRadius: BorderRadius.circular(8),
                color: widget.myColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    // color: Colors.black.withOpacity(0.3),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Grupo ${widget.item["idGroup"].toString()}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${DateFormat("HH:mm").format(_timeInit).toString()}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                                // height: 20,
                              ),
                              Text(
                                "Usuários: ${widget.item["users"].length.toString()}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Divider(),
                        Container(
                          child: AnimatedBuilder(
                            animation: _arrowController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _arrowController.value * pi,
                                child: child,
                                origin: Offset(0, 0),
                              );
                            },
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: Container(
              width: double.maxFinite,
              child: AnimatedBuilder(
                animation: _containerAnimation,
                builder: (context, child) {
                  return Container(
                    color: widget.myColor,
                    height: _containerAnimation.value,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: renderUsers(widget.item["users"]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> renderUsers(List listUsers) {
    List<Widget> childs = [];
    for (var i = 0; i < listUsers.length; i++) {
      childs.add(Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  "Usuário: ${listUsers[i]["Moid"]}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.directions_car,
                color: Colors.white,
              ),
              Flexible(
                child: Text(
                  "${listUsers[i]["Model"]} - ${listUsers[i]["Licence"]}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.white,
            height: 30,
          ),
          // Text("Model: ${listUsers[i]["Model"]}"),
        ],
      ));
    }
    return childs;
  }
}
