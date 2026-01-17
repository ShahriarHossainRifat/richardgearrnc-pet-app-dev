/// Session management module.
///
/// Provides:
/// - [SessionState] - Sealed class representing session status
/// - [SessionService] - Service for session operations
/// - [sessionStateProvider] - Reactive session state
/// - [isAuthenticatedProvider] - Simple auth check
library;

import 'package:riverpod_go_router_boilerplate/core/core.dart'
    show SessionService, SessionState;
import 'package:riverpod_go_router_boilerplate/core/session/session.dart'
    show SessionService, SessionState;

export 'session_service.dart';
export 'session_state.dart';
