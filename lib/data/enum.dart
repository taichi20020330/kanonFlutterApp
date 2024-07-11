enum UserLabel {
  user0('里谷さん'),
  user1('岡本さん'),
  user2('戸松さん'),
  user3('植村さん'),
  user4('大下さん'),
  user5('佐々木さん'),
  user6('石田さん'),
  user7('大木さん'),
  user8('冨坂さん'),
  user9('テスト9'),
  user10('テスト10'),
  user11('テスト11'),
  user12('テスト12'),
  user13('テスト13'),
  user14('テスト14'),
  user15('テスト15'),
  user16('テスト16'),
  user17('テスト17'),
  user18('テスト18'),
  user19('テスト19'),
  user20('テスト20');

  const UserLabel(this.label);
  final String label;
}


// List<String> simpleUserNameList = [
//   "佐藤真美",
//   "鈴木太郎",
//   "高橋みさき",
//   "田中健太",
//   "渡辺美香",
//   "伊藤貴子",
//   "山本勇介",
//   "中村さやか",
//   "小林大輝",
//   "加藤みゆき",
//   "山田裕太",
//   "斎藤千佳",
//   "木村健司",
//   "井上あやこ",
//   "山口大樹",
//   "小川まどか",
//   "加藤聡太",
//   "鈴木由美",
//   "高橋明美",
//   "田村啓介",
//   "中島美咲",
//   "小野誠",
//   "藤本知子",
//   "菊地貴之",
//   "川田美希"
// ];

List<String> simpleUserNameList = [
  "里谷さん",
  "岡本さん",
  "戸松さん",
  "植村さん",
  "大下さん",
  "佐々木さん",
  "石田さん",
  "大木さん",
  "冨坂さん",
  "テスト9",
  "テスト10",
  "テスト11",
  "テスト12",
  "テスト13",
  "テスト14",
  "テスト15",
  "テスト16",
  "テスト17",
  "テスト18",
  "テスト19",
  "テスト20",
];


enum TimeLabel {
  startTime,
  endTime,
  selectTime,
}

enum OpenFormPageMode {
  add,
  edit,
  workTap
}

enum TimeSelectButtonMode {
  startTimeMode,
  endTimeMode,
}

enum PageType {
  Report,
  Calendar,
  Settings,
  Logout,
}
