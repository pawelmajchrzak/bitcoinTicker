import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

import 'exchange.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  late int rateBTC = 0;
  late int rateETH = 0;
  late int rateLTC = 0;

  @override
  void initState() {
    super.initState();
    getSelectedCurrencyExchangeRate();
  }

  void getSelectedCurrencyExchangeRate() async {
    try {
      List<dynamic>exchangeRate = await ExchangeModel().getExchangeRate(selectedCurrency);
      updateUI(exchangeRate);
    } catch (e) {
      print(e);
    }

  }

  void updateUI(dynamic exchangeRate) {
    setState(() {
      if (exchangeRate == null) {
        rateBTC = 0;
        return;
      }
      double rateTemporary = exchangeRate[0]['rate'];
      rateBTC = rateTemporary.toInt();
      rateTemporary = exchangeRate[1]['rate'];
      rateETH = rateTemporary.toInt();
      rateTemporary = exchangeRate[2]['rate'];
      rateLTC = rateTemporary.toInt();
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getSelectedCurrencyExchangeRate();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        selectedCurrency = currenciesList[selectedIndex];
        getSelectedCurrencyExchangeRate();
      },
      children: pickerItems,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RateForSingleCrypto(rate: rateBTC, selectedCurrency: selectedCurrency, cryptoCurrency: 'BTC'),
          RateForSingleCrypto(rate: rateETH, selectedCurrency: selectedCurrency, cryptoCurrency: 'ETH'),
          RateForSingleCrypto(rate: rateLTC, selectedCurrency: selectedCurrency, cryptoCurrency: 'LTC'),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS ? iOSPicker() : androidDropdown(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class RateForSingleCrypto extends StatelessWidget {
  const RateForSingleCrypto({
    super.key,
    required this.rate,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final int rate;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

