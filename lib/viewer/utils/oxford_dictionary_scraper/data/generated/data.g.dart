// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lexicon _$LexiconFromJson(Map<String, dynamic> json) => Lexicon(
      word: json['word'] as String,
      main: MainSegment.fromJson(json['main'] as Map<String, dynamic>),
      idioms: (json['idioms'] as List<dynamic>)
          .map((e) => Idiom.fromJson(e as Map<String, dynamic>))
          .toList(),
      phrasalVerbs: (json['phrasalVerbs'] as List<dynamic>)
          .map((e) => PhrasalVerb.fromJson(e as Map<String, dynamic>))
          .toList(),
      similarWords: (json['similarWords'] as List<dynamic>)
          .map((e) => SimilarWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      pos: json['pos'] as String,
    );

Map<String, dynamic> _$LexiconToJson(Lexicon instance) => <String, dynamic>{
      'idioms': instance.idioms.toList(),
      'main': instance.main,
      'phrasalVerbs': instance.phrasalVerbs.toList(),
      'pos': instance.pos,
      'similarWords': instance.similarWords.toList(),
    };

Sense _$SenseFromJson(Map<String, dynamic> json) => Sense(
      sng: json['sng'] as String?,
      definition:
          Definition.fromJson(json['definition'] as Map<String, dynamic>),
      examples: (json['examples'] as List<dynamic>?)
          ?.map((e) => Example.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SenseToJson(Sense instance) => <String, dynamic>{
      'definition': instance.definition,
      'examples': instance.examples?.toList(),
      'sng': instance.sng,
    };

MainSegment _$MainSegmentFromJson(Map<String, dynamic> json) => MainSegment(
      senses: (json['senses'] as List<dynamic>)
          .map((e) => Sense.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MainSegmentToJson(MainSegment instance) =>
    <String, dynamic>{
      'senses': instance.senses.toList(),
    };

Idiom _$IdiomFromJson(Map<String, dynamic> json) => Idiom(
      senses: (json['senses'] as List<dynamic>?)
          ?.map((e) => Sense.fromJson(e as Map<String, dynamic>))
          .toList(),
      idiom: json['idiom'] as String,
    );

Map<String, dynamic> _$IdiomToJson(Idiom instance) => <String, dynamic>{
      'idiom': instance.idiom,
      'senses': instance.senses?.toList(),
    };

Definition _$DefinitionFromJson(Map<String, dynamic> json) => Definition(
      grammar: json['grammar'] as String?,
      main: json['main'] as String,
    );

Map<String, dynamic> _$DefinitionToJson(Definition instance) =>
    <String, dynamic>{
      'grammar': instance.grammar,
      'main': instance.main,
    };

Example _$ExampleFromJson(Map<String, dynamic> json) => Example(
      boldText: json['boldText'] as String?,
      regularText: json['regularText'] as String,
    );

Map<String, dynamic> _$ExampleToJson(Example instance) => <String, dynamic>{
      'boldText': instance.boldText,
      'regularText': instance.regularText,
    };

PhrasalVerb _$PhrasalVerbFromJson(Map<String, dynamic> json) => PhrasalVerb(
      text: json['text'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$PhrasalVerbToJson(PhrasalVerb instance) =>
    <String, dynamic>{
      'link': instance.link,
      'text': instance.text,
    };

SimilarWord _$SimilarWordFromJson(Map<String, dynamic> json) => SimilarWord(
      text: json['text'] as String,
      link: json['link'] as String,
      pos: json['pos'] as String,
    );

Map<String, dynamic> _$SimilarWordToJson(SimilarWord instance) =>
    <String, dynamic>{
      'link': instance.link,
      'pos': instance.pos,
      'text': instance.text,
    };
