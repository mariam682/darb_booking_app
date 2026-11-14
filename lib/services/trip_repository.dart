import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/trip.dart';

class TripRepository {
  static List<Trip>? _cache;

  static Future<List<Trip>> loadAll() async {
    final cached = _cache;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString('assets/data/trips.json');
    final list = jsonDecode(raw) as List<dynamic>;
    final trips = list
        .map((e) => Trip.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _cache = trips;
    return trips;
  }

  static Future<List<Trip>> search({
    required String originKey,
    required String destinationKey,
    required DateTime date,
  }) async {
    final all = await loadAll();
    final days = all.map((t) => t.templateDate).toSet().toList()..sort();
    final template = days[date.day.isOdd ? 0 : (days.length > 1 ? 1 : 0)];
    final result = all
        .where((t) =>
            t.originKey == originKey &&
            t.destinationKey == destinationKey &&
            t.templateDate == template)
        .toList()
      ..sort((a, b) => a.departure.compareTo(b.departure));
    return result;
  }
}
