import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tbk_app/modle/upload_file_entity.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/shared_preference_util.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:video_player/video_player.dart';

import '../../entity_factory.dart';

class UserSetUpPage extends StatefulWidget {
  @override
  _UserSetUpPageState createState() => _UserSetUpPageState();
}

class _UserSetUpPageState extends State<UserSetUpPage> {
  UserInfoEntity userInfoEntity  = new UserInfoEntity();

  File _imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    HttpUtil().get('getUser').then((val) {
      if (val["success"]) {
        setState(() {
          userInfoEntity = EntityFactory.generateOBJ<UserInfoEntity>(val['data']);
        });
      }
    });
  }

  /// init pick start

  /// image
  void _onImageButtonPressed(ImageSource source) async {
    try {
      _imageFile = await ImagePicker.pickImage(source: source);
      HttpUtil().uploadImg(_imageFile).then((val) {
        UploadFileEntity uploadFileEntity =
            EntityFactory.generateOBJ<UploadFileEntity>(val);

        Map<String, Object> map = Map();
        //map["name"] =   4;
        map["avatarUrl"] = uploadFileEntity.data;
        //map["phone"] =   _password;

        HttpUtil()
            .get('updateUser', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
            .then((val) {
          if (val["success"]) {
            UserInfoEntity userInfoEntityr =
                EntityFactory.generateOBJ<UserInfoEntity>(val['data']);

            SpUtil.putString("tocken", userInfoEntityr.tocken);
            setState(() {
              userInfoEntity.avatarUrl = uploadFileEntity.data;
              print(userInfoEntity.avatarUrl);
            });
          }
        });
      });
    } catch (e) {
      print("上传图片异常");
      print(e);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget sletctPick() {
    return userInfoEntity == null
        ? Container()
        : Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text("拍照"),
                  onTap: () async {
                    _onImageButtonPressed(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text("相册"),
                  onTap: () async {
                    _onImageButtonPressed(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
  }

  /// init pick end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.red,
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0.5,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              "设置",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black45,
            ),
            onPressed: () {
              NavigatorUtil.goBack(context);
            },
          ),
        ),
        preferredSize: Size.fromHeight(ScreenUtil.screenHeight * 0.02),
      ),

      body: Container(
        color: Colors.white24,
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return sletctPick();
                    });
              },
              child: Container(
                padding: EdgeInsets.all(30),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.50, color: Colors.white),
                          borderRadius: BorderRadius.circular(50)),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            new NetworkImage("${userInfoEntity.avatarUrl}"),
                      ),
                    ),
                    Text('点击修改头像')
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 20),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "昵称   ",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Text(
                          "${userInfoEntity.name}",
                          style: TextStyle(color: Colors.black45, fontSize: 11),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "修改",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "我的标签",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "设置",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 20),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "注册时间",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "${userInfoEntity.brithday}",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.white,
//                margin: EdgeInsets.only(top: 20),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "账户安全",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "手机号 支付宝",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 20),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "消息通知",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // dialog 弹框
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, state) {
                      return AlertDialog(
                        title: Container(
                          alignment: Alignment.center,
                          child: Text("提示"),
                        ),
                        content: Container(
                          height: ScreenUtil().setHeight(40),
                          alignment: Alignment.center,
                          child: Text("确认退出登录吗？"),
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop('-1');
                              },
                              child: Text('取消')),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop('1');
                                SpUtil.remove("tocken");
                                NavigatorUtil.gotransitionPage(
                                    context, "${Routers.root}");
                              },
                              child: Text('确定')),
                        ],
                      );
                    });
                  },
                );
              },
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  "退出登录",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
