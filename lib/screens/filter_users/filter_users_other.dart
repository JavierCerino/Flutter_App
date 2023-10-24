import 'package:flutter/material.dart';
import '../../models/user/query_likes_user.dart';
import '../../widgets/drawer.dart';
import '../user_list.dart';

class FilterUsersOthers extends StatefulWidget {
  final UserPreferencesDTO userPreferences;

  FilterUsersOthers({
    Key? key,
    required this.userPreferences,
  }) : super(key: key);

  @override
  _FilterUsersOthersState createState() => _FilterUsersOthersState();
}

class _FilterUsersOthersState extends State<FilterUsersOthers> with RestorationMixin {

  final RestorableTextEditingController petController = RestorableTextEditingController();
  final RestorableTextEditingController introvertedController = RestorableTextEditingController();
  final RestorableTextEditingController cleaningController = RestorableTextEditingController();
  final RestorableTextEditingController vapeController = RestorableTextEditingController();
  final RestorableTextEditingController smokeController = RestorableTextEditingController();
  final RestorableTextEditingController workFromHomeController = RestorableTextEditingController();
  final RestorableTextEditingController sleepTimeController = RestorableTextEditingController();
  final RestorableTextEditingController externalPeopleController = RestorableTextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E5EAA),
        title: const Text(
          "Search Roommate",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButton(text: 'Location', onPressed: () {}),
                  const SizedBox(width: 10),
                  RoundedButton(text: 'Information', onPressed: () {}),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'You have any problem having pets at the house?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckboxGroup(
                    labels: const ['Yes', 'No'],
                    controller: petController.value,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'You want your roomie to be introverted or extroverted?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckboxGroup(
                    labels: const ['Introvert', 'Extrovert'],
                    controller: introvertedController.value,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'How often do you clean your house?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CleaningFrequencySlider(controller: cleaningController.value),
              const SizedBox(height: 16),
              const Text(
                'Do you Vape?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckboxGroup(
                    labels: const ['Yes', 'No'],
                    controller: vapeController.value,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Do you smoke?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckboxGroup(
                    labels: ['Yes', 'No'],
                    controller: smokeController.value,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Do you work from home?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckboxGroup(
                    labels: ['Yes', 'No'],
                    controller: workFromHomeController.value,
                  ),
                ],
              ),
              const Text(
                'At what time do you go to sleep?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SleepHourFrequencySlider(controller: sleepTimeController.value),
              const Text(
                'How many times will you bring people a week?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FrequencyOfExternalPeople(
                controller: externalPeopleController.value,
              ),
              ElevatedButton(
                onPressed: () {
                  String pet = petController.value.text;
                  String introverted=  introvertedController.value.text;
                  String cleaning= cleaningController.value.text;
                  String vape=  vapeController.value.text;
                  String smoke= smokeController.value.text;
                  String work=  workFromHomeController.value.text;
                  String sleep=  sleepTimeController.value.text;
                  String external=  externalPeopleController.value.text;
                  widget.userPreferences.petPreference = pet == "Yes"
                      ? true
                      : pet == "No"
                      ? false
                      : null;

                  if (introverted.isEmpty) {
                    widget.userPreferences.introvertedPreference = null;
                  } else {
                    widget.userPreferences.introvertedPreference = introverted;
                  }
                  if (cleaning.isEmpty) {
                    widget.userPreferences.cleaningFrequency = null;
                  } else {
                    widget.userPreferences.cleaningFrequency = cleaning;
                  }

                  widget.userPreferences.vapePreference = vape == "Yes"
                      ? true
                      : vape == "No"
                      ? false
                      : null;
                  widget.userPreferences.smokePreference = smoke == "Yes"
                      ? true
                      : smoke == "No"
                      ? false
                      : null;
                  widget.userPreferences.workFromHomePreference = (work == "Yes"
                      ? true
                      : work == "No"
                      ? false
                      : null);

                  List<String> parts = sleep.split(":");
                  widget.userPreferences.sleepTime = int.tryParse(parts[0]);
                  if (external.isEmpty) {
                    widget.userPreferences.externalPeopleFrequency = null;
                  } else {
                    widget.userPreferences.externalPeopleFrequency = external;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserList(userPreferences: widget.userPreferences)),
                  );
                },
                child: Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  String? get restorationId => "filter_users_other";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(petController, "pet");
    registerForRestoration(introvertedController, "introverted");
    registerForRestoration(cleaningController, "clean");
    registerForRestoration(vapeController, "vape");
    registerForRestoration(smokeController, "smoke");
    registerForRestoration(workFromHomeController, "from_home");
    registerForRestoration(sleepTimeController, "sleep");
    registerForRestoration(externalPeopleController, "externalPeople");

  }
}

