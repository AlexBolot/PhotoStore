/*..............................................................................
 . Copyright (c)
 .
 . The logging_service.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/10/21 9:59 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:logging/logging.dart';

Logger logger = Logger('Photo Store');

logDebug(message) => logger.fine(message);

logStep(message) => logger.info(message);

logResult(String attemptName, AttemptResult result) {
  logger.fine('$attemptName : ${result.value ? 'success' : 'failed'}');
}

/// Class used to give more semantic meaning when returning "true" or "false"
/// to know if something went well or failed
class AttemptResult {
  bool value;

  AttemptResult(this.value);

  static get success => AttemptResult(true);

  static get fail => AttemptResult(false);
}
