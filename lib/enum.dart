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
  "佐藤 真美",
  "鈴木 太郎",
  "高橋 みさき",
  "田中 健太",
  "渡辺 美香",
  "伊藤 貴子",
  "山本 勇介",
  "中村 さやか",
  "小林 大輝",
  "加藤 みゆき",
  "山田 裕太",
  "斎藤 千佳",
  "木村 健司",
  "井上 あやこ",
  "山口 大樹",
  "小川 まどか",
  "加藤 聡太",
  "鈴木 由美",
  "高橋 明美",
  "田村 啓介",
  "中島 美咲",
  "小野 誠",
  "藤本 知子",
  "菊地 貴之",
  "川田 美希",
];

enum TimeLabel {
  startTime,
  endTime,
  selectTime,
}

enum OpenFormPageMode {
  add,
  edit,
}

enum TimeSelectButtonMode {
  startTimeMode,
  endTimeMode,
}

enum PageType { Report, Calender, Settings }
