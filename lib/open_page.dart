import 'package:flutter/material.dart';
import 'package:nautilus/nautilus.dart' as nautilus;

class OpenByPage extends StatefulWidget {
  @override
  _OpenByPageState createState() => _OpenByPageState();
}

class _OpenByPageState extends State<OpenByPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OpenByPage"),
      ),
      body: ListView(
        children: <Widget>[
          FlatButton(
            onPressed: _openItemDetail,
            child: Text("打开淘宝详情"),
          ),
          FlatButton(
            onPressed: _openUrl,
            child: Text("打开Url"),
          )
        ],
      ),
    );
  }

  _openItemDetail() {


    Map<String, String> taoKeParamsextraParams = new Map();
    taoKeParamsextraParams['taokeAppkey'] = '24900413';

    Map<String, String> extraParams = new Map();
    extraParams['isv_code'] = 'appisvcode';


    nautilus.openItemDetail(
        itemID: "591587602964",
        taoKeParams: nautilus.TaoKeParams(
            unionId: "",
            subPid: "mm_114747138_45538443_624654015",
            pid: "mm_114747138_45538443_624654015",
            adzoneId: "624654015",
            extParams:taoKeParamsextraParams
        ),
        openType:nautilus.OpenType.NATIVE,
        schemeType:"taobao_oscheme",
        extParams:extraParams

    );



  }

  _openUrl() {
    nautilus.openUrl(
        pageUrl: "https://uland.taobao.com/coupon/edetail?e=ERTS0JCtYnAGQASttHIRqQoOaIothlNYFvWzfpVjfDKAnVXUwZx8IuIslmkmHg9Q%2Fo6dic6nhm3gxS33AuDi7ysm0R7yoZkxDfqEFBOhTcwXFgHKPFWz1Z2%2BeDkiyEM1QNYNjOu4S%2BzIV6LHTHCOse1LRo38GBz3tFguQLGdWuzYhpVVy38fp6zroKjs8vldxfFlZSCevACwmYQwT%2FYTeHui%2Fn%2FQ7Z5VNGW5Obm5c1GH6s3NfzeYtQ%3D%3D&traceId=0bb28d8615617149585712563e"
    );

    }
}
