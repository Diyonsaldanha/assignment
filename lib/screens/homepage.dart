import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:task/conn/stock_services.dart';
import 'package:task/model/hivemodel.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  late final Box dataBox;

  @override
  void initState() {
    super.initState();
    dataBox = Hive.box('data_box');
  }

  createData(
      {required String sid, required String sname, required String sprice}) {
    HiveModel newHiveData = HiveModel(
      sid: sid,
      sname: sname,
      sprice: sprice,
    );

    dataBox.add(newHiveData);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TradeBrains'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  hintText: 'Search stock data',
                ),
                onChanged: (text) {
                  Provider.of<StockServices>(context, listen: false)
                      .stockSuggestion(text);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Consumer<StockServices>(
              builder: (context, stockProvider, _) {
                final suggestedStocks = stockProvider.suggestedStocks;
                if (textController.text.isEmpty) {
                  return Container();
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: suggestedStocks.length,
                      itemBuilder: (context, index) {
                        final stock = suggestedStocks[index];
                        if (suggestedStocks[index].toString().isEmpty) {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              title: Text(
                                stock.s1Symbol,
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: FutureBuilder(
                                future: stockProvider
                                    .closingStockPrice(stock.s1Symbol),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox.shrink();
                                  } else if (snapshot.hasError) {
                                    return const Text('Data not found');
                                  } else {
                                    final stockPrice =
                                        snapshot.data ?? 'Data not found';

                                    return Text(
                                      "price : $stockPrice",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    );
                                  }
                                },
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  createData(
                                    sid: stock.s1Symbol,
                                    sname: stock.s2Name,
                                    sprice: "",
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
