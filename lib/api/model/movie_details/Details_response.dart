import '@meta.dart';

import 'Data.dart';

class DetailsResponse {
  DetailsResponse({
    this.error,
    this.status,
    this.statusMessage,
    this.data,
    this.meta,
  });

  DetailsResponse.fromJson(dynamic json) {
    error = json['error'];
    status = json['status'];
    statusMessage = json['status_message'];

    data = json['data'] != null ? Data.fromJson(json['data']) : null;

    meta = json['@meta'] != null ? Meta.fromJson(json['@meta']) : null;
  }

  String? error;
  String? status;
  String? statusMessage;
  Data? data;
  Meta? meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['error'] = error;
    map['status'] = status;
    map['status_message'] = statusMessage;

    if (data != null) {
      map['data'] = data!.toJson();
    }

    if (meta != null) {
      map['@meta'] = meta!.toJson();
    }

    return map;
  }
}
