
import 'package:nautilus/nautilus.dart' as nautilus;

class NautilusUtil{

 static openItemDetail(String itemId) {


    Map<String, String> taoKeParamsextraParams = new Map();
    taoKeParamsextraParams['taokeAppkey'] = '24900413';

    Map<String, String> extraParams = new Map();
    extraParams['isv_code'] = 'appisvcode';


    nautilus.openItemDetail(
        itemID: itemId,
        taoKeParams: nautilus.TaoKeParams(
            unionId: "",
            subPid: "mm_114747138_45538443_624654015",
            pid: "mm_114747138_45538443_624654015",
            adzoneId: "624654015",
            extParams:taoKeParamsextraParams
        ),
        needPush: true,
        openType:nautilus.OpenType.NATIVE,
        schemeType:"tmall_scheme", /// ios 必须设置为 tmall
        extParams:extraParams

    );



  }

 static openUrl(String url) {
    Map<String, String> taoKeParamsextraParams = new Map();
    taoKeParamsextraParams['taokeAppkey'] = '24900413';

    Map<String, String> extraParams = new Map();
    extraParams['isv_code'] = 'appisvcode';

    nautilus.openUrl(
        pageUrl: url,
        taoKeParams: nautilus.TaoKeParams(
            unionId: "",
            subPid: "mm_114747138_45538443_624654015",
            pid: "mm_114747138_45538443_624654015",
            adzoneId: "624654015",
            extParams:taoKeParamsextraParams
        ),
        needPush: true,
        openType:nautilus.OpenType.NATIVE,
        schemeType:"tmall_scheme", /// ios 必须设置为 tmall
        extParams:extraParams
    );
  }
}