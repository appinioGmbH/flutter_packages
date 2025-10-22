import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_offset_state.freezed.dart';

@freezed
abstract class PageOffsetState with _$PageOffsetState {
  const factory PageOffsetState({
    @Default(0.0) double offset,
    @Default(0.0) double page,
  }) = _PageOffsetState;
}
