import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task/conn/stock_services.dart';

class WatchList extends StatefulWidget {
  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  late final Box dataBox;

  @override
  void initState() {
    super.initState();
    dataBox = Hive.box('data_box');
  }

  deleteData(int index) {
    dataBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final s_services = Provider.of<StockServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: ValueListenableBuilder(
        valueListenable: dataBox.listenable(),
        builder: (context, value, child) {
          if (value.isEmpty) {
            return const Center(
              child: Text('Database is empty'),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: dataBox.length,
              itemBuilder: (context, index) {
                var box = value;
                var getHiveData = box.getAt(index);

                return ListTile(
                  title: Text(
                    getHiveData.sname,
                  ),
                  subtitle: FutureBuilder(
                    future: s_services.closingStockPrice(getHiveData.sid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        return const Text('Data not found');
                      } else {
                        final stockPrice = snapshot.data ?? 'Data not found';

                        return Text(
                          "price : $stockPrice",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
                        );
                      }
                    },
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      deleteData(index);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
