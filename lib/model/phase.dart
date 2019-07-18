class Phase {
  ///每期ID
  int id;

  ///每期主题
  String name;

  ///图片数据
  List images;

  ///点赞数据
  ///{
  ///  122321: [123,2323,42323,43434]
  ///}
  Map<String, List<int>> zans;
}
