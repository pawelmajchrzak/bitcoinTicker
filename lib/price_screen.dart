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
  var exchangeRate;
  late int rateUSD = 0;

  @override
  void initState() {
    super.initState();
    getSelectedCurrencyExchangeRate();
  }

  void getSelectedCurrencyExchangeRate() async {
     exchangeRate = await ExchangeModel().getExchangeRate(selectedCurrency);
    // ExchangeModel exchangeModel = ExchangeModel();
    // exchangeModel.getExchangeRate(selectedCurrency);
    updateUI(exchangeRate);
  }

  void updateUI(dynamic exchangeRate) {
    setState(() {
      if (exchangeRate == null) {
        rateUSD = 0;
        return;
      }
      double rateTemporary = exchangeRate['rate'];
      rateUSD = rateTemporary.toInt();
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
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
                  '1 BTC = $rateUSD USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }

}

