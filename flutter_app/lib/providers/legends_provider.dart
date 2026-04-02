import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/legend_model.dart';
import '../services/api_service.dart';
import '../services/ws_service.dart';

class LegendsProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final WsService _ws = WsService();
  RemoveListener? _removeWsListener;

  String? _currentPageId;
  List<LegendModel> _legends = [];

  String? get currentPageId => _currentPageId;
  List<LegendModel> get legends => _legends;

  LegendsProvider() {
    _removeWsListener = _ws.addListener(_onWsMessage);
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  Future<void> setPageId(String? id) async {
    _currentPageId = id;
    _legends = [];
    notifyListeners();

    if (id != null) {
      await _fetchLegends();
    }
  }

  Future<void> createLegend(String color, String label) async {
    if (_currentPageId == null) return;

    try {
      final response = await _api.apiFetch(
        '/api/pages/$_currentPageId/legends',
        method: 'POST',
        body: {'color': color, 'label': label},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final legend = LegendModel.fromJson(json);
        _legends.add(legend);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('LegendsProvider: createLegend failed: $e');
    }
  }

  Future<void> deleteLegend(String id) async {
    if (_currentPageId == null) return;

    try {
      final response = await _api.apiFetch(
        '/api/pages/$_currentPageId/legends/$id',
        method: 'DELETE',
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        _legends.removeWhere((l) => l.id == id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('LegendsProvider: deleteLegend failed: $e');
    }
  }

  Future<void> reorderLegends(List<String> ids) async {
    if (_currentPageId == null) return;

    // Optimistic reorder
    final reordered = <LegendModel>[];
    for (final id in ids) {
      try {
        final legend = _legends.firstWhere((l) => l.id == id);
        reordered.add(legend);
      } catch (_) {
        // Legend not found locally, skip
      }
    }
    final previousLegends = List<LegendModel>.of(_legends);
    _legends = reordered;
    notifyListeners();

    try {
      final response = await _api.apiFetch(
        '/api/pages/$_currentPageId/legends/reorder',
        method: 'PUT',
        body: {'ids': ids},
      );
      if (response.statusCode != 200) {
        // Revert on failure
        _legends = previousLegends;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('LegendsProvider: reorderLegends failed: $e');
      _legends = previousLegends;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // WebSocket
  // ---------------------------------------------------------------------------

  void _onWsMessage(WsMessage message) {
    switch (message.event) {
      case 'legend:created':
        final json = message.data as Map<String, dynamic>;
        final legend = LegendModel.fromJson(json);
        if (legend.pageId == _currentPageId &&
            !_legends.any((l) => l.id == legend.id)) {
          _legends.add(legend);
          notifyListeners();
        }
        break;

      case 'legend:deleted':
        final json = message.data as Map<String, dynamic>;
        final id = json['id'] as String;
        final pageId = json['page_id'] as String?;
        if (pageId == _currentPageId) {
          _legends.removeWhere((l) => l.id == id);
          notifyListeners();
        }
        break;

      case 'legends:reordered':
        final json = message.data as Map<String, dynamic>;
        final pageId = json['page_id'] as String?;
        if (pageId == _currentPageId) {
          final list = json['legends'] as List<dynamic>?;
          if (list != null) {
            _legends = list
                .map((l) => LegendModel.fromJson(l as Map<String, dynamic>))
                .toList();
            notifyListeners();
          }
        }
        break;

      case 'legends:recolored':
        final json = message.data as Map<String, dynamic>;
        final pageId = json['page_id'] as String?;
        if (pageId == _currentPageId) {
          final list = json['legends'] as List<dynamic>?;
          if (list != null) {
            for (final legendJson in list) {
              final updated =
                  LegendModel.fromJson(legendJson as Map<String, dynamic>);
              final index = _legends.indexWhere((l) => l.id == updated.id);
              if (index != -1) {
                _legends[index] = updated;
              }
            }
            notifyListeners();
          }
        }
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Future<void> _fetchLegends() async {
    try {
      final response =
          await _api.apiFetch('/api/pages/$_currentPageId/legends');
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        _legends = list
            .map((json) => LegendModel.fromJson(json as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('LegendsProvider: fetchLegends failed: $e');
    }
  }

  @override
  void dispose() {
    _removeWsListener?.call();
    super.dispose();
  }
}
