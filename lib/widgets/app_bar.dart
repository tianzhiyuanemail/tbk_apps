import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tbk_app/res/resources.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {Key key,
      this.backgroundColor: Colours.appbar_red,
      this.title: "",
      this.centerTitle: "",
      this.actionName: "",
      this.backImg: "assets/images/sys/ic_back_black.png",
      this.onPressed,
      this.isBack: true})
      : super(key: key);

  final Color backgroundColor;
  final String title;
  final String centerTitle;
  final String backImg;
  final String actionName;
  final VoidCallback onPressed;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle _overlayStyle =
        ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Material(
        color: backgroundColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: centerTitle.isEmpty
                        ? Alignment.centerLeft
                        : Alignment.center,
                    width: double.infinity,
                    child: Text(title.isEmpty ? centerTitle : title,
                        style: TextStyle(
                          fontSize: 18,
                          color: _overlayStyle == SystemUiOverlayStyle.light
                              ? Colors.white
                              : Colours.text_dark,
                        )),
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  )
                ],
              ),
              isBack
                  ? IconButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.maybePop(context);
                      },
                      padding: const EdgeInsets.all(12.0),
                      icon: Image.asset(
                        backImg,
                        color: _overlayStyle == SystemUiOverlayStyle.light
                            ? Colors.white
                            : Colours.text_dark,
                      ),
                    )
                  : Gaps.empty,
              Positioned(
                right: 0.0,
                child: Theme(
                  data: ThemeData(
                      buttonTheme: ButtonThemeData(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    minWidth: 60.0,
                  )),
                  child: actionName.isEmpty
                      ? Container()
                      : FlatButton(
                          child: Text(actionName),
                          textColor: _overlayStyle == SystemUiOverlayStyle.light
                              ? Colors.white
                              : Colours.text_dark,
                          highlightColor: Colors.transparent,
                          onPressed: onPressed,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key key,
    this.backgroundColor: Colors.white,
    this.title,
    this.leadingText,
    this.bottom,
    this.actions,
  }) : super(key: key);

  final Color backgroundColor;

  final String leadingText;
  final Widget title;
  final Widget bottom;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      brightness: ThemeData.estimateBrightnessForColor(backgroundColor) ==
              Brightness.dark
          ? Brightness.dark
          : Brightness.light,
      iconTheme: IconThemeData(
        color: Colors.black45,
        opacity: 0.5,
        size: 30,
      ),
      textTheme: TextTheme(),
      centerTitle: true,
      bottomOpacity: 0.8,
      titleSpacing: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return Align(
            widthFactor: 10,
            alignment: Alignment.center,
            child: Text(leadingText, style: TextStyles.textNormal14),
          );
        },
      ),
      title: title,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(85.0);
}
