
import 'package:flutter/material.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/image_utils.dart';
 import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/state_layout.dart';

import 'models/withdrawal_account_model.dart';

class WithdrawalAccountPage extends StatefulWidget {
  @override
  _WithdrawalAccountPageState createState() => _WithdrawalAccountPageState();
}

class _WithdrawalAccountPageState extends State<WithdrawalAccountPage> {
  
  List<WithdrawalAccountModel> _list = [];
  
  @override
  void initState() {
    super.initState();
    _list.clear();
    _list.add(WithdrawalAccountModel("唯鹿", "微信", 1, ""));
    _list.add(WithdrawalAccountModel("李*", "工商银行", 0, "**** **** **** 5236"));
    _list.add(WithdrawalAccountModel("李*", "渤海银行", 0, "**** **** **** 2165"));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: "提现账号",
        actionName: "添加",
        onPressed: (){
          NavigatorUtil.push(context, Routers.addWithdrawalAccountPage);
        }
      ),
      body: _list.isEmpty ? StateLayout(
        type: StateType.account) : 
      ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        itemCount: _list.length,
        itemExtent: 151.0,
        itemBuilder: (_, index){
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: AccountCard(
              type: _list[index].type,
              child: InkWell(
                //Toast.show("长按删除账号！");
                onLongPress: (){
                  _showDeleteBottomSheet(index);
                },
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 25.0,
                        left: 24.0,
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: loadAssetImage(_list[index].type == 1 ? "user/account/wechat" : "account/yhk")
                        ),
                      ),
                      Positioned(
                        top: 22.0,
                        left: 72.0,
                        child: Text(_list[index].typeName, style: TextStyle(color: Colors.white, fontSize: Dimens.font_sp18)),
                      ),
                      Positioned(
                        top: 48.0,
                        left: 72.0,
                        child: Text(_list[index].name, style: TextStyle(color: Colors.white, fontSize: 12.0)),
                      ),
                      Positioned(
                        bottom: 24.0,
                        left: 72.0,
                        child: Text(_list[index].code, style: TextStyle(color: Colors.white, fontSize: Dimens.font_sp18, letterSpacing: 1.0)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showDeleteBottomSheet(int index){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.white,
          child: SafeArea(
            child: Container(
                height: 161.2,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 52.0,
                      child: Text(
                        "是否确认解绑，防止错误操作",
                        style: TextStyles.textGray16,
                      ),
                    ),
                    Gaps.line,
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Colours.text_red,
                        child: Text("确认解绑", style: TextStyle(fontSize: Dimens.font_sp18)),
                        onPressed: (){
                          setState(() {
                            _list.removeAt(index);
                          });
                          NavigatorUtil.goBack(context);
                        },
                      ),
                    ),
                    Gaps.line,
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Colours.text_gray,
                        child: Text("取消", style: TextStyle(fontSize: Dimens.font_sp18)),
                        onPressed: (){
                          NavigatorUtil.goBack(context);
                        },
                      ),
                    ),
                  ],
                )
            ),
          ),
        );
      },
    );
  }
}

class AccountCard extends StatefulWidget {

  const AccountCard({
    Key key,
    @required this.child,
    this.type
  }): super(key: key);

  final Widget child;
  final int type;

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: widget.type == 1 ? Color(0x804EE07A) : Color(0x805793FA), offset: Offset(0.0, 2.0), blurRadius: 8.0, spreadRadius: 0.0),
        ],
        gradient: LinearGradient(
          colors: widget.type == 1 ? [Color(0xFF40E6AE), Color(0xFF2DE062)] : [Color(0xFF57C4FA), Color(0xFF4688FA)]
        )
      ),
      child: widget.child,
    );
  }
}
