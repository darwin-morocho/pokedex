import 'package:flutter/material.dart';

import '../../../../../domain/failures/http_request/http_request_failure.dart';

class FailedRequest extends StatelessWidget {
  const FailedRequest({
    super.key,
    required this.failure,
    required this.onRetry,
  });
  final HttpRequestFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            failure.maybeWhen(
              network: () => 'Check your internet connection',
              orElse: () => 'Something was wrong!\nPlease try again.',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
