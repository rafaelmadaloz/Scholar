import 'package:app_tcc/modules/home/submodules/subjects/subjects_bloc.dart';
import 'package:app_tcc/modules/home/submodules/subjects/subjects_state.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'subject_item.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  final SubjectsBloc _subjectsBloc = inject();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _subjectsBloc,
        builder: (context, SubjectsState state) {
          if (state.subjects == null) return Container();
          return ExpansionTile(
            initiallyExpanded: false,
            title: Text(Strings.absenceControl),
            children: <Widget>[
              for (final subject in state.subjects)
                SubjectItem(
                  onAdd: () => _subjectsBloc.dispatchAddAbsenceEvent(subject),
                  onRemove: () =>
                      _subjectsBloc.dispatchRemoveAbsenceEvent(subject),
                  subject: subject,
                ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _subjectsBloc.dispose();
    super.dispose();
  }
}
