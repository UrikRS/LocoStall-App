import 'package:flutter/material.dart';

class ShopDetail extends StatelessWidget {
  const ShopDetail({super.key, required this.shopId});
  final String shopId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            Center(child: Text('Detail of $shopId')),
            TextButton(
              onPressed: () {
                print('buy');
              },
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
