/*
 * map 与 url参数转换
 */
class MapUrlParamsUtils {
  /*
   * 将url参数转换成map
   *
   * @param param aa=11&bb=22&cc=33
   * @return
   */
  static Map<String, Object> getUrlParams(String param) {
    Map<String, Object> map = new Map<String, Object>();
    if (param == null || param.length == 0) {
      return map;
    }
    List params = param.split("&");
    for (int i = 0; i < params.length; i++) {
      List p = params[i].split("=");
      if (p.length == 2) {
        map[p[0]] = p[1];
      }
    }
    return map;
  }

  /*
   * 将map转换成url
   *
   * @param map
   * @return
   */
  static String getUrlParamsByMap(Map<String, Object> maps) {
    if (maps == null) {
      return "";
    }
    StringBuffer sb = new StringBuffer();

    maps.forEach((key, value) {

        sb.write(key + "=" + value.toString());
        sb.write("&");

    });
    String s = sb.toString();
    if(s.length != 0){
      s = s.substring(0,s.length-1);
    }

    return s;
  }
}
