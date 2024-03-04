import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = 'CFA92D27-EE0F-424B-A833-71F709D4BD26';
const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class ExchangeModel {

  Future<dynamic> getExchangeRate(String currency) async {

    var url = Uri.parse('$coinApiUrl/BTC/USD?apikey=$apiKey');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }




    // NetworkHelper networkHelper = NetworkHelper('$openWeatherMapUrl?q=$cityName&appid=$apiKey&units=metric');
    // var weatherData = await networkHelper.getData();
    // return weatherData;
  }


}