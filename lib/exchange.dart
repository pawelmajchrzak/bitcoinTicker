import 'dart:convert';
import 'package:http/http.dart' as http;
import 'coin_data.dart';
import 'config.dart';

const String apiKey = Config.apiKey;
const String coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class ExchangeModel {

  Future<List<dynamic>> getExchangeRate(String currency) async {
    List<dynamic> exchangeRates = [];
    for (String cryptoCoin in cryptoList) {
      var url = Uri.parse('$coinApiUrl/$cryptoCoin/$currency?apikey=$apiKey');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        exchangeRates.add(jsonDecode(data));
      } else {
        print(response.statusCode);
      }
    }
    return exchangeRates;
    // NetworkHelper networkHelper = NetworkHelper('$openWeatherMapUrl?q=$cityName&appid=$apiKey&units=metric');
    // var weatherData = await networkHelper.getData();
    // return weatherData;
  }


}