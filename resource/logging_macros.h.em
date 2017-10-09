// generated from rcutils/resource/logging_macros.h.em

// Copyright 2017 Open Source Robotics Foundation, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/*! \file */

#ifndef RCUTILS__LOGGING_MACROS_H_
#define RCUTILS__LOGGING_MACROS_H_

#include "rcutils/logging.h"

#include <stdio.h>
#include <stdlib.h>

#if __cplusplus
extern "C"
{
#endif

/**
 * \def RCUTILS_LOG_MIN_SEVERITY
 * Define RCUTILS_LOG_MIN_SEVERITY=RCUTILS_LOG_SEVERITY_[DEBUG|INFO|WARN|ERROR|FATAL]
 * in your build options to compile out anything below that severity.
 */
#ifndef RCUTILS_LOG_MIN_SEVERITY
#define RCUTILS_LOG_MIN_SEVERITY RCUTILS_LOG_SEVERITY_DEBUG
#endif

/**
 * \def RCUTILS_LOG_COND_NAMED
 * The logging macro all other logging macros call directly or indirectly.
 * \param severity The severity level
 * \param condition_before The condition macro(s) inserted before the log call
 * \param condition_after The condition macro(s) inserted after the log call
 * \param name The name of the logger
 * \param ... The format string, followed by the variable arguments for the format string
 * // TODO(dhood): optimise severity check via notifyLoggerLevelsChanged concept or similar.
 */
#define RCUTILS_LOG_COND_NAMED(severity, condition_before, condition_after, name, ...) \
  { \
    RCUTILS_LOGGING_AUTOINIT \
    static rcutils_log_location_t __rcutils_logging_location = {__func__, __FILE__, __LINE__}; \
    condition_before \
    if (rcutils_logging_is_enabled_for(name, severity)) { \
      rcutils_log(&__rcutils_logging_location, severity, name, __VA_ARGS__); \
    } \
    condition_after \
  }

///@@{
/**
 * \def RCUTILS_LOG_CONDITION_EMPTY
 * An empty macro which can be used as a placeholder for `condition_before`
 * and `condition_after` which doesn't affect the logging call.
 */
#define RCUTILS_LOG_CONDITION_EMPTY
///@@}

/** @@name Macros for the `once` condition which ignores all subsequent log
 * calls except the first one.
 */
///@@{
/**
 * \def RCUTILS_LOG_CONDITION_ONCE_BEFORE
 * A macro initializing and checking the `once` condition.
 */
#define RCUTILS_LOG_CONDITION_ONCE_BEFORE \
  { \
    static int __rcutils_logging_once = 0; \
    if (RCUTILS_UNLIKELY(0 == __rcutils_logging_once)) { \
      __rcutils_logging_once = 1;
/**
 * \def RCUTILS_LOG_CONDITION_ONCE_AFTER
 * A macro finalizing the `once` condition.
 */
#define RCUTILS_LOG_CONDITION_ONCE_AFTER } \
  }
///@@}

/** @@name Macros for the `expression` condition which ignores the log calls
 * when the expression evaluates to false.
 */
///@@{
/**
 * \def RCUTILS_LOG_CONDITION_EXPRESSION_BEFORE
 * A macro checking the `expression` condition.
 */
#define RCUTILS_LOG_CONDITION_EXPRESSION_BEFORE(expression) \
  if (expression) {
/**
 * \def RCUTILS_LOG_CONDITION_EXPRESSION_AFTER
 * A macro finalizing the `expression` condition.
 */
#define RCUTILS_LOG_CONDITION_EXPRESSION_AFTER }
///@@}

/** @@name Macros for the `function` condition which ignores the log calls
 * when the function returns false.
 */
///@@{
/// The filter function signature.
/**
 * \return true to log the message, false to ignore the message
 */
typedef bool (* RclLogFilter)();
/**
 * \def RCUTILS_LOG_CONDITION_FUNCTION_BEFORE
 * A macro checking the `function` condition.
 */
#define RCUTILS_LOG_CONDITION_FUNCTION_BEFORE(function) \
  if ((*function)()) {
/**
 * \def RCUTILS_LOG_CONDITION_FUNCTION_AFTER
 * A macro finalizing the `function` condition.
 */
#define RCUTILS_LOG_CONDITION_FUNCTION_AFTER }
///@@}

/** @@name Macros for the `skipfirst` condition which ignores the first log
 * call but processes all subsequent calls.
 */
///@@{
/**
 * \def RCUTILS_LOG_CONDITION_SKIPFIRST_BEFORE
 * A macro initializing and checking the `skipfirst` condition.
 */
#define RCUTILS_LOG_CONDITION_SKIPFIRST_BEFORE \
  { \
    static bool __rcutils_logging_first = true; \
    if (RCUTILS_UNLIKELY(true == __rcutils_logging_first)) { \
      __rcutils_logging_first = false; \
    } else {
/**
 * \def RCUTILS_LOG_CONDITION_SKIPFIRST_AFTER
 * A macro finalizing the `skipfirst` condition.
 */
#define RCUTILS_LOG_CONDITION_SKIPFIRST_AFTER } \
  }
///@@}

/** @@name Macros for the `throttle` condition which ignores log calls if the
 * last logged message is not longer ago than the specified duration.
 */
///@@{
/**
 * \def RCUTILS_LOG_CONDITION_THROTTLE_BEFORE
 * A macro initializing and checking the `throttle` condition.
 */
#define RCUTILS_LOG_CONDITION_THROTTLE_BEFORE(time_source_type, duration) { \
    static rcutils_duration_value_t __rcutils_logging_duration = RCUTILS_MS_TO_NS((rcutils_duration_value_t)duration); \
    static rcutils_time_point_value_t __rcutils_logging_last_logged = 0; \
    rcutils_time_point_value_t __rcutils_logging_now = 0; \
    bool __rcutils_logging_condition = true; \
    if (rcutils_steady_time_now(&__rcutils_logging_now) != RCUTILS_RET_OK) { \
      rcutils_log( \
        &__rcutils_logging_location, RCUTILS_LOG_SEVERITY_ERROR, "", \
        "%s() at %s:%d getting current steady time failed\n", \
        __func__, __FILE__, __LINE__); \
    } else { \
      __rcutils_logging_condition = __rcutils_logging_now >= __rcutils_logging_last_logged + __rcutils_logging_duration; \
    } \
 \
    if (RCUTILS_LIKELY(__rcutils_logging_condition)) { \
      __rcutils_logging_last_logged = __rcutils_logging_now;

/**
 * \def RCUTILS_LOG_CONDITION_THROTTLE_AFTER
 * A macro finalizing the `throttle` condition.
 */
#define RCUTILS_LOG_CONDITION_THROTTLE_AFTER } \
  }
///@@}

@{
import sys
sys.path.insert(0, rcutils_module_path)
from rcutils.logging import feature_combinations
from rcutils.logging import get_macro_arguments
from rcutils.logging import get_macro_parameters
from rcutils.logging import severities
}@
@[for severity in severities]@
/** @@name Logging macros for severity @(severity).
 */
///@@{
#if (RCUTILS_LOG_MIN_SEVERITY > RCUTILS_LOG_SEVERITY_@(severity))
// empty logging macros for severity @(severity) when being disabled at compile time
@[ for suffix in feature_combinations]@
/// Empty logging macro due to the preprocessor definition of RCUTILS_LOG_MIN_SEVERITY.
# define RCUTILS_LOG_@(severity)@(suffix)(@(''.join([p + ', ' for p in get_macro_parameters(suffix).keys()]))format, ...)
@[ end for]@

#else
@[ for suffix in feature_combinations]@
/**
 * \def RCUTILS_LOG_@(severity)@(suffix)
 * Log a message with severity @(severity)@
@[ if feature_combinations[suffix].doc_lines]@
 with the following conditions:
@[ else]@
.
@[ end if]@
@[ for doc_line in feature_combinations[suffix].doc_lines]@
 * @(doc_line)
@[ end for]@
@[ for param_name, doc_line in feature_combinations[suffix].params.items()]@
 * \param @(param_name) @(doc_line)
@[ end for]@
 * \param ... The format string, followed by the variable arguments for the format string
 */
# define RCUTILS_LOG_@(severity)@(suffix)(@(''.join([p + ', ' for p in get_macro_parameters(suffix).keys()]))...) \
  RCUTILS_LOG_COND_NAMED( \
    RCUTILS_LOG_SEVERITY_@(severity), \
    @(''.join([str(a) + ', ' for a in get_macro_arguments(suffix)]))\
    __VA_ARGS__)
@[ end for]@
#endif
///@@}

@[end for]@
#if __cplusplus
}
#endif

#endif  // RCUTILS__LOGGING_MACROS_H_
