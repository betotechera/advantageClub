class Result<T> {
  final List<T> items;
  bool hasNext = false;
  final int total;
  Result(this.items, this.total);

  void setHasNext(List<dynamic> jsonList) => hasNext = jsonList.any((element) => element['rel'] == 'next');


  Result.fromJson(Map<String, dynamic> jsonList, this.items) : total = 0;
}
