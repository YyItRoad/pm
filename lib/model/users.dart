class Users {
  //登录积分
  int loginScore;
  //广告积分
  int adScore;
  //奖励积分
  int awardScore;

  /// {
  ///    10020190711 : [2323,343423,12323]
  ///    10020190714 : [2343,345423,13323]
  /// }
  Map<String, List<int>> phases;

  ///  {
  ///    10020190711 : { index: 2, award: 10 }
  ///    10020190713 : { index: 1, award: 50 }
  ///  }
  Map<String, Map> awards;

  @override
  String toString() {
    return '';
  }
}
