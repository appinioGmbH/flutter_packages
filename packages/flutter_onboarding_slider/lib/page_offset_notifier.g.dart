// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_offset_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PageOffsetNotifier)
const pageOffsetProvider = PageOffsetNotifierFamily._();

final class PageOffsetNotifierProvider
    extends $NotifierProvider<PageOffsetNotifier, PageOffsetState> {
  const PageOffsetNotifierProvider._(
      {required PageOffsetNotifierFamily super.from,
      required PageController super.argument})
      : super(
          retry: null,
          name: r'pageOffsetProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pageOffsetNotifierHash();

  @override
  String toString() {
    return r'pageOffsetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PageOffsetNotifier create() => PageOffsetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PageOffsetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PageOffsetState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PageOffsetNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pageOffsetNotifierHash() =>
    r'bc3dccd56f99e687707efe2a1205be0b8c260fbb';

final class PageOffsetNotifierFamily extends $Family
    with
        $ClassFamilyOverride<PageOffsetNotifier, PageOffsetState,
            PageOffsetState, PageOffsetState, PageController> {
  const PageOffsetNotifierFamily._()
      : super(
          retry: null,
          name: r'pageOffsetProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PageOffsetNotifierProvider call(
    PageController controller,
  ) =>
      PageOffsetNotifierProvider._(argument: controller, from: this);

  @override
  String toString() => r'pageOffsetProvider';
}

abstract class _$PageOffsetNotifier extends $Notifier<PageOffsetState> {
  late final _$args = ref.$arg as PageController;
  PageController get controller => _$args;

  PageOffsetState build(
    PageController controller,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<PageOffsetState, PageOffsetState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PageOffsetState, PageOffsetState>,
        PageOffsetState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
