import 'package:active_fit/core/presentation/widgets/info_dialog.dart';
import 'package:active_fit/features/onboarding/domain/entity/user_activity_selection_entity.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:flutter/material.dart';


class OnboardingThirdPageBody extends StatefulWidget {
  final Function(bool active, UserActivitySelectionEntity? selectedActivity)
      setButtonContent;

  const OnboardingThirdPageBody({super.key, required this.setButtonContent});

  @override
  State<OnboardingThirdPageBody> createState() =>
      _OnboardingThirdPageBodyState();
}

class _OnboardingThirdPageBodyState extends State<OnboardingThirdPageBody> {
  bool _sedentarySelected = false;
  bool _lowActiveSelected = false;
  bool _activeSelected = false;
  bool _veryActiveSelected = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.of(context).activityLabel,
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.of(context).onboardingActivityQuestionSubtitle,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 40.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                      label: Text(S.of(context).palSedentaryLabel,
                          style: Theme.of(context).textTheme.titleLarge),
                      selected: _sedentarySelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _setSelectedChoiceChip(sedentary: true);
                          checkCorrectInput();
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => InfoDialog(
                                    title: S.of(context).palSedentaryLabel,
                                    body: S
                                        .of(context)
                                        .palSedentaryDescriptionLabel));
                          },
                          child: const Icon(Icons.help_outline_outlined)),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: 400,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                      label: Text(S.of(context).palLowLActiveLabel,
                          style: Theme.of(context).textTheme.titleLarge),
                      selected: _lowActiveSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _setSelectedChoiceChip(lowActive: true);
                          checkCorrectInput();
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => InfoDialog(
                                    title: S.of(context).palLowLActiveLabel,
                                    body: S
                                        .of(context)
                                        .palLowActiveDescriptionLabel));
                          },
                          child: const Icon(Icons.help_outline_outlined)),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: 340,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 35,
                    ),
                    ChoiceChip(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                      label: Text(S.of(context).palActiveLabel,
                          style: Theme.of(context).textTheme.titleLarge),
                      selected: _activeSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _setSelectedChoiceChip(active: true);
                          checkCorrectInput();
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => InfoDialog(
                                    title: S.of(context).palActiveLabel,
                                    body: S
                                        .of(context)
                                        .palActiveDescriptionLabel));
                          },
                          child: const Icon(Icons.help_outline_outlined)),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  label: Text(S.of(context).palVeryActiveLabel,
                      style: Theme.of(context).textTheme.titleLarge),
                  selected: _veryActiveSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      _setSelectedChoiceChip(veryActive: true);
                      checkCorrectInput();
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => InfoDialog(
                                title: S.of(context).palVeryActiveLabel,
                                body: S
                                    .of(context)
                                    .palVeryActiveDescriptionLabel));
                      },
                      child: const Icon(Icons.help_outline_outlined)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _setSelectedChoiceChip(
      {sedentary = false,
      lowActive = false,
      active = false,
      veryActive = false}) {
    _sedentarySelected = sedentary;
    _lowActiveSelected = lowActive;
    _activeSelected = active;
    _veryActiveSelected = veryActive;
  }

  void checkCorrectInput() {
    UserActivitySelectionEntity? selectedActivity;
    if (_sedentarySelected) {
      selectedActivity = UserActivitySelectionEntity.sedentary;
    } else if (_lowActiveSelected) {
      selectedActivity = UserActivitySelectionEntity.lowActive;
    } else if (_activeSelected) {
      selectedActivity = UserActivitySelectionEntity.active;
    } else if (_veryActiveSelected) {
      selectedActivity = UserActivitySelectionEntity.veryActive;
    }

    if (selectedActivity != null) {
      widget.setButtonContent(true, selectedActivity);
    } else {
      widget.setButtonContent(false, null);
    }
  }
}
