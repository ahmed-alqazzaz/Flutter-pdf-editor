import 'package:flutter/material.dart';
import '../../../../../utils/oxford_dictionary_scraper/data/data.dart';

class GenericExplanationBuilder extends StatelessWidget {
  const GenericExplanationBuilder({
    super.key,
    required this.definition,
    required this.examples,
  });

  final Definition definition;
  final Iterable<Example>? examples;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 15,
            bottom: 20,
            left: 20,
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: definition.grammar != null
                      ? '${definition.grammar} '
                      : null,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: definition.main,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
        if (examples != null) ...[
          for (var example in examples!)
            Padding(
              padding: const EdgeInsets.only(
                right: 15,
                bottom: 15,
                left: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      right: 10,
                    ),
                    child: Icon(
                      Icons.circle,
                      color: Colors.grey.shade600,
                      size: 7,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      example.regularText,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
        ]
      ],
    );
  }
}
