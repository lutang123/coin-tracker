import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';

//in Dart SDK there is io, we do not need to import as a package
//show is a key word meaning we only need Platform class
//i.e. platform.dart, which is part of dart:io
import 'dart:io' show Platform;

const apiKey = 'use your own key';
const urlFirstPart = 'https://rest.coinapi.io/v1/exchangerate';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      //this function returns a map
      var data = await CoinData().getRate(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

//  {
//  "time": "2017-08-09T14:31:18.3150000Z",
//  "asset_id_base": "BTC",
//  "asset_id_quote": "USD",
//  "rate": 3260.3514321215056208129867667
//  }

  //we have to specify the type for list and it has to be what is expected
  // in the documentation, we can not make it dynamic,
  // otherwise we get 'List<dynamic>' is not a subtype of type
  // 'List<DropdownMenuItem<String>>'
  DropdownButton<String> androidDropdown() {
    //create an empty list first (note: not a null list)
    List<DropdownMenuItem<String>> dropdownItems = [];
    //we have to specify the type for this iterable variable currency,
    // otherwise we get error say currency undefined.
    for (String currency in currenciesList) {
      //for each currency in the list, we add a DropdownMenuItem
      dropdownItems.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }
    //then we will have a list of DropdownMenuItem as required
    // we then use this list dropdownItems to return a DropdownButton<String>
    // return type and function type must be the same
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
      items: dropdownItems,
    );
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      //specify what we want to display in that picker
      //{List<Widget> children}
      //so we have to provide a list with the type of Widget
      children: currenciesList.map<Widget>((String value) {
        return Text(value);
      }).toList(),
    );
  }
//A better way:

//  Column makeCards() {
//    List<CoinCard> cryptoCards = [];
//    for (String crypto in cryptoList) {
//      cryptoCards.add(
//        CryptoCard(
//          cryptoCurrency: crypto,
//          selectedCurrency: selectedCurrency,
//          value: isWaiting ? '?' : coinValues[crypto],
//        ),
//      );
//    }
//  }

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //coinValues is the map we get
              CryptoCard(
                rate: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
                crypto: 'BTC',
              ),
              CryptoCard(
                rate: isWaiting ? '?' : coinValues['ETH'],
                selectedCurrency: selectedCurrency,
                crypto: 'ETH',
              ),
              CryptoCard(
                rate: isWaiting ? '?' : coinValues['LTC'],
                selectedCurrency: selectedCurrency,
                crypto: 'LTC',
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            //when user settled on one of the items, then it's going to trigger the callback, so it will give you the selected index in the picker, and we can use this callback to access what user selected.
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.rate,
    this.selectedCurrency,
    this.crypto,
  });

  final String rate;
  final String selectedCurrency;
  final String crypto;

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
            '1 $crypto = $rate $selectedCurrency',
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
