import 'package:flutter/material.dart';
import 'package:seo_renderer/renderers/text_renderer/text_renderer_vm.dart';

class FlutterConfButton extends StatelessWidget {
  const FlutterConfButton({
    Key? key,
    required this.constraints,
    required this.text,
    required this.onPressed,
    this.buttonSize,
    this.fontSize,
    this.width,
    this.icon,
  }) : super(key: key);
  final BoxConstraints constraints;
  final String text;
  final Function() onPressed;
  final double? fontSize;
  final double? buttonSize;
  final double? width;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: width ?? 180,
          height: buttonSize ?? 56,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(48),
            ),
            color: Colors.red,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextRenderer(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize ?? constraints.maxWidth * 0.013,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  icon ?? const SizedBox.shrink(),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
