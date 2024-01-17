enum UserLabel {
  user0('戸松さん'),
  user1('吉田さん'),
  user2('岡本さん'),
  user3('秋谷さん'),
  user4('前田さん');

  const UserLabel(this.label);
  final String label;
}


List<String> simpleUserNameList = [
  "吉田和徳",
  "加藤恭子",
  "尾池みどり",
  "前田美紀子",
  "河西富士子",
  "松田薫",
  "佐々木純子",
  "樋口眞美",
  "絹本啓子",
  "檜山真悠子",
  "檜山高寛",
  "小川敦",
  "松本誠也",
  "井内和美",
  "秋谷佳汰",
  "戸松和也",
  "佐野真由美",
  "岡本陽斗",
  "佐藤尚貴",
  "里谷裕貴",
  "高橋正子",
  "真田珠青",
  "石田和久",
  "大下照美",
  "大木幸子",
];




enum TimeLabel {
  startTime,
  endTime, selectTime,
}

enum OpenFormPageMode {
  add,
  edit,
}

enum TimeSelectButtonMode {
  startTimeMode,
  endTimeMode,
}


enum PageType {
  Report,
  Calender,
  Settings
}

