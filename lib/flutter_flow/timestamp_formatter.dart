import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A world-class timestamp formatter that displays times in a clean, modern way.
/// 
/// Formats timestamps intelligently based on how recent they are:
/// - Just now (< 1 minute)
/// - Relative minutes/hours (< 24 hours)
/// - Yesterday with time
/// - Day of week with time (< 7 days)
/// - Full date (older)
class TimestampFormatter {
  TimestampFormatter._();

  /// Formats a DateTime for chat messages with smart relative time
  /// Returns a clean, modern format like "Just now", "2m", "5h", "Yesterday", etc.
  static String formatRelative(DateTime? dateTime, {bool showTime = false}) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Just now (less than 1 minute ago)
    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    // Minutes ago (less than 1 hour)
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    }

    // Hours ago (less than 24 hours)
    if (difference.inHours < 24 && _isSameDay(now, dateTime)) {
      return '${difference.inHours}h ago';
    }

    // Yesterday
    if (_isYesterday(now, dateTime)) {
      if (showTime) {
        return 'Yesterday at ${DateFormat.jm().format(dateTime)}';
      }
      return 'Yesterday';
    }

    // Within the last 7 days - show day name
    if (difference.inDays < 7) {
      if (showTime) {
        return '${DateFormat.EEEE().format(dateTime)} at ${DateFormat.jm().format(dateTime)}';
      }
      return DateFormat.EEEE().format(dateTime);
    }

    // Older - show full date
    if (showTime) {
      return DateFormat('MMM d, y \'at\' h:mm a').format(dateTime);
    }
    return DateFormat('MMM d, y').format(dateTime);
  }

  /// Formats a DateTime for chat bubbles - more compact format
  /// Shows time for today, date+time for older messages
  static String formatChatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Just now
    if (difference.inMinutes < 1) {
      return 'now';
    }

    // Today - show just the time
    if (_isSameDay(now, dateTime)) {
      return DateFormat.jm().format(dateTime);
    }

    // Yesterday
    if (_isYesterday(now, dateTime)) {
      return 'Yesterday ${DateFormat.jm().format(dateTime)}';
    }

    // Within this year
    if (now.year == dateTime.year) {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }

    // Older
    return DateFormat('MMM d, y').format(dateTime);
  }

  /// Formats for chat list preview - shows relative time compactly
  static String formatChatListPreview(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Just now
    if (difference.inMinutes < 1) {
      return 'now';
    }

    // Minutes ago
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    }

    // Hours ago (today)
    if (_isSameDay(now, dateTime)) {
      return DateFormat.jm().format(dateTime);
    }

    // Yesterday
    if (_isYesterday(now, dateTime)) {
      return 'Yesterday';
    }

    // Within the last 7 days
    if (difference.inDays < 7) {
      return DateFormat.E().format(dateTime);
    }

    // Within this year
    if (now.year == dateTime.year) {
      return DateFormat('MMM d').format(dateTime);
    }

    // Older
    return DateFormat('M/d/yy').format(dateTime);
  }

  /// Formats for post/article timestamps - human-friendly
  static String formatPostTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Just now
    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    // Minutes ago
    if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'minute' : 'minutes'} ago';
    }

    // Hours ago (within 24 hours)
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }

    // Days ago (within 7 days)
    if (difference.inDays < 7) {
      final days = difference.inDays;
      if (days == 1) return 'Yesterday';
      return '$days days ago';
    }

    // Weeks ago (within a month)
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }

    // Within this year
    if (now.year == dateTime.year) {
      return DateFormat('MMMM d').format(dateTime);
    }

    // Older
    return DateFormat('MMMM d, y').format(dateTime);
  }

  /// Formats for event/agenda timestamps
  static String formatEventTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();

    // Today
    if (_isSameDay(now, dateTime)) {
      return 'Today at ${DateFormat.jm().format(dateTime)}';
    }

    // Tomorrow
    if (_isTomorrow(now, dateTime)) {
      return 'Tomorrow at ${DateFormat.jm().format(dateTime)}';
    }

    // This week
    if (dateTime.isAfter(now) && dateTime.difference(now).inDays < 7) {
      return '${DateFormat.EEEE().format(dateTime)} at ${DateFormat.jm().format(dateTime)}';
    }

    // This year
    if (now.year == dateTime.year) {
      return DateFormat('EEE, MMM d \'at\' h:mm a').format(dateTime);
    }

    // Other
    return DateFormat('EEE, MMM d, y \'at\' h:mm a').format(dateTime);
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool _isYesterday(DateTime now, DateTime date) {
    final yesterday = now.subtract(const Duration(days: 1));
    return _isSameDay(yesterday, date);
  }

  static bool _isTomorrow(DateTime now, DateTime date) {
    final tomorrow = now.add(const Duration(days: 1));
    return _isSameDay(tomorrow, date);
  }
}

/// A widget that displays a timestamp in a clean, modern style
class FormattedTimestamp extends StatelessWidget {
  const FormattedTimestamp({
    super.key,
    required this.dateTime,
    this.style,
    this.format = TimestampFormat.relative,
    this.prefix,
    this.suffix,
    this.showIcon = false,
  });

  final DateTime? dateTime;
  final TextStyle? style;
  final TimestampFormat format;
  final String? prefix;
  final String? suffix;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatTime();
    if (formattedTime.isEmpty) return const SizedBox.shrink();

    final text = '${prefix ?? ''}$formattedTime${suffix ?? ''}';

    if (showIcon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 12,
            color: style?.color ?? Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(text, style: style),
        ],
      );
    }

    return Text(text, style: style);
  }

  String _formatTime() {
    switch (format) {
      case TimestampFormat.relative:
        return TimestampFormatter.formatRelative(dateTime);
      case TimestampFormat.relativeWithTime:
        return TimestampFormatter.formatRelative(dateTime, showTime: true);
      case TimestampFormat.chatTime:
        return TimestampFormatter.formatChatTime(dateTime);
      case TimestampFormat.chatListPreview:
        return TimestampFormatter.formatChatListPreview(dateTime);
      case TimestampFormat.postTime:
        return TimestampFormatter.formatPostTime(dateTime);
      case TimestampFormat.eventTime:
        return TimestampFormatter.formatEventTime(dateTime);
    }
  }
}

enum TimestampFormat {
  relative,
  relativeWithTime,
  chatTime,
  chatListPreview,
  postTime,
  eventTime,
}
