
// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewTimer {
  String minutes;
  String seconds;
  NewTimer({
    required this.minutes,
    required this.seconds,
  });

  Map toMap() {
    return{
      'minutes': minutes,
      'seconds': seconds,
    };
  }

  factory NewTimer.fromMap(Map map) {
    return NewTimer(
      minutes: map['minutes'],
      seconds: map['seconds'],
    );
  }

  // String toJson() => json.encode(toMap());

  // factory MyTimer.fromJson(String source) => MyTimer.fromMap(json.decode(source) as Map);
}
