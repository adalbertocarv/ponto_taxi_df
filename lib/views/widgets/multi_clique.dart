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
  int _clickCount = 0;
  Timer? _resetTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Animação para feedback visual
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Animação para indicar progresso
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // Variáveis do confetti
  ConfettiController? controller1;
  ConfettiController? controller2;
  bool isDone = false;

  static const colors = [
    Color(0xffbb0000),
    Color(0xff000000),
    // Color(0xffffff00), // Amarelo adicional
    // Color(0xff00ff00), // Verde adicional
  ];

  @override
  void initState() {
    super.initState();

    // Configurar animações
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

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _audioPlayer.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    _stopConfetti();
    super.dispose();
  }

  void _handleClick() async {
    // Feedback háptico
    HapticFeedback.lightImpact();

    // Animação de scale
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    setState(() {
      _clickCount++;
    });

    // Atualizar animação de progresso
    _progressController.animateTo(_clickCount / widget.requiredClicks);

    // Cancelar timer anterior se existir
    _resetTimer?.cancel();

    if (_clickCount >= widget.requiredClicks) {
      // Tocar o áudio e disparar confetti
      await _playAudio();
      _startConfetti();

      // Feedback háptico mais forte
      HapticFeedback.mediumImpact();

      // Reset após um delay para permitir que o confetti seja visto
      Timer(const Duration(milliseconds: 500), () {
        _resetClickCount();
      });
    } else {
      // Configurar timer para reset automático
      _resetTimer = Timer(widget.resetDelay, () {
        _resetClickCount();
      });
    }
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(AssetSource(widget.audioAssetPath));
    } catch (e) {
      debugPrint('Erro ao tocar áudio: $e');
      // Mostrar snackbar de erro (opcional)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao reproduzir áudio'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _startConfetti() {
    if (!mounted) return;

    isDone = false;
    int frameTime = 1000 ~/ 24;
    int total = 3 * 1000 ~/ frameTime; // 3 segundos de confetti
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
        _stopConfetti();
        return;
      }

      // Confetti da esquerda
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
            if (isDone) {
              overlayEntry.remove();
            }
          },
        );
      } else {
        controller1!.launch();
      }

      // Confetti da direita
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
            if (isDone) {
              overlayEntry.remove();
            }
          },
        );
      } else {
        controller2!.launch();
      }
    });
  }

  void _stopConfetti() {
    controller1 = null;
    controller2 = null;
    isDone = true;
  }

  void _resetClickCount() {
    if (mounted) {
      setState(() {
        _clickCount = 0;
      });
      _progressController.reset();
    }
    _resetTimer?.cancel();
    _resetTimer = null;
    _stopConfetti();
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
              // // Indicador de progresso circular (opcional)
              // if (_clickCount > 0)
              //   AnimatedBuilder(
              //     animation: _progressAnimation,
              //     builder: (context, child) {
              //       return SizedBox(
              //         width: 80,
              //         height: 80,
              //         child: CircularProgressIndicator(
              //           value: _progressAnimation.value,
              //           strokeWidth: 3,
              //           backgroundColor: Colors.grey.withOpacity(0.3),
              //           valueColor: AlwaysStoppedAnimation<Color>(
              //             Theme.of(context).primaryColor,
              //           ),
              //         ),
              //       );
              //     },
              //   ),

              // Botão principal
              TextButton(
                onPressed: _handleClick,
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

                    // // Indicador de cliques
                    // if (_clickCount > 0)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 4),
                    //     child: Text(
                    //       '${_clickCount}/${widget.requiredClicks}',
                    //       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    //         color: Theme.of(context).primaryColor,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ),
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

// Exemplo de uso simples com confetti
class SimpleMultiClickButton extends StatefulWidget {
  const SimpleMultiClickButton({super.key});

  @override
  State<SimpleMultiClickButton> createState() => _SimpleMultiClickButtonState();
}

class _SimpleMultiClickButtonState extends State<SimpleMultiClickButton> {
  int _clickCount = 0;
  Timer? _resetTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Variáveis do confetti
  ConfettiController? controller1;
  ConfettiController? controller2;
  bool isDone = false;

  static const colors = [
    Color(0xffbb0000),
    Color(0xffffffff),
  ];

  void _handleClick() async {
    setState(() {
      _clickCount++;
    });

    // Reset timer
    _resetTimer?.cancel();

    if (_clickCount >= 5) {
      // Tocar áudio
      try {
        await _audioPlayer.play(AssetSource('sounds/your_audio_file.mp3'));
      } catch (e) {
        debugPrint('Erro ao tocar áudio: $e');
      }

      // Disparar confetti
      _startConfetti();

      // Reset após delay
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _clickCount = 0;
          });
        }
      });
    } else {
      // Auto reset após 3 segundos
      _resetTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _clickCount = 0;
          });
        }
      });
    }
  }

  void _startConfetti() {
    if (!mounted) return;

    isDone = false;
    int frameTime = 1000 ~/ 24;
    int total = 15 * 1000 ~/ frameTime;
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
        return;
      }

      if (controller1 == null) {
        controller1 = Confetti.launch(
          context,
          options: const ConfettiOptions(
              particleCount: 2,
              angle: 60,
              spread: 55,
              x: 0,
              colors: colors),
          onFinished: (overlayEntry) {
            if (isDone) {
              overlayEntry.remove();
            }
          },
        );
      } else {
        controller1!.launch();
      }

      if (controller2 == null) {
        controller2 = Confetti.launch(
          context,
          options: const ConfettiOptions(
              particleCount: 2,
              angle: 120,
              spread: 55,
              x: 1,
              colors: colors),
          onFinished: (overlayEntry) {
            if (isDone) {
              overlayEntry.remove();
            }
          },
        );
      } else {
        controller2!.launch();
      }
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _audioPlayer.dispose();
    controller1 = null;
    controller2 = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _handleClick,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Menu',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_clickCount > 0)
            Text(
              '$_clickCount/5',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}