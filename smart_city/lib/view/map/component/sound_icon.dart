import 'package:flutter/material.dart';


class SoundIcon extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final IconData listeningIcon;
  final IconData speakingIcon;

  const SoundIcon({
    super.key,
    required this.listeningIcon,
    required this.speakingIcon,
    required this.onTap,
    this.activeColor = Colors.greenAccent,
    this.inactiveColor = Colors.white,
    required this.isListening,
  });

  @override
  State<SoundIcon> createState() => _SoundIconState();
}

class _SoundIconState extends State<SoundIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: widget.isListening
                      ? [
                    widget.activeColor.withOpacity(0.7),
                    widget.activeColor.withOpacity(0.3),
                  ]
                      : [
                    Colors.white24,
                    Colors.white10,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isListening
                        ? widget.activeColor.withOpacity(0.5)
                        : Colors.white12,
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated wave effect
                  if (widget.isListening)
                    ...List.generate(3, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.activeColor.withOpacity(0.2 / (index + 1)),
                        ),
                      );
                    }),

                  // Main icon
                  Icon(
                    (widget.isListening)
                        ? widget.speakingIcon
                        : widget.listeningIcon,
                    color: widget.inactiveColor,
                    size: 30,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}