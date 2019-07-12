/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
/// dynamicToString
List<String>  listOfDToS(List<dynamic> dynamicList){
  return  dynamicList.map((json){
    return json.toString();
  }).toList();
}