class CheckboxGroup extends StatefulWidget {
  final List<String> labels;
  final TextEditingController controller;

  CheckboxGroup({
    required this.labels,
    required this.controller,
  });

  @override
  _CheckboxGroupState createState() =>
      _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  String? _selectedLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: widget.labels
              .map(
                (label) => ExclusiveCheckbox(
              label: label,
              isSelected: label == _selectedLabel,
              onSelect: () {
                setState(() {
                  if (label == _selectedLabel) {
                    _selectedLabel = null;
                    widget.controller.text = '';
                  } else {
                    _selectedLabel = label;
                    widget.controller.text = label;
                  }
                });
              },
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}

class ExclusiveCheckbox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelect;

  ExclusiveCheckbox({
    required this.label,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (value) {
            onSelect();
          },
        ),
        Text(label),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  RoundedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF2c595b),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}

class CleaningFrequencySlider extends StatefulWidget {
  final TextEditingController controller;

  CleaningFrequencySlider({required this.controller});

  @override
  _CleaningFrequencySliderState createState() =>
      _CleaningFrequencySliderState();
}

class _CleaningFrequencySliderState extends State<CleaningFrequencySlider> {
  int _value = 0;

  List<String> frequencyTitles = ['No aplica','Once a week', 'Twice a week', 'Three times a week'];

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        overlayColor: Colors.white.withOpacity(0.4),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      child: Slider(
        value: _value.toDouble(),
        onChanged: (newValue) {
          setState(() {
            _value = newValue.round();
            widget.controller.text = frequencyTitles[_value];
          });
        },
        min: 0,
        max: frequencyTitles.length - 1,
        divisions: frequencyTitles.length - 1,
        label: frequencyTitles[_value],
      ),
    );
  }
}

class SleepHourFrequencySlider extends StatefulWidget {
  final TextEditingController controller;

  SleepHourFrequencySlider({required this.controller});

  @override
  _SleepHourFrequencySlider createState() => _SleepHourFrequencySlider();
}

class _SleepHourFrequencySlider extends State<SleepHourFrequencySlider> {
  int _value = 0; // Valor inicial

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        overlayColor: Colors.white.withOpacity(0.4),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      child: Slider(
        value: _value.toDouble(),
        onChanged: (newValue) {
          setState(() {
            _value = newValue.round();
            if (_value == 0) {
              widget.controller.text = 'No aplica';
            } else {
              widget.controller.text = '$_value:00';
            }
          });
        },
        min: 0,
        max: 24,
        divisions: 24,
        label: _value == 0 ? 'No aplica' : '$_value:00',
      ),
    );
  }
}

class FrequencyOfExternalPeople extends StatefulWidget {
  final TextEditingController controller;

  FrequencyOfExternalPeople({required this.controller});

  @override
  _FrequencyOfExternalPeople createState() => _FrequencyOfExternalPeople();
}

class _FrequencyOfExternalPeople extends State<FrequencyOfExternalPeople> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        overlayColor: Colors.white.withOpacity(0.4),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      child: Slider(
        value: _value.toDouble(),
        onChanged: (newValue) {
          setState(() {
            _value = newValue.round();
            if (_value == 0) {
              widget.controller.text = 'No aplica';
            } else {
              widget.controller.text = _value == 1
                  ? 'Once a week'
                  : _value == 2
                  ? 'Twice a week'
                  : 'Three times a week';
            }
          });
        },
        min: 0,
        max: 3,
        divisions: 3,
        label: _value == 0 ? 'No aplica' : _value == 1
            ? 'Once a week'
            : _value == 2
            ? 'Twice a week'
            : 'Three times a week',
      ),
    );
  }
}

