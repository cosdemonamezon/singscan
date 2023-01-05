import 'package:json_annotation/json_annotation.dart';
import 'package:singscan/models/concert.dart';

part 'concertShow.g.dart';

@JsonSerializable()
class ConcertShow {
  final String id;
  final DateTime showDateTime;
  Concert? concert;

  ConcertShow(this.id, this.showDateTime, this.concert);

  factory ConcertShow.fromJson(Map<String, dynamic> json) => _$ConcertShowFromJson(json);

  Map<String, dynamic> toJson() => _$ConcertShowToJson(this);
}
