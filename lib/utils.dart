import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Utils {
  static String formatTime(dynamic dateTime) {
    if (dateTime == null) return ''; // Return empty string if dateTime is null
    DateTime dt = DateTime.parse(dateTime); // Parse the timestampz to DateTime
    return DateFormat.jm().format(
        dt.toLocal()); // Convert to local timezone and format as "12:30 PM"
  }

  static String formatDate(dynamic dateTime) {
    if (dateTime == null) return ''; // Return empty string if dateTime is null
    DateTime dt = DateTime.parse(dateTime); // Parse the timestampz to DateTime
    return DateFormat('MMM dd, yyyy').format(dt); // Format as "Dec 21, 2022"
  }

  static String formatPrice(num amount) {
    if (amount == null) {
      return '';
    }

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final formatted = formatter.format(amount); // Format the number as currency
    // Remove '.00' if the amount is an integer and ends with '.00'
    if (amount % 1 == 0 && formatted.endsWith(',00')) {
      return formatted.replaceAll(',00', '');
    }

    return formatted;
  }

  static String giveStatus(num seatLeft) {
    if (seatLeft == null) {
      return '';
    }

    if (seatLeft > 5) {
      return "Available";
    } else {
      return "${seatLeft} Left";
    }
  }

  static String formatDuration(dynamic fromTime, dynamic toTime) {
    if (fromTime == null || toTime == null) {
      return '';
    }
    DateTime from = DateTime.parse(fromTime);
    DateTime to = DateTime.parse(toTime);
    Duration duration = to.difference(from);

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    return "${hours}h ${minutes}m"; // Format as "1h 20m"
  }

  static String getDayDate(dynamic input) {
    if (input == null) {
      return '';
    } else {
      DateTime dt = DateTime.parse(input);
      return DateFormat('E, d MMM').format(dt);
    }
  }

  static String extractCityName(String input) {
    if (input == null) {
      return '';
    }
    // Regular expression to capture city name before any parentheses
    RegExp regex = RegExp(r'([a-zA-Z\s]+)\s*\(\d+\)');

    // Match the pattern in the input string
    Match? match = regex.firstMatch(input);

    // If a match is found, return the captured city name, else return empty string
    return match != null ? match.group(1)!.trim() : '';
  }
}
