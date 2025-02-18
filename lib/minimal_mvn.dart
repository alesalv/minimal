import 'minimal_mvn.dart';

/// A minimal state management package for Flutter
///
/// This package provides a simple and efficient way to manage state in Flutter
/// applications using the MVN (Model-View-Notifier) pattern.
///
/// The main components are:
/// * [MMHydrator] - Minimal hydrator for initializing notifiers
/// * [MMState] - Minimal state for all immutable states
/// * [MMNotifier] - Minimal notifier for all notifiers that manage state
/// * [MMManager] - Minimal manager for accessing notifiers
/// * [MMLocator] - Minimal locator for accessing repositories and services


export 'src/mm_hydrator.dart';
export 'src/mm_locator.dart';
export 'src/mm_manager.dart';
export 'src/mm_notifier.dart';
export 'src/mm_state.dart';

