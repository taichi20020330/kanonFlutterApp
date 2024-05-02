enum UserLabel {
  user0('戸松さん'),
  user1('吉田さん'),
  user2('岡本さん'),
  user3('秋谷さん'),
  user4('前田さん'),
  user5('田中さん'),
  user6('山本さん'),
  user7('加藤さん'),
  user8('鈴木さん'),
  user9('高橋さん'),
  user10('伊藤さん'),
  user11('渡辺さん'),
  user12('佐藤さん'),
  user13('小林さん'),
  user14('山田さん'),
  user15('中村さん'),
  user16('斎藤さん'),
  user17('吉田さん'),
  user18('山口さん'),
  user19('松本さん'),
  user20('清水さん'),
  user21('井上さん'),
  user22('鈴木さん'),
  user23('斎藤さん'),
  user24('中島さん'),
  user25('小川さん'),
  user26('橋本さん'),
  user27('山崎さん'),
  user28('武田さん'),
  user29('上田さん'),
  user30('藤原さん');

  const UserLabel(this.label);
  final String label;
}

List<String> simpleUserNameList = [
  "佐藤真美",
  "鈴木太郎",
  "高橋みさき",
  "田中健太",
  "渡辺美香",
  "伊藤貴子",
  "山本勇介",
  "中村さやか",
  "小林大輝",
  "加藤みゆき",
  "山田裕太",
  "斎藤千佳",
  "木村健司",
  "井上あやこ",
  "山口大樹",
  "小川まどか",
  "加藤聡太",
  "鈴木由美",
  "高橋明美",
  "田村啓介",
  "中島美咲",
  "小野誠",
  "藤本知子",
  "菊地貴之",
  "川田美希"
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
