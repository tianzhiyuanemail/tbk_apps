
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:azlistview/azlistview.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'models/city_model.dart';

class CitySelectPage extends StatefulWidget {
  @override
  _CitySelectPageState createState() => _CitySelectPageState();
}

class _CitySelectPageState extends State<CitySelectPage> {

  List<CityModel> _cityList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // 获取城市列表
    rootBundle.loadString('assets/data/city.json').then((value) {
      List list = json.decode(value);
      list.forEach((value) {
        _cityList.add(CityModel(value['name'], value['cityCode'], value['firstCharacter']));
      });
      setState(() {
       
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "开户地点",
      ),
      body: SafeArea(
        child: AzListView(
          data: _cityList,
          itemBuilder: (context, model) => _buildListItem(model),
          isUseRealIndex: true,
          itemHeight: 40,
          suspensionWidget: null,
          suspensionHeight: 0,
          indexBarBuilder:(context, list, onTouch){
            return IndexBar(
              onTouch: onTouch,
              data: list,
              itemHeight: 18,
              touchDownColor: Colors.transparent,
              textStyle: TextStyles.textGray12
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(CityModel model) {
    return InkWell(
      onTap: (){
        NavigatorUtil.goBackWithParams(context, model);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 34.0),
        height: 40.0,
        child: Container(
          decoration: BoxDecoration(
            border: (model.isShowSuspension && model.cityCode != "0483") ? Border(
              top: Divider.createBorderSide(context, color: Colours.line, width: 0.6),
            ) : null
          ),
          child: Row(
            children: <Widget>[
              Opacity(
                opacity: model.isShowSuspension ? 1 : 0,
                child: SizedBox(
                  width: 28.0,
                  child: Text(model.firstCharacter, style: TextStyles.textDark14),
                )
              ),
              Expanded(
                child: Text(model.name, style: TextStyles.textDark14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
