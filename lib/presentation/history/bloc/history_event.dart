part of 'history_bloc.dart';

abstract class HistoryEvent {}

class HistoryStarted extends HistoryEvent {}

class HistoryTodayRequested extends HistoryEvent {}

class HistoryDateSelected extends HistoryEvent {
  final DateTime date;

  HistoryDateSelected(this.date);
}

class HistoryMonthSelected extends HistoryEvent {
  final DateTime month;

  HistoryMonthSelected(this.month);
}