import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/shared/widgets/loading_indicator.dart';

class ButtonPrimary extends StatefulWidget {
  const ButtonPrimary({
    super.key,
    required this.onPressed,
    this.child,
    this.loadingColor = Colors.white,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.fullWidth = false,
    this.elevation = 0,
    this.isLoading = false,
    this.loadingWidget,
    this.color = AppColors.primaryColor,
    this.textColor,
    this.icon,
    this.suffixIcon,
    this.onLongPressed,
    this.alignment,
    this.borderSide,
    this.text = 'Button',
    this.enable = true,
    this.borderRadius = 12,
    this.isOutline = false,
    this.outlineColor,
    this.textStyle,
    this.gradient,
  });

  final bool isLoading;
  final bool enable;
  final Widget? child;
  final String text;
  final TextStyle? textStyle;
  final Widget? icon;
  final Widget? suffixIcon;
  final VoidCallback? onPressed;
  final Function? onLongPressed;
  final double? elevation;
  final Color color;
  final Color? textColor;
  final Color loadingColor;
  final Widget? loadingWidget;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final MainAxisAlignment? alignment;
  final bool fullWidth;
  final BorderSide? borderSide;
  final double borderRadius;
  final bool isOutline;
  final Color? outlineColor;

  /// If provided, overrides [color] with a gradient background
  final LinearGradient? gradient;

  @override
  State<ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  bool _isPressed = false;

  LinearGradient? get _effectiveGradient {
    if (widget.isOutline) return null;
    if (widget.gradient != null) return widget.gradient;
    // Use warm gold gradient for primary color
    if (widget.color == AppColors.primaryColor) {
      return Gradients.primary();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _effectiveGradient;
    final borderRadius = BorderRadius.all(Radius.circular(widget.borderRadius));

    return GestureDetector(
      onTapDown: widget.isLoading || !widget.enable
          ? null
          : (_) {
              HapticFeedback.lightImpact();
              setState(() => _isPressed = true);
            },
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.fullWidth ? double.infinity : null,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: borderRadius,
          ),
          child: widget.isOutline
              ? _buildOutlineButton(borderRadius)
              : gradient != null
                  ? _buildGradientButton(gradient, borderRadius)
                  : _buildSolidButton(borderRadius),
        ),
      ),
    );
  }

  Widget _buildGradientButton(
      LinearGradient gradient, BorderRadius borderRadius) {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.isLoading ? null : gradient,
        color: widget.isLoading ? widget.color.withOpacity(0.5) : null,
        borderRadius: borderRadius,
        boxShadow: widget.isLoading
            ? []
            : [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading
              ? null
              : widget.enable
                  ? widget.onPressed
                  : null,
          borderRadius: borderRadius,
          splashColor: Colors.white24,
          highlightColor: AppColors.primaryColor,
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildSolidButton(BorderRadius borderRadius) {
    return ElevatedButton(
      onPressed: widget.isLoading
          ? () {}
          : widget.enable
              ? widget.onPressed
              : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: widget.textColor,
        backgroundColor:
            widget.isLoading ? widget.color.withOpacity(0.4) : widget.color,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        padding: widget.padding,
        elevation: widget.isLoading ? 0 : widget.elevation,
        side: widget.borderSide,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlineButton(BorderRadius borderRadius) {
    return ElevatedButton(
      onPressed: widget.isLoading
          ? () {}
          : widget.enable
              ? widget.onPressed
              : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: widget.textColor,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: widget.outlineColor ?? widget.color),
        ),
        padding: widget.padding,
        elevation: 0,
        side: widget.borderSide,
        shadowColor: Colors.transparent,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    return Visibility(
      visible: widget.isLoading,
      replacement: Row(
        mainAxisAlignment: widget.alignment ?? MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.icon != null) ...[
            widget.icon ?? SizedBox(),
            8.horizontalSpace,
          ],
          Padding(
            padding: const EdgeInsets.all(12),
            child: widget.child ??
                Text(
                  widget.text,
                  style: widget.textStyle ??
                      AppTextStyle.largeBlack.copyWith(
                        color: widget.textColor ?? Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
          ),
          if (widget.suffixIcon != null) ...[
            8.horizontalSpace,
            widget.suffixIcon ?? SizedBox(),
          ],
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LoadingIndicator(
          key: const Key('loadingButton'),
          fgColor: widget.loadingColor,
        ),
      ),
    );
  }
}
