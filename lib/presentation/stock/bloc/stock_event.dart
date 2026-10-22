part of 'stock_bloc.dart';

abstract class StockEvent {}

class StockStarted extends StockEvent {}

class StockRefreshRequested extends StockEvent {}