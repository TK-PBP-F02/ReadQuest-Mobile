import 'package:flutter/material.dart';
import 'package:readquest/models/book.dart';
import 'package:readquest/models/Inventory.dart';
import 'package:readquest/models/InventoryBook.dart';

class BookDetailPage extends StatelessWidget {
  final Books book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CachedNetworkImage(
            //       placeholder: (context, url) => const CircularProgressIndicator(),
            //       imageUrl: Uri.encodeFull('${snapshot.data![index].fields.imageUrl}'),
            //       errorWidget: (context, url, error) => Icon(Icons.error),
                  
            //       httpHeaders: const {
            //         "Access-Control-Allow-Origin": "*",
            //       },
            //     ),
            Text(
              book.fields.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('Author: ${book.fields.author}'),
            const SizedBox(height: 10),
            Text('Description: ${book.fields.description}'),
            
          ],
        ),
      ),
    );
  }
}
