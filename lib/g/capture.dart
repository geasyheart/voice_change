import 'package:sentry/sentry.dart';

const String DSN = "";


final SentryClient sentryHandler = new SentryClient(dsn: DSN);

// 是否调试模式
final isInDebugMode = true;

Future<Null> reportError(dynamic error, dynamic stackTrace) async {
  if (isInDebugMode) {
    print('---------------------调试模式-----------------------');
    print(stackTrace);
    print('---------------------到此结束-----------------------');
    return;
  }


  final SentryResponse response = await sentryHandler.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Sentry ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}
