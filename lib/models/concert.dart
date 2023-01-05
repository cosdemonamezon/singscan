import 'package:json_annotation/json_annotation.dart';
import 'package:singscan/models/concertShow.dart';

part 'concert.g.dart';

@JsonSerializable()
class Concert {
  final String id;
  String? concertName;
  String? description;
  String? cover;
  String? salesModel;
  String? stateImg;
  DateTime? publicSale;
  double? price;
  List<ConcertShow>? concertShows;
  DateTime? closeSale;

  Concert(this.id, this.concertName, this.description, this.cover, this.salesModel,  this.concertShows,
      this.publicSale, this.stateImg,   this.price, this.closeSale);

  factory Concert.fromJson(Map<String, dynamic> json) => _$ConcertFromJson(json);

  Map<String, dynamic> toJson() => _$ConcertToJson(this);
}
