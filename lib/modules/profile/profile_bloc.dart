import 'dart:async';

import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/profile/link_repository.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileState extends Equatable {
  final SingleEvent<String> route;
  final User user;
  final Settings settings;
  final bool loading;

  ProfileState({this.route, this.user, this.loading = false, this.settings})
      : super([route, user, loading, settings]);
  factory ProfileState.initial() => ProfileState();
  factory ProfileState.login() =>
      ProfileState(route: SingleEvent(Routes.login));

  ProfileState changeValue({route, user, loading, settings}) => ProfileState(
        route: route ?? this.route,
        user: user ?? this.user,
        settings: settings ?? this.settings,
        loading: loading ?? this.loading,
      );
}

class _ProfileEvent {}

class _ProfileLogOutEvent extends _ProfileEvent {}

class _SettingsChangedEvent extends _ProfileEvent {
  final Settings settings;

  _SettingsChangedEvent(this.settings);
}

class _ToggleNotificationsEvent extends _ProfileEvent {}

class _UFSCConnectedEvent extends _ProfileEvent {
  final String code;
  final String state;

  _UFSCConnectedEvent(this.code, this.state);
}

class ProfileBloc extends Bloc<_ProfileEvent, ProfileState> {
  final AuthRepository _auth = inject();
  final UserDataRepository _userData = inject();
  final LinkRepository _link = inject();
  StreamSubscription<Uri> _linksSub;
  StreamSubscription<Settings> _settingsSub;

  ProfileBloc() {
    _initUniLinks();
    _trackUserData();
  }

  @override
  ProfileState get initialState => ProfileState.initial();

  @override
  Stream<ProfileState> mapEventToState(_ProfileEvent event) async* {
    if (event is _ProfileLogOutEvent) yield* _logoutToState();
    if (event is _UFSCConnectedEvent) yield* _connectedToState(event);
    if (event is _SettingsChangedEvent) yield* _settingsChangedToState(event);
    if (event is _ToggleNotificationsEvent)
      yield* _toggleNotificationsToState();
  }

  Stream<ProfileState> _connectedToState(_UFSCConnectedEvent event) async* {}

  Stream<ProfileState> _toggleNotificationsToState() async* {
    final settings = currentState.settings;
    _userData.saveSettings(
        settings.changeValue(allowNotifications: !settings.allowNotifications));
  }

  Stream<ProfileState> _settingsChangedToState(
      _SettingsChangedEvent event) async* {
    yield currentState.changeValue(settings: event.settings);
  }

  Stream<ProfileState> _logoutToState() async* {
    await _auth.signOut();
    yield ProfileState.login();
  }

  @override
  dispose() {
    _linksSub?.cancel();
    _settingsSub?.cancel();
    super.dispose();
  }

  logOut() => dispatch(_ProfileLogOutEvent());
  void toggleNotifications(bool value) => dispatch(_ToggleNotificationsEvent());

  //TODO: refactor this
  conectUFSC() async {
    const url =
        'https://sistemas.ufsc.br/oauth2.0/authorize?client_id=minhaufsc&redirect_uri=minhaufsc://minhaufsc.setic_oauth.ufsc.br&response_type=code&state=E3ZYKC1T6H2yP4z';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _initUniLinks() async {
    _linksSub = await _link.uriLinksStream.map((Uri uri) {
      final params = uri.queryParameters;
      final code = params['code'];
      final state = params['state'];
      return _UFSCConnectedEvent(code, state);
    }).forEach(dispatch);
  }

  _trackUserData() async {
    final settingsStream = await _userData.settingsStream;
    _settingsSub = await settingsStream
        .forEach((settings) => dispatch(_SettingsChangedEvent(settings)));
  }
}
