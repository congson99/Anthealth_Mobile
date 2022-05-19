import 'package:anthealth_mobile/blocs/app_states.dart';
import 'package:anthealth_mobile/blocs/dashbord/dashboard_cubit.dart';
import 'package:anthealth_mobile/blocs/dashbord/dashboard_states.dart';
import 'package:anthealth_mobile/generated/l10n.dart';
import 'package:anthealth_mobile/logics/medicine_logic.dart';
import 'package:anthealth_mobile/models/medic/medical_record_models.dart';
import 'package:anthealth_mobile/models/medic/medication_reminder_models.dart';
import 'package:anthealth_mobile/models/user/user_models.dart';
import 'package:anthealth_mobile/views/common_pages/error_page.dart';
import 'package:anthealth_mobile/views/common_pages/template_dashboard_page.dart';
import 'package:anthealth_mobile/views/common_widgets/custom_divider.dart';
import 'package:anthealth_mobile/views/common_widgets/section_component.dart';
import 'package:anthealth_mobile/views/settings/setting_page.dart';
import 'package:anthealth_mobile/views/theme/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.user, required this.languageID})
      : super(key: key);

  final User user;
  final String languageID;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DashboardCubit, CubitState>(builder: (context, state) {
        if (state is HomeState)
          return TemplateDashboardPage(
              title: S.of(context).Hi,
              name: user.name,
              setting: () => setting(context),
              content: buildContent(context, state));
        return ErrorPage();
      });

  Widget buildContent(BuildContext context, HomeState state) {
    return Column(children: [
      CustomDivider.common(),
      SizedBox(height: 16),
      buildSections(context),
      SizedBox(height: 32),
      CustomDivider.common(),
      SizedBox(height: 16),
      buildUpcoming(context, state),
    ]);
  }

  Widget buildSections(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      CommonText.section(S.of(context).How_are_you_today, context),
      SizedBox(height: 16),
      SectionComponent(
          iconPath: "assets/app_icon/common/diagnosis_pri0.png",
          title: S.of(context).Smart_diagnosis,
          colorID: 0),
      SizedBox(height: 16),
      SectionComponent(
          iconPath: "assets/app_icon/common/doctor_sec0.png",
          title: S.of(context).Connect_doctor,
          colorID: 1)
    ]);
  }

  Widget buildUpcoming(BuildContext context, HomeState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      CommonText.section(S.of(context).Upcoming_events, context),
      SizedBox(height: 16),
      ...state.events.map((event) => buildEvent(context, event)),
    ]);
  }

  Widget buildEvent(BuildContext context, dynamic event) {
    if (event.runtimeType == MedicalAppointment)
      return buildEventComponent(context, medicalAppointment: event);
    else
      return buildEventComponent(context, reminderMask: event);
  }

  Widget buildEventComponent(BuildContext context,
      {MedicalAppointment? medicalAppointment, ReminderMask? reminderMask}) {
    if (medicalAppointment != null)
      return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SectionComponent(
              title:
                  DateFormat("dd.MM.yyyy").format(medicalAppointment.dateTime) +
                      ' - ' +
                      medicalAppointment.location,
              subTitle: S.of(context).Previous_medical_record +
                  ": " +
                  DateFormat("dd.MM.yyyy").format(medicalAppointment.lastTime),
              subSubTitle:
                  S.of(context).Content + ": " + medicalAppointment.name,
              onTap: () {
                //Todo
              },
              isDirection: false,
              colorID: 1));
    else
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: SectionComponent(
            title: DateFormat("HH:mm").format(reminderMask!.time) +
                " - " +
                MedicineLogic.getUsage(
                    context, reminderMask.medicine.getUsage()) +
                " " +
                MedicineLogic.handleQuantity(reminderMask.quantity) +
                " " +
                MedicineLogic.getUnit(context, reminderMask.medicine.getUnit()),
            subTitle: reminderMask.medicine.getName(),
            isDirection: false,
            colorID: 0,
            onTap: () {}),
      );
  }

  /// Actions
  void setting(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            SettingsPage(appContext: context, languageID: languageID)));
  }
}
