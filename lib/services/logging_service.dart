/*..............................................................................
 . Copyright (c)
 .
 . The logging_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 07/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:logging/logging.dart';

Logger logger = Logger('Photo Store');

// ----- Most important loggers ----- //

logDebug(message) => logger.finer('.. $message');

logInfo(message) => logger.fine('ℹ️ $message');

logWarning(message) => logger.warning('WARNING : $message');

logStep(message) => logger.info('ℹ️ $message');

// ----- Specialized loggers ------ //

/// Sending a file to firestore
logUpload(message) => logDebug('↗️ $message');

/// Downloading a file from firestore
logDownload(message) => logDebug('↘️️ $message');

/// Getting metadata from firebase (not a file)
logFetch(message) => logDebug('🔎 $message');

/// Sending metatada to firebase (not a file)
logUpdate(message) => logDebug('💾 $message');

logResult(String attemptName, AttemptResult result) {
  var prefix = result.value ? '✅' : '❌';
  var suffix = result.value ? 'success' : 'failed';

  logInfo('$prefix $attemptName : $suffix');
}

logDelay(String message, int start, int end) {
  logInfo('🕑 $message in ${(end - start) / 1000}s');
}

/// Class used to give more semantic meaning when returning "true" or "false"
/// to know if something went well or failed
class AttemptResult {
  bool value;

  AttemptResult(this.value);

  static AttemptResult get success => AttemptResult(true);

  static AttemptResult get fail => AttemptResult(false);
}
