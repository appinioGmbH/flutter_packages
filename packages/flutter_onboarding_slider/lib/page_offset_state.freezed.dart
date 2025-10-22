// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_offset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PageOffsetState {
  double get offset => throw _privateConstructorUsedError;
  double get page => throw _privateConstructorUsedError;

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageOffsetStateCopyWith<PageOffsetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageOffsetStateCopyWith<$Res> {
  factory $PageOffsetStateCopyWith(
          PageOffsetState value, $Res Function(PageOffsetState) then) =
      _$PageOffsetStateCopyWithImpl<$Res, PageOffsetState>;
  @useResult
  $Res call({double offset, double page});
}

/// @nodoc
class _$PageOffsetStateCopyWithImpl<$Res, $Val extends PageOffsetState>
    implements $PageOffsetStateCopyWith<$Res> {
  _$PageOffsetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? page = null,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as double,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageOffsetStateImplCopyWith<$Res>
    implements $PageOffsetStateCopyWith<$Res> {
  factory _$$PageOffsetStateImplCopyWith(_$PageOffsetStateImpl value,
          $Res Function(_$PageOffsetStateImpl) then) =
      __$$PageOffsetStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double offset, double page});
}

/// @nodoc
class __$$PageOffsetStateImplCopyWithImpl<$Res>
    extends _$PageOffsetStateCopyWithImpl<$Res, _$PageOffsetStateImpl>
    implements _$$PageOffsetStateImplCopyWith<$Res> {
  __$$PageOffsetStateImplCopyWithImpl(
      _$PageOffsetStateImpl _value, $Res Function(_$PageOffsetStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? page = null,
  }) {
    return _then(_$PageOffsetStateImpl(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as double,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$PageOffsetStateImpl implements _PageOffsetState {
  const _$PageOffsetStateImpl({this.offset = 0.0, this.page = 0.0});

  @override
  @JsonKey()
  final double offset;
  @override
  @JsonKey()
  final double page;

  @override
  String toString() {
    return 'PageOffsetState(offset: $offset, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageOffsetStateImpl &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(runtimeType, offset, page);

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageOffsetStateImplCopyWith<_$PageOffsetStateImpl> get copyWith =>
      __$$PageOffsetStateImplCopyWithImpl<_$PageOffsetStateImpl>(
          this, _$identity);
}

abstract class _PageOffsetState implements PageOffsetState {
  const factory _PageOffsetState({final double offset, final double page}) =
      _$PageOffsetStateImpl;

  @override
  double get offset;
  @override
  double get page;

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageOffsetStateImplCopyWith<_$PageOffsetStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
