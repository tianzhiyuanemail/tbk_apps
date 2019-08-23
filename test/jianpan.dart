import  'package:flutter/material.dart';
import  'package:keyboard_actions/keyboard_actions.dart';

import 'util.dart';
import 'package:tbk_app/widgets/MyScaffold.dart';


//Full screen
class ScaffoldTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MyScaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Keyboard Actions Sample"),
      ),
      body: FormKeyboardActions(
        child: Content(),
      ),
    );
  }
}


class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final FocusNode _nodeText1 = FocusNode();

  @override
  void initState() {
    Util.setKeyboardActions(context,[_nodeText1]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.text,
                focusNode: _nodeText1,
                decoration: InputDecoration(
                  hintText: "Input Number",
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}