
import 'package:flutter/material.dart';
import 'package:tbk_app/pages/user/fund/sms_verify_dialog.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/utils.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/base_dialog.dart';
import 'package:tbk_app/widgets/click_item.dart';

import 'withdrawal_password_setting_dialog.dart';

class WithdrawalPasswordPage extends StatefulWidget {
  @override
  _WithdrawalPasswordPageState createState() => _WithdrawalPasswordPageState();
}

class _WithdrawalPasswordPageState extends State<WithdrawalPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: "提现密码",
      ),
      body: Column(
        children: <Widget>[
          Gaps.vGap5,
          ClickItem(
            title: "修改密码",
            onTap: (){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return WithdrawalPasswordSettingDialog();
                  }
              );
            }
          ),
          ClickItem(
            title: "忘记密码",
            onTap: (){
              showElasticDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return BaseDialog(
                    hiddenTitle: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Text("为了您的账户安全需先进行短信验证并设置提现密码。", style: TextStyles.textDark14, textAlign: TextAlign.center),
                    ),
                    onPressed: (){
                      NavigatorUtil.goBack(context);
                      _showVerifyDialog();
                    },
                  );
                }
              );
            }
          ),
        ],
      ),
    );
  }
  
  _showVerifyDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SMSVerifyDialog();
        }
    );
  }
}
