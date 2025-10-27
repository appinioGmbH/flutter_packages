// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_offset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageOffsetState {
  double get offset;
  double get page;

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PageOffsetStateCopyWith<PageOffsetState> get copyWith =>
      _$PageOffsetStateCopyWithImpl<PageOffsetState>(
          this as PageOffsetState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PageOffsetState &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(runtimeType, offset, page);

  @override
  String toString() {
    return 'PageOffsetState(offset: $offset, page: $page)';
  }
}

/// @nodoc
abstract mixin class $PageOffsetStateCopyWith<$Res> {
  factory $PageOffsetStateCopyWith(
          PageOffsetState value, $Res Function(PageOffsetState) _then) =
      _$PageOffsetStateCopyWithImpl;
  @useResult
  $Res call({double offset, double page});
}

/// @nodoc
class _$PageOffsetStateCopyWithImpl<$Res>
    implements $PageOffsetStateCopyWith<$Res> {
  _$PageOffsetStateCopyWithImpl(this._self, this._then);

  final PageOffsetState _self;
  final $Res Function(PageOffsetState) _then;

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? page = null,
  }) {
    return _then(_self.copyWith(
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as double,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [PageOffsetState].
extension PageOffsetStatePatterns on PageOffsetState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PageOffsetState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PageOffsetState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PageOffsetState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageOffsetState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PageOffsetState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageOffsetState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(double offset, double page)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PageOffsetState() when $default != null:
        return $default(_that.offset, _that.page);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(double offset, double page) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageOffsetState():
        return $default(_that.offset, _that.page);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(double offset, double page)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageOffsetState() when $default != null:
        return $default(_that.offset, _that.page);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PageOffsetState implements PageOffsetState {
  const _PageOffsetState({this.offset = 0.0, this.page = 0.0});

  @override
  @JsonKey()
  final double offset;
  @override
  @JsonKey()
  final double page;

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PageOffsetStateCopyWith<_PageOffsetState> get copyWith =>
      __$PageOffsetStateCopyWithImpl<_PageOffsetState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PageOffsetState &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(runtimeType, offset, page);

  @override
  String toString() {
    return 'PageOffsetState(offset: $offset, page: $page)';
  }
}

/// @nodoc
abstract mixin class _$PageOffsetStateCopyWith<$Res>
    implements $PageOffsetStateCopyWith<$Res> {
  factory _$PageOffsetStateCopyWith(
          _PageOffsetState value, $Res Function(_PageOffsetState) _then) =
      __$PageOffsetStateCopyWithImpl;
  @override
  @useResult
  $Res call({double offset, double page});
}

/// @nodoc
class __$PageOffsetStateCopyWithImpl<$Res>
    implements _$PageOffsetStateCopyWith<$Res> {
  __$PageOffsetStateCopyWithImpl(this._self, this._then);

  final _PageOffsetState _self;
  final $Res Function(_PageOffsetState) _then;

  /// Create a copy of PageOffsetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? offset = null,
    Object? page = null,
  }) {
    return _then(_PageOffsetState(
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as double,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
