import 'dart:convert';

import 'package:flutterhttpcommunication/http/webclient.dart';
import 'package:flutterhttpcommunication/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 5));
    final List<dynamic> decodeJson = jsonDecode(response.body);
    return decodeJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-type': 'application/json',
        'password': password,
      },
      body: transactionJson,
    );

    if (response.statusCode == 400) {
      throw Exception('there was an error submitting transaction');
    }

    if (response.statusCode == 401) {
      throw Exception('authentication failed');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
