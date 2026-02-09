import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:voxai_quest/core/presentation/pages/no_internet_page.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternetStatus>(
      stream: InternetConnection().onStatusChange,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == InternetStatus.disconnected) {
          return NoInternetPage(
            onRetry: () async {
              // The stream will auto-update if connection is restored,
              // but we can also force a check if needed.
              // For now, simple visual feedback or re-check logic.
              final hasNet = await InternetConnection().hasInternetAccess;
              if (hasNet && context.mounted) {
                // If connected, the stream builder will naturally rebuild with connected status
              }
            },
          );
        }
        return child;
      },
    );
  }
}
