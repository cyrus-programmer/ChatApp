import 'dart:math';
import 'dart:convert';
import 'package:convert/convert.dart';

randKey(p) {
  String key1 = "";
  p = int.parse(p);
  for (int i = 0; i < p; i++) {
    var temp = 0 + Random().nextInt(1 - 0);
    var temp1 = temp.toString();
    key1 += temp1;
  }
  return key1;
}

exor(a, b, n) {
  String temp = "";

  for (int i = 0; i < n; i++) {
    if (a[i] == b[i]) {
      temp += "0";
    } else {
      temp += "1";
    }
  }
  return temp;
}

binaryToDecimal(binary) {
  var str = int.parse(binary, radix: 2);
  return str;
}

encryption(String message) {
  List ascii = [];
  for (int i = 0; i < message.length; i++) {
    var a = message.codeUnitAt(i);
    ascii.add(a);
  }
  List binaryList = [];
  for (int i = 0; i < ascii.length; i++) {
    var a = ascii[i].toRadixString(2);
    var b = a.toString();
    if (b.length != 8) {
      var c = "0" * (8 - b.length);
      a = c + a;
    }
    binaryList.add(a);
  }
  String binaryString = binaryList.join();
  int n = (binaryString.length / 2).round();
  String L1 = binaryString.substring(0, n);
  String R1 = binaryString.substring(n);

  int m = R1.length;

//Generate Key K1 for the
//first round
  int K1 = randKey(m);

//Generate Key K2 for the
//second round
  int K2 = randKey(m);

//first round of Feistel
  String f1 = exor(R1, K1, n);
  String R2 = exor(f1, L1, n);
  String L2 = R1;
  // Second round of Feistel
  String f2 = exor(R2, K2, n);
  String R3 = exor(f2, L2, n);
  String L3 = R2;

  String bin_data = L3 + R3;
  String str_data = ' ';

  for (int i = 0; i < bin_data.length; i += 7) {
    String temp_data = bin_data.substring(i, i + 7);
    var decimal_data = binaryToDecimal(temp_data);
    str_data = str_data + String.fromCharCode(decimal_data);
  }
  return [L3, R3, n, K1, K2];
}

decrypt(
    String encryptedData1, String encryptedData2, String K2, int n, String K1) {
  String L4 = encryptedData1;
  String R4 = encryptedData2;

  String f3 = exor(L4, K2, n);
  String L5 = exor(R4, f3, n);
  String R5 = L4;

  String f4 = exor(L5, K1, n);
  String L6 = exor(R5, f4, n);
  String R6 = L5;
  String PT1 = L6 + R6;

  var PT2 = int.parse(PT1, radix: 2);
  var RPT = hex.decode(PT2.toString());
  return RPT;
}
