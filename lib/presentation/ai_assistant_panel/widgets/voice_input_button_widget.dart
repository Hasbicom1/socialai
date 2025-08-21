import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class VoiceInputButtonWidget extends StatefulWidget {
  final Function(String) onVoiceInput;
  final bool isEnabled;

  const VoiceInputButtonWidget({
    Key? key,
    required this.onVoiceInput,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<VoiceInputButtonWidget> createState() => _VoiceInputButtonWidgetState();
}

class _VoiceInputButtonWidgetState extends State<VoiceInputButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
    _checkMicrophonePermission();
  }

  Future<void> _checkMicrophonePermission() async {
    if (kIsWeb) {
      setState(() => _hasPermission = true);
      return;
    }

    final status = await Permission.microphone.status;
    setState(() => _hasPermission = status.isGranted);
  }

  Future<void> _requestMicrophonePermission() async {
    if (kIsWeb) return;

    final status = await Permission.microphone.request();
    setState(() => _hasPermission = status.isGranted);
  }

  Future<void> _startRecording() async {
    if (!_hasPermission) {
      await _requestMicrophonePermission();
      if (!_hasPermission) return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() => _isRecording = true);
        _waveController.repeat(reverse: true);

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          final dir = await getTemporaryDirectory();
          String path = '${dir.path}/recording.m4a';
          await _audioRecorder.start(
            const RecordConfig(),
            path: path,
          );
        }

        HapticFeedback.lightImpact();
      }
    } catch (e) {
      setState(() => _isRecording = false);
      _waveController.stop();
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      _waveController.stop();
      _waveController.reset();

      if (path != null) {
        // Simulate voice-to-text conversion
        widget.onVoiceInput("Voice input processed from recording");
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      setState(() => _isRecording = false);
      _waveController.stop();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) => _stopRecording(),
      onTap: _isRecording ? _stopRecording : _startRecording,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isRecording ? _waveAnimation.value : 1.0,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording
                    ? AppTheme.errorRed
                    : widget.isEnabled
                        ? AppTheme.primaryAIBlue
                        : AppTheme.borderSubtle,
                boxShadow: _isRecording
                    ? [
                        BoxShadow(
                          color: AppTheme.errorRed.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : AppTheme.cardShadow,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _isRecording ? 'stop' : 'mic',
                  color: AppTheme.textPrimary,
                  size: 6.w,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}