import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Khởi tạo BLoC, truyền vào startDate
class HomeInitialized extends HomeEvent {
  final DateTime startDate;

  const HomeInitialized(this.startDate);

  @override
  List<Object?> get props => [startDate];
}

/// Tim nhịp đập
class HeartbeatTicked extends HomeEvent {}

/// Thay đổi màu tim
class HeartColorChanged extends HomeEvent {}

/// Cập nhật thời gian hiện tại
class TimeUpdated extends HomeEvent {
  final String currentTime;

  const TimeUpdated(this.currentTime);

  @override
  List<Object?> get props => [currentTime];
}

/// Người dùng chuyển trang PageView
class PageChanged extends HomeEvent {
  final int page;

  const PageChanged(this.page);

  @override
  List<Object?> get props => [page];
}

/// Người dùng chọn ngày sinh
class BirthDatePicked extends HomeEvent {
  final bool isMe;
  final DateTime date;

  const BirthDatePicked(this.isMe, this.date);

  @override
  List<Object?> get props => [isMe, date];
}
