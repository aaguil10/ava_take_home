import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/employment/cubit/employment_cubit.dart';
import 'package:ava_take_home/features/employment/cubit/employment_state.dart';
import 'package:ava_take_home/features/employment/models/employment_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmploymentInfoPage extends StatefulWidget {
  const EmploymentInfoPage({super.key});

  @override
  State<EmploymentInfoPage> createState() => _EmploymentInfoPageState();
}

class _EmploymentInfoPageState extends State<EmploymentInfoPage> {
  static const double inputFieldHeight = 60;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _employerCtrl;
  late TextEditingController _jobTitleCtrl;
  late TextEditingController _incomeCtrl;
  late TextEditingController _addressCtrl;
  DateTime? _nextPayday;
  String _employmentType = 'Full-time';
  String _payFrequency = 'Bi-weekly';
  bool _directDeposit = true;
  int _years = 1;
  int _months = 3;

  @override
  void initState() {
    super.initState();
    final state = context.read<EmploymentCubit>().state;
    final info = state.info;
    _employerCtrl = TextEditingController(text: info.employer);
    _jobTitleCtrl = TextEditingController(text: info.jobTitle);
    _incomeCtrl = TextEditingController(text: info.grossAnnualIncome);
    _addressCtrl = TextEditingController(text: info.employerAddress);
    _nextPayday = info.nextPayday;
    _employmentType = info.employmentType.isNotEmpty
        ? info.employmentType
        : 'Full-time';
    _payFrequency = info.payFrequency.isNotEmpty
        ? info.payFrequency
        : 'Bi-weekly';
    _directDeposit = info.directDeposit;
    _years = info.timeWithEmployerYears;
    _months = info.timeWithEmployerMonths;
    // load initially
    context.read<EmploymentCubit>().load();
  }

  void _syncToCubit() {
    final updated = EmploymentInfo(
      employmentType: _employmentType,
      employer: _employerCtrl.text,
      jobTitle: _jobTitleCtrl.text,
      grossAnnualIncome: _incomeCtrl.text,
      payFrequency: _payFrequency,
      nextPayday: _nextPayday ?? DateTime.now(),
      directDeposit: _directDeposit,
      employerAddress: _addressCtrl.text,
      timeWithEmployerYears: _years,
      timeWithEmployerMonths: _months,
    );
    context.read<EmploymentCubit>().updateInfo(updated);
  }

