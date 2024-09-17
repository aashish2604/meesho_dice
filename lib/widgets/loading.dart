import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class LabeledLoadingWidget extends StatelessWidget {
  final Color loaderColor;
  final Widget label;
  const LabeledLoadingWidget(
      {super.key, required this.label, required this.loaderColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            color: loaderColor,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        label
      ],
    );
  }
}
