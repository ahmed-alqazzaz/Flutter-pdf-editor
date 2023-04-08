import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/utils/oxford_dictionary_scraper/exceptions.dart';
import 'package:pdf_editor/viewer/utils/oxford_dictionary_scraper/helpers/popular_user_agents.dart';

@immutable
class OxfordDictionaryApiClient {
  OxfordDictionaryApiClient({
    required HttpClient client,
    required String userAgent,
  }) : client = client
          ..connectionTimeout = _connectionTimeout
          ..maxConnectionsPerHost = _maxConnectionsPerHost
          ..userAgent = userAgent;

  // Factory constructor to create an instance of OxfordDictionaryApiClient
  // with a random user agent
  factory OxfordDictionaryApiClient.withRandomAgent(HttpClient client) {
    return OxfordDictionaryApiClient(
      client: client,
      userAgent: _randomUserAgent,
    );
  }

  final HttpClient client;

  static const Duration _connectionTimeout = Duration(seconds: 5);
  static const int _maxConnectionsPerHost = 10;
  // Base URL for the Oxford Dictionary API
  static const String _oxfordDictionaryUrl =
      "https://www.oxfordlearnersdictionaries.com/definition/english/";

  Future<String?> fetchWord(final String word) async {
    try {
      final uri = Uri.parse(_oxfordDictionaryUrl + word);

      // Use client.getUrl() to create a GET request with the constructed URL
      final request = await client.openUrl("GET", uri);
      final response = await request.close();

      // If response has a 200 status code, return the response body
      if (response.statusCode == 200) {
        return await response.transform(utf8.decoder).join();
      }
      return null;
    } on HttpException {
      throw const OxfordDictionaryBlockedRequestException();
    } on SocketException {
      throw const WordLoadingException();
    } catch (_) {
      throw const OxfordDictionaryScraperUnknownException();
    }
  }

  // Get a random user agent from the list of popular user agents
  static String get _randomUserAgent => popularUserAgents.elementAt(
        Random().nextInt(popularUserAgents.length),
      );
}
