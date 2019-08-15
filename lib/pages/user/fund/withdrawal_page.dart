
import 'package:flutter/material.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/util/number_text_input_formatter.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/my_button.dart';

import 'models/withdrawal_account_model.dart';

class WithdrawalPage extends StatefulWidget {
  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  
  TextEditingController _controller = TextEditingController();
  int _withdrawalType = 0;
  bool _isClick = false;
  WithdrawalAccountModel _data = WithdrawalAccountModel("尾号5236 李艺", "工商银行", 0, "123");
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_verify);
  }

  void _verify(){
    String price = _controller.text;
    if (price.isEmpty || double.parse(price) < 1) {
      setState(() {
        _isClick = false;
      });
      return;
    }
    setState(() {
      _isClick = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        /// 拦截返回，关闭键盘，否则会造成上一页面短暂的组件溢出
        FocusScope.of(context).requestFocus(FocusNode());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: "提现",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Gaps.vGap5,
              InkWell(
                onTap: (){
                  NavigatorUtil.pushResult(context, Routers.withdrawalAccountListPage, (result){
                    setState(() {
                      _data = result;
                    });
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: double.infinity,
                  height: 74.0,
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      loadAssetImage(_data.type == 0 ? "user/account/yhk" : "user/account/wechat", width: 24.0),
                      Gaps.hGap16,
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_data.typeName, style: TextStyles.textDark14),
                            Gaps.vGap8,
                            Text(_data.name, style: TextStyles.textGray12),
                          ],
                        ),
                      ),
                      loadAssetImage("ic_arrow_right",
                        height: 16.0,
                        width: 16.0,
                      )
                    ],
                  ),
                ),
              ),
              Gaps.vGap16,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("提现金额", style: TextStyles.textBoldDark14),
                        Text("单笔2万，单日2万", style: TextStyle(fontSize: 12.0, color: Color(0xFFFF8547)))
                      ],
                    ),
                    Gaps.vGap8,
                    Row(
                      children: <Widget>[
                        Container(
                          width: 15.0,
                          height: 40.0,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: loadAssetImage("user/account/rmb")
                        ),
                        Gaps.hGap8,
                        Expanded(
                          child: TextField(
                            maxLength: 10,
                            controller: _controller,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [UsNumberTextInputFormatter()],
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 8.0),
                              hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFFCCCCCC)
                              ),
                              hintText: "不能少于1元",
                              counterText: "",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gaps.line,
                    Gaps.vGap8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("最多可提现70元", style: TextStyles.textGray12),
                        InkWell(
                          onTap: (){
                            _controller.text = "70";
                          },
                          child: Text("全部提现", style: TextStyles.textMain12)
                        )
                      ],
                    ),
                    Gaps.vGap16,
                    Gaps.vGap16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("转出方式", style: TextStyles.textBoldDark14),
                        loadAssetImage("user/account/sm", width: 16.0)
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          _withdrawalType = 0;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 74.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 18.0,
                              left: 0.0,
                              child: loadAssetImage(_withdrawalType == 0 ? "user/account/txxz" : "user/account/txwxz", width: 16.0)
                            ),
                            Positioned(
                              top: 16.0,
                              left: 24.0,
                              right: 0.0,
                              child: Text("快速到账", style: TextStyles.textDark14)
                            ),
                            Positioned(
                              bottom: 16.0,
                              left: 24.0,
                              right: 0.0,
                              child: RichText(
                                text: TextSpan(
                                  text: '手续费按',
                                  style: TextStyles.textDark12,
                                  children: <TextSpan>[
                                    TextSpan(text: '0.3%', style: TextStyle(color: Color(0xFFFF8547))),
                                    TextSpan(text: '收取'),
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gaps.line,
                    InkWell(
                      onTap: (){
                        setState(() {
                          _withdrawalType = 1;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 74.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 18.0,
                              left: 0.0,
                              child: loadAssetImage(_withdrawalType == 1 ? "user/account/txxz" : "user/account/txwxz", width: 16.0)
                            ),
                            Positioned(
                              top: 16.0,
                              left: 24.0,
                              right: 0.0,
                              child: Text("普通到账", style: TextStyles.textDark14)
                            ),
                            Positioned(
                              bottom: 16.0,
                              left: 24.0,
                              right: 0.0,
                              child: RichText(
                                text: TextSpan(
                                  text: '预计',
                                  style: TextStyles.textDark12,
                                  children: <TextSpan>[
                                    TextSpan(text: 'T+1天到账(免手续费，T为工作日)', style: TextStyle(color: Color(0xFFFF8547))),
                                   ],
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gaps.vGap16,
                    Gaps.vGap8,
                    MyButton(
                      onPressed: _isClick ? (){
                        NavigatorUtil.push(context,  Routers.withdrawalResultPage);
                      } : null,
                      text: "提现",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),  
      ),
    );
  }
}
