// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return _Currency.fromJson(json);
}

/// @nodoc
mixin _$Currency {
  String get symbol => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'decimal_digits')
  int get decimalDigits => throw _privateConstructorUsedError;
  double get rounding => throw _privateConstructorUsedError;
  @JsonKey(name: 'iso_code')
  String get isoCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_plural')
  String get namePlural => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_code')
  String get countryCode => throw _privateConstructorUsedError;

  /// Serializes this Currency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyCopyWith<Currency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyCopyWith<$Res> {
  factory $CurrencyCopyWith(Currency value, $Res Function(Currency) then) =
      _$CurrencyCopyWithImpl<$Res, Currency>;
  @useResult
  $Res call(
      {String symbol,
      String name,
      @JsonKey(name: 'decimal_digits') int decimalDigits,
      double rounding,
      @JsonKey(name: 'iso_code') String isoCode,
      @JsonKey(name: 'name_plural') String namePlural,
      String country,
      @JsonKey(name: 'country_code') String countryCode});
}

/// @nodoc
class _$CurrencyCopyWithImpl<$Res, $Val extends Currency>
    implements $CurrencyCopyWith<$Res> {
  _$CurrencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? name = null,
    Object? decimalDigits = null,
    Object? rounding = null,
    Object? isoCode = null,
    Object? namePlural = null,
    Object? country = null,
    Object? countryCode = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      decimalDigits: null == decimalDigits
          ? _value.decimalDigits
          : decimalDigits // ignore: cast_nullable_to_non_nullable
              as int,
      rounding: null == rounding
          ? _value.rounding
          : rounding // ignore: cast_nullable_to_non_nullable
              as double,
      isoCode: null == isoCode
          ? _value.isoCode
          : isoCode // ignore: cast_nullable_to_non_nullable
              as String,
      namePlural: null == namePlural
          ? _value.namePlural
          : namePlural // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyImplCopyWith<$Res>
    implements $CurrencyCopyWith<$Res> {
  factory _$$CurrencyImplCopyWith(
          _$CurrencyImpl value, $Res Function(_$CurrencyImpl) then) =
      __$$CurrencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String symbol,
      String name,
      @JsonKey(name: 'decimal_digits') int decimalDigits,
      double rounding,
      @JsonKey(name: 'iso_code') String isoCode,
      @JsonKey(name: 'name_plural') String namePlural,
      String country,
      @JsonKey(name: 'country_code') String countryCode});
}

/// @nodoc
class __$$CurrencyImplCopyWithImpl<$Res>
    extends _$CurrencyCopyWithImpl<$Res, _$CurrencyImpl>
    implements _$$CurrencyImplCopyWith<$Res> {
  __$$CurrencyImplCopyWithImpl(
      _$CurrencyImpl _value, $Res Function(_$CurrencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? name = null,
    Object? decimalDigits = null,
    Object? rounding = null,
    Object? isoCode = null,
    Object? namePlural = null,
    Object? country = null,
    Object? countryCode = null,
  }) {
    return _then(_$CurrencyImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      decimalDigits: null == decimalDigits
          ? _value.decimalDigits
          : decimalDigits // ignore: cast_nullable_to_non_nullable
              as int,
      rounding: null == rounding
          ? _value.rounding
          : rounding // ignore: cast_nullable_to_non_nullable
              as double,
      isoCode: null == isoCode
          ? _value.isoCode
          : isoCode // ignore: cast_nullable_to_non_nullable
              as String,
      namePlural: null == namePlural
          ? _value.namePlural
          : namePlural // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyImpl implements _Currency {
  const _$CurrencyImpl(
      {required this.symbol,
      required this.name,
      @JsonKey(name: 'decimal_digits') required this.decimalDigits,
      required this.rounding,
      @JsonKey(name: 'iso_code') required this.isoCode,
      @JsonKey(name: 'name_plural') required this.namePlural,
      required this.country,
      @JsonKey(name: 'country_code') required this.countryCode});

  factory _$CurrencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyImplFromJson(json);

  @override
  final String symbol;
  @override
  final String name;
  @override
  @JsonKey(name: 'decimal_digits')
  final int decimalDigits;
  @override
  final double rounding;
  @override
  @JsonKey(name: 'iso_code')
  final String isoCode;
  @override
  @JsonKey(name: 'name_plural')
  final String namePlural;
  @override
  final String country;
  @override
  @JsonKey(name: 'country_code')
  final String countryCode;

  @override
  String toString() {
    return 'Currency(symbol: $symbol, name: $name, decimalDigits: $decimalDigits, rounding: $rounding, isoCode: $isoCode, namePlural: $namePlural, country: $country, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.decimalDigits, decimalDigits) ||
                other.decimalDigits == decimalDigits) &&
            (identical(other.rounding, rounding) ||
                other.rounding == rounding) &&
            (identical(other.isoCode, isoCode) || other.isoCode == isoCode) &&
            (identical(other.namePlural, namePlural) ||
                other.namePlural == namePlural) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, name, decimalDigits,
      rounding, isoCode, namePlural, country, countryCode);

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      __$$CurrencyImplCopyWithImpl<_$CurrencyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyImplToJson(
      this,
    );
  }
}

abstract class _Currency implements Currency {
  const factory _Currency(
          {required final String symbol,
          required final String name,
          @JsonKey(name: 'decimal_digits') required final int decimalDigits,
          required final double rounding,
          @JsonKey(name: 'iso_code') required final String isoCode,
          @JsonKey(name: 'name_plural') required final String namePlural,
          required final String country,
          @JsonKey(name: 'country_code') required final String countryCode}) =
      _$CurrencyImpl;

  factory _Currency.fromJson(Map<String, dynamic> json) =
      _$CurrencyImpl.fromJson;

  @override
  String get symbol;
  @override
  String get name;
  @override
  @JsonKey(name: 'decimal_digits')
  int get decimalDigits;
  @override
  double get rounding;
  @override
  @JsonKey(name: 'iso_code')
  String get isoCode;
  @override
  @JsonKey(name: 'name_plural')
  String get namePlural;
  @override
  String get country;
  @override
  @JsonKey(name: 'country_code')
  String get countryCode;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
