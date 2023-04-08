import 'package:flutter/cupertino.dart';

@immutable
class WordUnavailableException implements Exception {
  const WordUnavailableException();
}

@immutable
class WordLoadingException implements Exception {
  const WordLoadingException();
}

@immutable
class OxfordDictionaryScraperUnknownException implements Exception {
  const OxfordDictionaryScraperUnknownException();
}

@immutable
class OxfordDictionaryBlockedRequestException {
  const OxfordDictionaryBlockedRequestException();
}
