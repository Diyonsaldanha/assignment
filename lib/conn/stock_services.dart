import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task/model/stockmodel.dart';

class StockServices with ChangeNotifier {
  //
  final apikey = '6OG1TNBAYTX6MSS9';
  List<StockDataModel> _suggestedStocks = [];
  final Map<String, String> _stockClosingPrices = {};

  List<StockDataModel> get suggestedStocks => _suggestedStocks;
  Map<String, String> get stockClosingPrices => _stockClosingPrices;

  Future<void> stockInfo(String name) async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$name&interval=5min&apikey=$apikey'));

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        final timeSeriesData =
            parsedData['Time Series (5min)'] as Map<String, dynamic>?;

        if (timeSeriesData != null) {
          final updatedstockprice = timeSeriesData.keys.toList().first;
          final closeValue = timeSeriesData[updatedstockprice]['4. close'];

          _stockClosingPrices[name] = closeValue;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to fetch stock data');
      }
    } catch (e) {
      print('Error fetching stock data: $e');
      throw Exception('Failed to fetch stock data');
    }
  }

  Future<void> stockSuggestion(String keyword) async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$keyword&apikey=$apikey'));

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);

        if (parsedData.containsKey('bestMatches')) {
          final bM = parsedData['bestMatches'] as List<dynamic>?;

          if (bM != null) {
            _suggestedStocks = bM
                .map((stockData) => StockDataModel(
                      s2Name: stockData['2. name'],
                      s1Symbol: stockData['1. symbol'],
                    ))
                .toList();
          }
        }

        notifyListeners();
      } else {
        throw Exception('Failed to fetch stock suggestions');
      }
    } catch (e) {
      print('Error fetching stock suggestions: $e');
    }
  }

  Future<String?> closingStockPrice(String symbol) async {
    try {
      if (_stockClosingPrices.containsKey(symbol)) {
        return _stockClosingPrices[symbol];
      } else {
        await stockInfo(symbol);
        return _stockClosingPrices[symbol];
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
