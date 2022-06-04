//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ErrorResponse {
  /// Returns a new [ErrorResponse] instance.
  ErrorResponse({
    this.notFound,
    this.conflict,
    this.unauthorized,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notFound;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? conflict;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? unauthorized;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ErrorResponse &&
     other.notFound == notFound &&
     other.conflict == conflict &&
     other.unauthorized == unauthorized;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (notFound == null ? 0 : notFound!.hashCode) +
    (conflict == null ? 0 : conflict!.hashCode) +
    (unauthorized == null ? 0 : unauthorized!.hashCode);

  @override
  String toString() => 'ErrorResponse[notFound=$notFound, conflict=$conflict, unauthorized=$unauthorized]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
    if (notFound != null) {
      _json[r'NotFound'] = notFound;
    }
    if (conflict != null) {
      _json[r'Conflict'] = conflict;
    }
    if (unauthorized != null) {
      _json[r'Unauthorized'] = unauthorized;
    }
    return _json;
  }

  /// Returns a new [ErrorResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ErrorResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ErrorResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ErrorResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ErrorResponse(
        notFound: mapValueOfType<String>(json, r'NotFound'),
        conflict: mapValueOfType<String>(json, r'Conflict'),
        unauthorized: mapValueOfType<String>(json, r'Unauthorized'),
      );
    }
    return null;
  }

  static List<ErrorResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ErrorResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ErrorResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ErrorResponse> mapFromJson(dynamic json) {
    final map = <String, ErrorResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ErrorResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ErrorResponse-objects as value to a dart map
  static Map<String, List<ErrorResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ErrorResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ErrorResponse.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