  @override
  void dispose() {
    _employerCtrl.dispose();
    _jobTitleCtrl.dispose();
    _incomeCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: creamBackground, leading: BackButton()),
      body: BlocListener<EmploymentCubit, EmploymentState>(
        listenWhen: (previous, current) {
          return previous.info != current.info;
        },
        listener: (context, state) {
          final isEditing = state.mode == EmploymentMode.edit;

          // Skip if in edit mode to avoid overwriting
          if (isEditing) return;

          final info = state.info;
          _employerCtrl.text = info.employer;
          _jobTitleCtrl.text = info.jobTitle;
          _incomeCtrl.text = info.grossAnnualIncome;
          _addressCtrl.text = info.employerAddress;
          setState(() {
            _nextPayday = info.nextPayday;
            _employmentType = info.employmentType.isNotEmpty
                ? info.employmentType
                : 'Full-time';
            _payFrequency = info.payFrequency.isNotEmpty
                ? info.payFrequency
                : 'Bi-weekly';
            _directDeposit = info.directDeposit;
            _years = info.timeWithEmployerYears;
            _months = info.timeWithEmployerMonths;
          });
        },
        child: BlocBuilder<EmploymentCubit, EmploymentState>(
          builder: (context, state) {
            final isEditing = state.mode == EmploymentMode.edit;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  onChanged: _syncToCubit,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, state),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: 'Employment type',
                        value: _employmentType,
                        items: ['Full-time', 'Part-time', 'Contract'],
                        enabled: isEditing,
                        onChanged: (v) => setState(() => _employmentType = v),
                      ),
                      const SizedBox(height: 16),
                      // Employer
                      _buildTextField(
                        'Employer',
                        controller: _employerCtrl,
                        enabled: isEditing,
                        validator: _letterValidator,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Job title',
                        controller: _jobTitleCtrl,
                        enabled: isEditing,
                        validator: _letterValidator,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Gross annual income',
                        controller: _incomeCtrl,
                        enabled: isEditing,
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: 'Pay frequency',
                        value: _payFrequency,
                        items: ['Bi-weekly', 'Monthly'],
                        enabled: isEditing,
                        onChanged: (v) => setState(() => _payFrequency = v),
                      ),
                      const SizedBox(height: 16),
                      _buildPayday(isEditing),
                      const SizedBox(height: 16),
                      _buildDirectDepositToggle(isEditing),

                      // Direct deposit toggle
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Employer address',
                        controller: _addressCtrl,
                        enabled: isEditing,
                        maxLines: 2,
                        validator: (s) {
                          if (s == null || s.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Time with employer
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              label: 'Time with employer',
                              value: '$_years years',
                              items: List.generate(10, (i) => '$i years'),
                              enabled: isEditing,
                              onChanged: (v) => setState(
                                () => _years = int.parse(v.split(' ')[0]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              label: '',
                              value: '$_months months',
                              items: List.generate(12, (i) => '$i months'),
                              enabled: isEditing,
                              onChanged: (v) => setState(
                                () => _months = int.parse(v.split(' ')[0]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (isEditing)
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _syncToCubit();
                                context
                                    .read<EmploymentCubit>()
                                    .saveAndConfirm();
                              }
                            },
                            child: const Text('Continue'),
                          ),
                        ),
                      if (!isEditing)
                        Column(
                          children: [
                            SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 2,
                                  ),
                                  backgroundColor: creamBackground,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => context
                                    .read<EmploymentCubit>()
                                    .toggleEdit(),
                                child: Text(
                                  'Edit',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  context.pop(true);
                                },
                                child: Text(
                                  'Confirm',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _letterValidator(s) {
    if (s == null || s.trim().isEmpty) return 'Required';
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(s.trim())) {
      return 'Must be letters and spaces only';
    }
    return null;
  }

  String? _numberValidator(s) {
    if (s == null || s.trim().isEmpty) return 'Required';
    if (!RegExp(r'^\d+$').hasMatch(s.trim())) {
      return 'Must be numbers only';
    }
    return null;
  }

  Widget _buildHeader(BuildContext context, EmploymentState state) {
    return state.mode == EmploymentMode.edit
        ? Text(
            'Edit employment information',
            style: Theme.of(context).textTheme.headlineLarge,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm your employment',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 4),
              Text(
                'Please review and confirm the below  employment details are up-to-date.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          );
  }

  Widget _buildFieldLabel(String label, bool enabled) {
    return Text(
      label,
      style: enabled
          ? Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
          : Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildFieldValue(String value) {
    return Text(
      value,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(color: textPrimaryDark),
    );
  }

  InputDecoration inputDecoration() => InputDecoration(
    // reserve one line for error message
    helperText: ' ',
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black.withAlpha(15)),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black.withAlpha(15)),
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
  );

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required bool enabled,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label, enabled),
        const SizedBox(height: 4),
        enabled
            ? SizedBox(
                height: inputFieldHeight,
                child: InputDecorator(
                  decoration: inputDecoration(),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      iconSize: 24,
                      onChanged: enabled ? (v) => onChanged(v!) : null,
                      items: items
                          .map(
                            (i) => DropdownMenuItem(
                              value: i,
                              child: Text(
                                i,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              )
            : _buildFieldValue(value),
      ],
    );
  }

  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    bool enabled = true,
    int maxLines = 1,
    String? Function(String?)? validator = null,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label, enabled),
        const SizedBox(height: 4),
        enabled
            ? SizedBox(
                height: inputFieldHeight,
                child: TextFormField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: maxLines,
                  decoration: inputDecoration(),
                  validator: validator,
                ),
              )
            : _buildFieldValue(controller.text),
      ],
    );
  }

  Widget _buildPayday(bool isEditing) {
    return GestureDetector(
      onTap: isEditing
          ? () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _nextPayday ?? DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _nextPayday = picked);
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('My next payday is', isEditing),
          const SizedBox(height: 4),
          isEditing
              ? SizedBox(
                  height: inputFieldHeight,
                  child: TextField(
                    controller: TextEditingController(
                      text: _nextPayday != null
                          ? _formatDate(_nextPayday!)
                          : '',
                    ),
                    enabled: false,
                    maxLines: 1,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: textPrimaryDark),
                    decoration: inputDecoration().copyWith(
                      suffixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                )
              : _buildFieldValue(
                  _nextPayday != null ? _formatDate(_nextPayday!) : '',
                ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final monthNames = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sept',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };

    String ordinal(int day) {
      if (day >= 11 && day <= 13) return '${day}th';
      switch (day % 10) {
        case 1:
          return '${day}st';
        case 2:
          return '${day}nd';
        case 3:
          return '${day}rd';
        default:
          return '${day}th';
      }
    }

    final month = monthNames[dt.month] ?? dt.month.toString();
    final dayWithSuffix = ordinal(dt.day);
    final year = dt.year;
    final weekday = _weekdayName(dt.weekday);
    return '$month $dayWithSuffix, $year ($weekday)';
  }

  String _weekdayName(int weekday) {
    const names = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    return names[weekday] ?? '';
  }

  Widget _buildDirectDepositToggle(bool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Is your pay a direct deposit?', isEditing),
        SizedBox(height: 16),
        isEditing
            ? Row(
                children: [
                  ChoiceChip(
                    label: const Text('Yes'),
                    selected: _directDeposit,
                    onSelected: isEditing
                        ? (s) => setState(() => _directDeposit = true)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('No'),
                    selected: !_directDeposit,
                    onSelected: isEditing
                        ? (s) => setState(() => _directDeposit = false)
                        : null,
                  ),
                ],
              )
            : _buildFieldValue(_directDeposit ? 'Yes' : 'No'),
      ],
    );
  }
}
