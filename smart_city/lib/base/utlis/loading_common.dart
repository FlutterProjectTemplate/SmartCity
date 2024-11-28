import 'package:flutter/material.dart';

class CustomLoading {
  static final CustomLoading _instance = CustomLoading._internal();
  factory CustomLoading() => _instance;

  CustomLoading._internal();

  late OverlayState _overlayState;
  OverlayEntry? _overlayEntry;

  /// Initialize OverlayState
  void initialize(BuildContext context) {
    _overlayState = Overlay.of(context);
  }

  /// Show the loading overlay
  void showLoading({String? message}) {
    if (_overlayEntry != null) return; // Prevent multiple overlays

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background with transparency
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          if (message != null)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    _overlayState.insert(_overlayEntry!);
  }

  /// Dismiss the loading overlay
  void dismissLoading() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  /// Check if loading is active
  bool isLoadingActive() {
    return _overlayEntry != null;
  }
}
