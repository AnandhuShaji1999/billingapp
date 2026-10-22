part of 'collection_bloc.dart';

abstract class CollectionEvent {}

// ============================================================================
// START
// ============================================================================

class CollectionStarted
    extends CollectionEvent {}

// ============================================================================
// TODAY
// ============================================================================

class CollectionTodayRequested
    extends CollectionEvent {}

// ============================================================================
// DATE
// ============================================================================

class CollectionDateSelected
    extends CollectionEvent {
  final DateTime date;

  CollectionDateSelected(
      this.date,
      );
}

// ============================================================================
// MONTH
// ============================================================================

class CollectionMonthSelected
    extends CollectionEvent {
  final DateTime month;

  CollectionMonthSelected(
      this.month,
      );
}