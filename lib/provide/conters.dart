import 'package:flutter/material.dart';

class Conter with ChangeNotifier {
   int v = 0;

   increment(){
     v ++ ;
     notifyListeners();
   }


}
