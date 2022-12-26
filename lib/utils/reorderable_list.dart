import 'dart:collection';

class ReorderableListView<T> extends UnmodifiableListView<T> {
  final List<T> _list;

  ReorderableListView(this._list) : super(_list);

  @override
  void sort([Comparator<T>? compare]) {
    _list.sort(compare);
  }
}
