//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TimerProps {
  /// Returns a new [TimerProps] instance.
  TimerProps({
    required this.duration,
    required this.color,
  });

  int duration;

  ColorProp color;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TimerProps &&
     other.duration == duration &&
     other.color == color;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (duration.hashCode) +
    (color.hashCode);

  @override
  String toString() => 'TimerProps[duration=$duration, color=$color]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'duration'] = duration;
      _json[r'color'] = color;
    return _json;
  }

  /// Returns a new [TimerProps] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TimerProps? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TimerProps[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TimerProps[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TimerProps(
        duration: mapValueOfType<int>(json, r'duration')!,
        color: ColorProp.fromJson(json[r'color'])!,
      );
    }
    return null;
  }

  static List<TimerProps>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TimerProps>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TimerProps.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TimerProps> mapFromJson(dynamic json) {
    final map = <String, TimerProps>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TimerProps.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TimerProps-objects as value to a dart map
  static Map<String, List<TimerProps>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TimerProps>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TimerProps.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'duration',
    'color',
  };
}

