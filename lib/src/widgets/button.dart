import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double? width;
  final double? height;
  final Function? onPressed;
  final Widget? child;
  final String? text;
  final Widget? leading;
  final Widget? trailing;
  final BoxShape? boxShape;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const Button(
      {Key? key,
      this.width,
      this.height = 48.0,
      this.onPressed,
      this.child,
      this.text,
      this.leading,
      this.trailing,
      this.padding,
      this.borderRadius,
      this.boxShape})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        width: width,
        height: height,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          shape: boxShape ?? BoxShape.rectangle,
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
            begin: const Alignment(-1.0, -1),
            end: const Alignment(1.0, 1),
            colors: (this.onPressed == null)?<Color>[
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
              Theme.of(context).colorScheme.secondary.withOpacity(0.3)
            ] : <Color>[
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading ?? Container(),
            if (leading != null)
              const SizedBox(
                width: 12.0,
              ),
            child ??
                Text(
                  text ?? '',
                  style: Theme.of(context).textTheme.button?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
            if (trailing != null)
              const SizedBox(
                width: 12.0,
              ),
            trailing ?? Container()
          ],
        ),
      ),
    );
  }
}
