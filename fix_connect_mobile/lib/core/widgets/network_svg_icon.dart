import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Fetches an SVG from [url] using [HttpClient], renders it tinted with
/// [color], and shows [fallback] on null URL, network failure, or parse error.
///
/// Unlike [SvgPicture.network], this widget exposes all failure states and
/// prints a diagnostic message in debug mode when loading fails.
class NetworkSvgIcon extends StatefulWidget {
  final String? url;
  final double size;
  final Color color;
  final Widget fallback;

  const NetworkSvgIcon({
    super.key,
    required this.url,
    required this.size,
    required this.color,
    required this.fallback,
  });

  /// Maps a service-category name to a relevant [IconData] so that the
  /// fallback is contextual rather than always a generic wrench.
  static IconData iconForCategory(String name) {
    final n = name.toLowerCase();
    if (n.contains('plumb') || n.contains('pipe')) return Icons.water_drop;
    if (n.contains('electr')) return Icons.electrical_services;
    if (n.contains('carpentr') || n.contains('woodwork'))
      return Icons.carpenter;
    if (n.contains('clean')) return Icons.cleaning_services;
    if (n.contains('paint')) return Icons.format_paint;
    if (n.contains('air') ||
        n.contains('hvac') ||
        n.contains('cool') ||
        n.contains(' ac'))
      return Icons.ac_unit;
    if (n.contains('garden') || n.contains('lawn') || n.contains('landscape'))
      return Icons.yard;
    if (n.contains('roof')) return Icons.roofing;
    if (n.contains('tile') || n.contains('tiling') || n.contains('mason'))
      return Icons.foundation;
    if (n.contains('weld') || n.contains('gas') || n.contains('fabricat'))
      return Icons.local_fire_department;
    if (n.contains('mov') || n.contains('haul') || n.contains('relocat'))
      return Icons.local_shipping;
    if (n.contains('secur') || n.contains('cctv') || n.contains('alarm'))
      return Icons.security;
    if (n.contains('pest') || n.contains('fumig')) return Icons.bug_report;
    if (n.contains('window') || n.contains('glass') || n.contains('glaz'))
      return Icons.window;
    if (n.contains('door') || n.contains('lock')) return Icons.door_front_door;
    if (n.contains('floor') || n.contains('parquet') || n.contains('vinyl'))
      return Icons.grid_on;
    if (n.contains('handyman') || n.contains('general')) return Icons.handyman;
    if (n.contains('applianc') || n.contains('fridge') || n.contains('wash'))
      return Icons.kitchen;
    if (n.contains('pool') || n.contains('swim')) return Icons.pool;
    if (n.contains('interior') || n.contains('decor') || n.contains('design'))
      return Icons.design_services;
    if (n.contains('solar') || n.contains('panel')) return Icons.solar_power;
    if (n.contains('water') || n.contains('tank') || n.contains('borehole'))
      return Icons.water;
    return Icons.build_rounded;
  }

  @override
  State<NetworkSvgIcon> createState() => _NetworkSvgIconState();
}

class _NetworkSvgIconState extends State<NetworkSvgIcon> {
  String? _svgData;

  @override
  void initState() {
    super.initState();
    _fetch(widget.url);
  }

  @override
  void didUpdateWidget(NetworkSvgIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() => _svgData = null);
      _fetch(widget.url);
    }
  }

  Future<void> _fetch(String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (!mounted) return;
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        if (mounted) setState(() => _svgData = body);
      } else {
        debugPrint('[NetworkSvgIcon] HTTP ${response.statusCode} for $url');
      }
    } catch (e) {
      debugPrint('[NetworkSvgIcon] Failed to load $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_svgData != null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: SvgPicture.string(
          _svgData!,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
        ),
      );
    }
    return widget.fallback;
  }
}
