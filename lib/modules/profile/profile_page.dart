import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/modules/profile/profile_state.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:app_tcc/utils/widgets/loading_wrapper.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static instantiate() => ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc _profileBloc = inject();

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _profileBloc,
      builder: (context, ProfileState state) => RoutingWrapper(
          route: state.route?.value,
          child: Scaffold(
              appBar: AppBar(
                title: Text(Strings.profile),
              ),
              body: LoadingWrapper(
                isLoading: state.loading,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(state.user?.email ?? ""),
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text(Strings.exit),
                      onTap: _profileBloc.logOut,
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        Strings.config,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.school),
                      title: Text(Strings.connectUfsc),
                      onTap: Routes.toConnectUfsc(context),
                    ),
                    SwitchListTile(
                      title: Text(Strings.notifications),
                      value: state.settings?.allowNotifications ?? false,
                      onChanged: _profileBloc.toggleNotifications,
                    ),
                  ],
                ),
              ))));

  @override
  void dispose() {
    _profileBloc?.dispose();
    super.dispose();
  }
}
