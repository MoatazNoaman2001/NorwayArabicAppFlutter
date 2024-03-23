part of 'details_bloc.dart';

@immutable
sealed class DetailsState {}

final class DetailsInitial extends DetailsState {}


final class DetailsLoading extends DetailsState {}
final class DetailsSuccess extends DetailsState {
  final NorwayNew norwayNew;
  DetailsSuccess(this.norwayNew);
}
final class DetailsFailure extends DetailsState {
  final String msg;
  DetailsFailure(this.msg);
}
