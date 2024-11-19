part of 'preferences_bloc.dart';

@immutable
class PreferencesState {
  final UserModel? user;
  final bool isDarkMode;
  final String token;

  const PreferencesState({
    this.user,
    this.isDarkMode = false,
    this.token = '',
  });
  // final bool isLoading;
  // final UserModel? user;
  // final String token;

  // PreferencesState({
  //   required this.isDarkMode,
  //   this.user,
  //   this.token = '',
  //   this.isLoading = false,
  // });
  // PreferencesState copyWith({
  //   bool? isDarkMode,
  //   bool? isLoading,
  //   String? token,
  //   UserModel? user,
  // }) {
  //   return PreferencesState(
  //     isDarkMode: isDarkMode ?? this.isDarkMode,
  //     isLoading: isLoading ?? this.isLoading,
  //     token: token ?? this.token,
  //     user: user ?? this.user,
  //   );
  // }
}

final class PreferencesInitial extends PreferencesState {
  const PreferencesInitial({UserModel? user, bool? isDarkMode}) : super(user: user);
}

final class PrefTokenState extends PreferencesState {
  final String token;
  const PrefTokenState({
    required this.token,
    UserModel? user,
  }) : super(user: user);
}

final class PrefUserState extends PreferencesState {
  const PrefUserState({UserModel? user}) : super(user: user);
}

final class PrefDarkModeState extends PreferencesState {
  const PrefDarkModeState({required super.isDarkMode});
}

final class PrefLoadingState extends PreferencesState {}

// final class PrefErrorState extends PreferencesState {
//   final String errorMessage;
//   const PrefErrorState({
//     required this.errorMessage,
//     UserModel? user,
//   }) : super(user: user);
// }
