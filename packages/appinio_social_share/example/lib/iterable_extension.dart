import 'dart:core';

extension IterableExtension<E> on Iterable<E> {
  List<T> mapWhere<T>(T Function(E e) f, bool Function(E e) test) {
    List<T> result = [];
    forEach((element) {
      if (test(element)) result.add(f(element));
    });
    return result;
  }
}
