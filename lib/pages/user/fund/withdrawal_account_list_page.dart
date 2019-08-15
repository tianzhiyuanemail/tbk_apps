
import 'package:flutter/material.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/widgets/app_bar.dart';

import 'models/withdrawal_account_model.dart';

class WithdrawalAccountListPage extends StatefulWidget {
  @override
  _WithdrawalAccountListPageState createState() => _WithdrawalAccountListPageState();
}

class _WithdrawalAccountListPageState extends State<WithdrawalAccountListPage> {
  
  int _selectIndex = 0;
  List<WithdrawalAccountModel> _list = [];
  
  @override
  void initState() {
    super.initState();
    _list.clear();
    _list.add(WithdrawalAccountModel("尾号5236 李艺", "工商银行", 0, "123"));
    _list.add(WithdrawalAccountModel("唯鹿", "微信", 1, ""));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: "选择账号",
        actionName: "添加",
        onPressed: (){
          NavigatorUtil.push(context, Routers.addWithdrawalAccountPage);
        }
      ),
      body: ListView.separated(
        itemCount: _list.length,
        separatorBuilder: (_, index) {
          return Divider(height: 0.6);
        },
        itemBuilder: (_, index){
          return InkWell(
            onTap: (){
              NavigatorUtil.goBackWithParams(context, _list[index]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              height: 74.0,
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  loadAssetImage(_list[index].type == 0 ? "user/account/yhk" : "user/account/wechat", width: 24.0),
                  Gaps.hGap16,
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_list[index].typeName, style: TextStyles.textDark14),
                        Gaps.vGap8,
                        Text(_list[index].name, style: TextStyles.textDark12),
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: _selectIndex != index,
                    child: loadAssetImage(
                      "user/account/selected",
                      height: 24.0,
                      width: 24.0,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
