// To parse this JSON data, do
//
//     final deliveriesList = deliveriesListFromJson(jsonString);

import 'dart:convert';

List<DeliveriesList> deliveriesListFromJson(String str) =>
    List<DeliveriesList>.from(
        json.decode(str).map((x) => DeliveriesList.fromJson(x)));

String deliveriesListToJson(List<DeliveriesList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliveriesList {
  DeliveriesList({
    required this.id,
    required this.userId,
    required this.riderId,
    required this.transactionNo,
    required this.status,
    required this.notes,
    required this.pickupLocation,
    required this.pickupName,
    required this.pickupContact,
    required this.packageId,
    required this.pickupTime,
    required this.deliveryTime,
    required this.dropOffContact,
    required this.dropOffLocation,
    required this.dropOffName,
    required this.fromLatitude,
    required this.fromLongitude,
    required this.toLatitude,
    required this.toLongitude,
    required this.deliveryCharges,
    required this.kilometres,
    required this.chargePerKm,
    required this.packageName,
    required this.deliveryId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  String riderId;
  String transactionNo;
  String status;
  String notes;
  String pickupLocation;
  String pickupName;
  String pickupContact;
  String packageId;
  String pickupTime;
  String deliveryTime;
  String dropOffContact;
  String dropOffLocation;
  String dropOffName;
  String packageName;
  String fromLatitude;
  String fromLongitude;
  String toLatitude;
  String toLongitude;
  String deliveryCharges;
  String kilometres;
  String chargePerKm;
  String deliveryId;
  DateTime createdAt;
  DateTime updatedAt;

  factory DeliveriesList.fromJson(Map<String, dynamic> json) => DeliveriesList(
        id: json["id"],
        userId: json["user_id"],
        riderId: json["rider_id"],
        transactionNo: json["transaction_no"],
        status: json["status"],
        notes: json["notes"] ?? "",
        pickupLocation: json["pickup_location"],
        packageName: json['package_name'],
        pickupName: json["pickup_name"],
        pickupContact: json["pickup_contact"],
        packageId: json["package_id"],
        pickupTime: json["pickup_time"],
        deliveryTime: json["delivery_time"],
        dropOffContact: json["drop_off_contact"],
        dropOffLocation: json["drop_off_location"],
        dropOffName: json["drop_off_name"],
        fromLatitude: json["from_latitude"],
        fromLongitude: json["from_longitude"],
        toLatitude: json["to_latitude"],
        toLongitude: json["to_longitude"],
        deliveryCharges: json["delivery_charges"],
        kilometres: json["kilometres"],
        chargePerKm: json["charge_per_km"],
        deliveryId: json["delivery_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "rider_id": riderId,
        "transaction_no": transactionNo,
        "status": status,
        "notes": notes,
        "pickup_location": pickupLocation,
        "pickup_name": pickupName,
        "pickup_contact": pickupContact,
        "package_id": packageId,
        "pickup_time": pickupTime,
        "delivery_time": deliveryTime,
        "drop_off_contact": dropOffContact,
        "drop_off_location": dropOffLocation,
        "drop_off_name": dropOffName,
        "from_latitude": fromLatitude,
        "from_longitude": fromLongitude,
        "to_latitude": toLatitude,
        "to_longitude": toLongitude,
        "delivery_charges": deliveryCharges,
        "kilometres": kilometres,
        "charge_per_km": chargePerKm,
        "delivery_id": deliveryId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
