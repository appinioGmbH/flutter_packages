// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_offset_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pageOffsetNotifierHash() =>
    r'bc3dccd56f99e687707efe2a1205be0b8c260fbb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PageOffsetNotifier
    extends BuildlessAutoDisposeNotifier<PageOffsetState> {
  late final PageController controller;

  PageOffsetState build(
    PageController controller,
  );
}

/// See also [PageOffsetNotifier].
@ProviderFor(PageOffsetNotifier)
const pageOffsetNotifierProvider = PageOffsetNotifierFamily();

/// See also [PageOffsetNotifier].
class PageOffsetNotifierFamily extends Family<PageOffsetState> {
  /// See also [PageOffsetNotifier].
  const PageOffsetNotifierFamily();

  /// See also [PageOffsetNotifier].
  PageOffsetNotifierProvider call(
    PageController controller,
  ) {
    return PageOffsetNotifierProvider(
      controller,
    );
  }

  @override
  PageOffsetNotifierProvider getProviderOverride(
    covariant PageOffsetNotifierProvider provider,
  ) {
    return call(
      provider.controller,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pageOffsetNotifierProvider';
}

/// See also [PageOffsetNotifier].
class PageOffsetNotifierProvider extends AutoDisposeNotifierProviderImpl<
    PageOffsetNotifier, PageOffsetState> {
  /// See also [PageOffsetNotifier].
  PageOffsetNotifierProvider(
    PageController controller,
  ) : this._internal(
          () => PageOffsetNotifier()..controller = controller,
          from: pageOffsetNotifierProvider,
          name: r'pageOffsetNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pageOffsetNotifierHash,
          dependencies: PageOffsetNotifierFamily._dependencies,
          allTransitiveDependencies:
              PageOffsetNotifierFamily._allTransitiveDependencies,
          controller: controller,
        );

  PageOffsetNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.controller,
  }) : super.internal();

  final PageController controller;

  @override
  PageOffsetState runNotifierBuild(
    covariant PageOffsetNotifier notifier,
  ) {
    return notifier.build(
      controller,
    );
  }

  @override
  Override overrideWith(PageOffsetNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PageOffsetNotifierProvider._internal(
        () => create()..controller = controller,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        controller: controller,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PageOffsetNotifier, PageOffsetState>
      createElement() {
    return _PageOffsetNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PageOffsetNotifierProvider &&
        other.controller == controller;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, controller.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PageOffsetNotifierRef on AutoDisposeNotifierProviderRef<PageOffsetState> {
  /// The parameter `controller` of this provider.
  PageController get controller;
}

class _PageOffsetNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<PageOffsetNotifier,
        PageOffsetState> with PageOffsetNotifierRef {
  _PageOffsetNotifierProviderElement(super.provider);

  @override
  PageController get controller =>
      (origin as PageOffsetNotifierProvider).controller;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
