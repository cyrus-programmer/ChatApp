class EncryptDecrypt {
  String key = "shaiq";

  String encrypt(String text) {
    String fullKey = '', result = '';
    key = key.toUpperCase();
    text = text.toUpperCase();

    for (var i = 0; i < key.length; i++)
      if (fullKey.contains(key[i]) == false && key[i] != ' ') fullKey += key[i];

    for (var i = 'A'.codeUnitAt(0); i <= 'Z'.codeUnitAt(0); i++)
      if (fullKey.contains(String.fromCharCode(i)) == false)
        fullKey += String.fromCharCode(i);

    for (var i = 0; i < text.length; i++) {
      if (text[i] == ' ')
        result += ' ';
      else
        result += fullKey[text[i].codeUnitAt(0) - 65];
    }

    return result;
  }

  String decrypt(String text) {
    String fullKey = '', result = '';
    key = key.toUpperCase();
    text = text.toUpperCase();

    for (var i = 0; i < key.length; i++)
      if (fullKey.contains(key[i]) == false &&
          key[i] != ' ' &&
          key[i].codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
          key[i].codeUnitAt(0) <= 'Z'.codeUnitAt(0)) fullKey += key[i];

    for (var i = 'A'.codeUnitAt(0); i <= 'Z'.codeUnitAt(0); i++)
      if (fullKey.contains(String.fromCharCode(i)) == false)
        fullKey += String.fromCharCode(i);

    for (var i = 0; i < text.length; i++) {
      if (text[i] == ' ')
        result += ' ';
      else {
        result +=
            String.fromCharCode(fullKey.indexOf(text[i]) + 'A'.codeUnitAt(0));
      }
    }

    return result;
  }
}
