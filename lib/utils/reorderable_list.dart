import 'dart:collection';

class SortableList<T> extends UnmodifiableListView<T> {
  final List<T> _list;

  SortableList(this._list) : super(_list);

  @override
  void sort([Comparator<T>? compare]) {
    _list.sort(compare);
  }
}
