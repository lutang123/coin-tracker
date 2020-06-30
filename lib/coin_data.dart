import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = 'use your own key';
const urlFirstPart = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future getRate(currency) async {
    Map<String, String> cryptoMap = {};
    for (String crypto in cryptoList) {
      http.Response response = await http.get(
          //before user select, this is USD
          '$urlFirstPart/$crypto/$currency',
          headers: {'X-CoinAPI-Key': apiKey});
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        cryptoMap[crypto] = jsonData['rate'].toStringAsFixed(2);
        return cryptoMap;
      } else {
        print(response.statusCode);
        throw Exception('Failed to load album');
      }
    }
  }
}
