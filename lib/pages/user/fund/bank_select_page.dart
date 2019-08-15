
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:azlistview/azlistview.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'models/bank_model.dart';

class BankSelectPage extends StatefulWidget {
  
  const BankSelectPage({Key key, this.type}) : super(key: key);
  
  final int type;
  
  @override
  _BankSelectPageState createState() => _BankSelectPageState();
}

class _BankSelectPageState extends State<BankSelectPage> {

  List<BankModel> _bankList = [];
  List<String> _bankNameList = ["工商银行", "建设银行", "中国银行", "农业银行", "招商银行", "交通银行", "中信银行", "民生银行", "兴业银行", "浦发银行"];
  List<String> _bankLogoList = ["gongshang", "jianhang", "zhonghang", "nonghang", "zhaohang", "jiaohang", "zhongxin", "minsheng", "xingye", "pufa"];
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // 获取城市列表
    rootBundle.loadString(widget.type == 0 ? 'assets/data/bank.json' : 'assets/data/bank_2.json').then((value) {
      List list = json.decode(value);
      list.forEach((value) {
        _bankList.add(BankModel(value['id'], value['bankName'], value['firstLetter']));
      });
      SuspensionUtil.sortListBySuspensionTag(_bankList);
      setState(() {
       
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.type == 0 ? "开户银行" : "选择支行",
      ),
      body: SafeArea(
        child: AzListView(
          data: _bankList,
          itemBuilder: (context, model) => _buildListItem(model),
          isUseRealIndex: true,
          itemHeight: 40,
          suspensionWidget: null,
          suspensionHeight: 0,
          indexBarBuilder:(context, list, onTouch){
            return IndexBar(
              onTouch: onTouch,
              data: list,
              itemHeight: 25,
              touchDownColor: Colors.transparent,
              textStyle: TextStyles.textGray12
            );
          },
          header: widget.type == 0 ? AzListViewHeader(
            tag: "常用",
            height: 430, 
            builder: (context){
              return _buildHeader();
            }
          ) : null,
        ),
      ),
    );
  }

  _buildHeader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 16.0),
          child: Text("常用", style: TextStyles.textGray12),
        ),
        Expanded(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemExtent: 40.0,
            itemCount: _bankNameList.length,
            itemBuilder: (_, index){
              return InkWell(
                onTap: (){
                  NavigatorUtil.goBackWithParams(context, BankModel(0, _bankNameList[index], ""));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      loadAssetImage("user/account/${_bankLogoList[index]}",width: 24.0),
                      Gaps.hGap8,
                      Text(_bankNameList[index], style: TextStyles.textDark14),
                    ],
                  ),
                ),
              );
            }
          ),
        )
      ],
    );
  }

  Widget _buildListItem(BankModel model) {
    return InkWell(
      onTap: (){
        NavigatorUtil.goBackWithParams(context, model);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 34.0),
        height: 40.0,
        child: Container(
          decoration: BoxDecoration(
            border: (model.isShowSuspension && model.id != 17749) ? Border(
              top: Divider.createBorderSide(context, color: Colours.line, width: 0.6),
            ) : null
          ),
          child: Row(
            children: <Widget>[
              Opacity(
                opacity: model.isShowSuspension ? 1 : 0,
                child: SizedBox(
                  width: 28.0,
                  child: Text(model.firstLetter, style: TextStyles.textDark14),
                )
              ),
              Expanded(
                child: Text(model.bankName, style: TextStyles.textDark14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
