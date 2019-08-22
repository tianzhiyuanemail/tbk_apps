import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tbk_app/modle/upload_file_entity.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/pages/user/setting/update_dialog.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/click_item.dart';

import '../../../entity_factory.dart';
import 'exit_dialog.dart';

class SettingPage extends StatefulWidget {
  @override
  _UserSetUpPageState createState() => _UserSetUpPageState();
}

class _UserSetUpPageState extends State<SettingPage> {
  UserInfoEntity userInfoEntity = new UserInfoEntity();

  File _imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HttpUtil().get('getUser').then((val) {
      if (val["success"]) {
        setState(() {
          userInfoEntity =
              EntityFactory.generateOBJ<UserInfoEntity>(val['data']);
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
      appBar: MyAppBar(
        centerTitle: "设置",
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
            Gaps.vGap5,
            ClickItem(
                title: "昵称",
                littleTitle: "昵称",
                content: "修改",
                onTap: () {
                  NavigatorUtil.push(context, Routers.updateNamePage);
                }
            ),
            ClickItem(
                title: "我的标签",
                content: "已设置",
                onTap: () {
                  NavigatorUtil.push(context, Routers.updateTagPage);
                }
            ),
            ClickItem(
                title: "修改密码",
                content: "用于密码登录",
                onTap: () {
                  NavigatorUtil.push(context, Routers.updatePasswordPage);
                }
            ),
            ClickItem(
                title: "注册时间",
                content: "2019-09-07",
                onTap: () {}
            ),
            ClickItem(
                title: "清除缓存",
                content: "23.5MB",
                onTap: () {}
            ),
            ClickItem(
                title: "账户安全",
                content: "支付宝 微信",
                onTap: () {
                  NavigatorUtil.push(context, Routers.userSecurityPage);
                }
            ),
            ClickItem(
                title: "检查更新",
                onTap: () {
                  _showUpdateDialog();
                }
            ),
            ClickItem(
                title: "关于我们",
                onTap: () {
                  NavigatorUtil.push(context, 'SettingRouter.aboutPage');
                }
            ),
            ClickItem(
                title: "退出当前账号",
                mtop: 20,
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => ExitDialog()
                  );
                }
            ),

          ],
        ),
      ),
    );
  }

  void _showUpdateDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UpdateDialog();
        }
    );
  }
}
