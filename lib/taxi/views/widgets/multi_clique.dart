import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'dart:async';

class MultiClickAudioButton extends StatefulWidget {
  final String text;
  final String audioAssetPath;
  final int requiredClicks;
  final Duration resetDelay;
  final TextStyle? textStyle;

  const MultiClickAudioButton({
    super.key,
    required this.text,
    required this.audioAssetPath,
    this.requiredClicks = 5,
    this.resetDelay = const Duration(seconds: 3),
    this.textStyle,
  });

  @override
  State<MultiClickAudioButton> createState() => _MultiClickAudioButtonState();
}

class _MultiClickAudioButtonState extends State<MultiClickAudioButton>
    with TickerProviderStateMixin {
  int _clickContador = 0;
  Timer? _resetTimer;
  Timer? _cooldownTimer;
  bool _isCooldown = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _progressController;

  ConfettiController? controller1;
  ConfettiController? controller2;
  bool isDone = false;

  static const colors = [
    Color(0xff0091cf),
    Color(0xffffffff),
  ];

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _cooldownTimer?.cancel();
    _audioPlayer.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    _pararConfetti();
    super.dispose();
  }

  void _multiClick() async {
    HapticFeedback.lightImpact();

    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    setState(() {
      _clickContador++;
    });

    _progressController.animateTo(_clickContador / widget.requiredClicks);

    _resetTimer?.cancel();

    if (_clickContador >= widget.requiredClicks) {
      await _playAudio();
      _iniciarConfetti();

      HapticFeedback.mediumImpact();

      Timer(const Duration(milliseconds: 500), () {
        _resetClickContador();
        _inicarCooldown();
      });
    } else {
      _resetTimer = Timer(widget.resetDelay, () {
        _resetClickContador();
      });
    }
  }

  void _inicarCooldown() {
    setState(() {
      _isCooldown = true;
    });

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(const Duration(minutes: 5), () {
      if (mounted) {
        setState(() {
          _isCooldown = false;
        });
      }
    });
  }

  void _resetClickContador() {
    if (mounted) {
      setState(() {
        _clickContador = 0;
      });
      _progressController.reset();
    }
    _resetTimer?.cancel();
    _resetTimer = null;
    _pararConfetti();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(AssetSource(widget.audioAssetPath));
    } catch (e) {
      debugPrint('Erro ao tocar áudio: $e');
    }
  }

  void _iniciarConfetti() {
    if (!mounted) return;

    isDone = false;
    int frameTime = 1000 ~/ 24;
    int total = 3 * 1000 ~/ frameTime;
    int progress = 0;

    Timer.periodic(Duration(milliseconds: frameTime), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      progress++;

      if (progress >= total) {
        timer.cancel();
        isDone = true;
        _pararConfetti();
        return;
      }

      if (controller1 == null) {
        controller1 = Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 3,
            angle: 60,
            spread: 55,
            x: 0,
            colors: colors,
          ),
          onFinished: (overlayEntry) {
            if (isDone) overlayEntry.remove();
          },
        );
      } else {
        controller1!.launch();
      }

      if (controller2 == null) {
        controller2 = Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 3,
            angle: 120,
            spread: 55,
            x: 1,
            colors: colors,
          ),
          onFinished: (overlayEntry) {
            if (isDone) overlayEntry.remove();
          },
        );
      } else {
        controller2!.launch();
      }
    });
  }

  void _pararConfetti() {
    controller1 = null;
    controller2 = null;
    isDone = true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TextButton(
                onPressed: _isCooldown ? null : _multiClick,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.text,
                      style: widget.textStyle ??
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
