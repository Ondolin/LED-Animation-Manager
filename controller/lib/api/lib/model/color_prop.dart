//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ColorProp {
  /// Returns a new [ColorProp] instance.
  ColorProp({
    required this.blue,
    required this.red,
    required this.green,
  });

  int blue;

  int red;

  int green;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ColorProp &&
     other.blue == blue &&
     other.red == red &&
     other.green == green;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (blue.hashCode) +
    (red.hashCode) +
    (green.hashCode);

  @override
  String toString() => 'ColorProp[blue=$blue, red=$red, green=$green]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'blue'] = blue;
      _json[r'red'] = red;
      _json[r'green'] = green;
    return _json;
  }

  /// Returns a new [ColorProp] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ColorProp? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ColorProp[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ColorProp[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ColorProp(
        blue: mapValueOfType<int>(json, r'blue')!,
        red: mapValueOfType<int>(json, r'red')!,
        green: mapValueOfType<int>(json, r'green')!,
      );
    }
    return null;
  }

  static List<ColorProp>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ColorProp>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ColorProp.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ColorProp> mapFromJson(dynamic json) {
    final map = <String, ColorProp>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ColorProp.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ColorProp-objects as value to a dart map
  static Map<String, List<ColorProp>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ColorProp>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ColorProp.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'blue',
    'red',
    'green',
  };
}

