import 'package:flutter/material.dart';

class OptionsBoxBorderButton extends StatefulWidget {
  const OptionsBoxBorderButton({
    super.key,
    required this.onPressed1,
    required this.onPressed2,
    required this.title1,
    required this.title2,
    required this.condition,
    this.icon1,
    this.icon2,
  });

  final VoidCallback onPressed1;
  final VoidCallback onPressed2;
  final String title1;
  final String title2;
  final IconData? icon1;
  final IconData? icon2;

  final bool condition;
  @override
  State<OptionsBoxBorderButton> createState() => _OptionsBoxBorderButtonState();
}

class _OptionsBoxBorderButtonState extends State<OptionsBoxBorderButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        child: TextButton(
          onPressed: widget.condition ? widget.onPressed1 : widget.onPressed2,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(15),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            ),
          ),
          child: SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.35,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                switchInCurve: Curves.easeInExpo,
                switchOutCurve: Curves.easeOutExpo,
                child: widget.condition
                    ? Row(
                        key: const ValueKey(1),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon1 != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                widget.icon1,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          Text(
                            widget.title1,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontFamily: "Lugrasimo"),
                          ),
                        ],
                      )
                    : Row(
                        key: const ValueKey(2),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon2 != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                widget.icon2,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          Text(
                            widget.title2,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontFamily: "Lugrasimo"),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
