import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'generated/data.g.dart'; // this is the generated file

@immutable
@JsonSerializable()
class Lexicon {
  const Lexicon({
    required this.main,
    required this.idioms,
    required this.phrasalVerbs,
    required this.similarWords,
    required this.pos,
  });

  final Iterable<Idiom>? idioms;
  final MainSegment main;
  final Iterable<PhrasalVerb>? phrasalVerbs;
  final String pos;
  final Iterable<SimilarWord>? similarWords;

  factory Lexicon.fromJson(Map<String, dynamic> json) =>
      _$LexiconFromJson(json);

  Map<String, dynamic> toJson() => _$LexiconToJson(this);
}

@immutable
@JsonSerializable()
class Sense {
  const Sense({
    required this.sng,
    required this.definition,
    required this.examples,
  });

  final Definition definition;
  final Iterable<Example>? examples;
  final String? sng;

  factory Sense.fromJson(Map<String, dynamic> json) => _$SenseFromJson(json);

  Map<String, dynamic> toJson() => _$SenseToJson(this);
}

@immutable
@JsonSerializable()
class MainSegment {
  const MainSegment({required this.senses});

  final Iterable<Sense>? senses;

  factory MainSegment.fromJson(Map<String, dynamic> json) =>
      _$MainSegmentFromJson(json);

  Map<String, dynamic> toJson() => _$MainSegmentToJson(this);
}

@immutable
@JsonSerializable()
class Idiom {
  const Idiom({
    required this.senses,
    required this.idiom,
  });

  final String idiom;
  final Iterable<Sense>? senses;

  factory Idiom.fromJson(Map<String, dynamic> json) => _$IdiomFromJson(json);

  Map<String, dynamic> toJson() => _$IdiomToJson(this);
}

@immutable
@JsonSerializable()
class Definition {
  const Definition({
    required this.grammar,
    required this.main,
  });

  final String? grammar;
  final String main;

  factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionToJson(this);
}

@immutable
@JsonSerializable()
class Example {
  const Example({
    required this.boldText,
    required this.regularText,
  });

  final String? boldText;
  final String regularText;

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);

  Map<String, dynamic> toJson() => _$ExampleToJson(this);
}

@immutable
@JsonSerializable()
class PhrasalVerb {
  const PhrasalVerb({
    required this.text,
    required this.link,
  });

  final String link;
  final String text;

  factory PhrasalVerb.fromJson(Map<String, dynamic> json) =>
      _$PhrasalVerbFromJson(json);

  Map<String, dynamic> toJson() => _$PhrasalVerbToJson(this);
}

@immutable
@JsonSerializable()
class SimilarWord {
  const SimilarWord({
    required this.text,
    required this.link,
    required this.pos,
  });

  final String link;
  final String pos;
  final String text;

  factory SimilarWord.fromJson(Map<String, dynamic> json) =>
      _$SimilarWordFromJson(json);

  Map<String, dynamic> toJson() => _$SimilarWordToJson(this);
}
