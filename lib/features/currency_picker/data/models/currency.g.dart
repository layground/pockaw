// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencyImpl _$$CurrencyImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyImpl(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      decimalDigits: (json['decimal_digits'] as num).toInt(),
      rounding: (json['rounding'] as num).toDouble(),
      isoCode: json['iso_code'] as String,
      namePlural: json['name_plural'] as String,
      country: json['country'] as String,
      countryCode: json['country_code'] as String,
    );

Map<String, dynamic> _$$CurrencyImplToJson(_$CurrencyImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'decimal_digits': instance.decimalDigits,
      'rounding': instance.rounding,
      'iso_code': instance.isoCode,
      'name_plural': instance.namePlural,
      'country': instance.country,
      'country_code': instance.countryCode,
    };
