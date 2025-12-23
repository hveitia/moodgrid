import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';

class PinInputWidget extends StatefulWidget {
  final int pinLength;
  final Function(String) onComplete;
  final String? errorText;
  final VoidCallback? onClear;

  const PinInputWidget({
    super.key,
    required this.pinLength,
    required this.onComplete,
    this.errorText,
    this.onClear,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PinInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != null && widget.errorText != oldWidget.errorText) {
      _shakePin();
      _clearPin();
    }
  }

  void _shakePin() {
    _shakeController.forward(from: 0).then((_) {
      _shakeController.reverse();
    });
    HapticFeedback.heavyImpact();
  }

  void _clearPin() {
    setState(() {
      _pin = '';
    });
    if (widget.onClear != null) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          widget.onClear?.call();
        }
      });
    }
  }

  void _addDigit(String digit) {
    if (_pin.length < widget.pinLength) {
      HapticFeedback.lightImpact();
      setState(() {
        _pin += digit;
      });

      if (_pin.length == widget.pinLength) {
        widget.onComplete(_pin);
      }
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Widget _buildPinIndicator(int index) {
    final isFilled = index < _pin.length;
    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? AppColors.textPrimary : Colors.transparent,
        border: Border.all(
          color: AppColors.textPrimary,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _addDigit(number),
      customBorder: const CircleBorder(),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.pinLength,
              (index) => _buildPinIndicator(index),
            ),
          ),
          if (widget.errorText != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildNumberButton('1'),
              _buildNumberButton('2'),
              _buildNumberButton('3'),
              _buildNumberButton('4'),
              _buildNumberButton('5'),
              _buildNumberButton('6'),
              _buildNumberButton('7'),
              _buildNumberButton('8'),
              _buildNumberButton('9'),
              const SizedBox(),
              _buildNumberButton('0'),
              InkWell(
                onTap: _removeDigit,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.divider,
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.backspace_outlined,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
