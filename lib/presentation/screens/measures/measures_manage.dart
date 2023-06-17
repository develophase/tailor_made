import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/measures_slide_block.dart';

class MeasuresManagePage extends StatefulWidget {
  const MeasuresManagePage({super.key, required this.userId});

  final String userId;

  @override
  State<MeasuresManagePage> createState() => _MeasuresManagePageState();
}

class _MeasuresManagePageState extends State<MeasuresManagePage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(
      const Duration(seconds: 2),
      () => AppSnackBar.of(context).info('Long-Press on any group to see more actions.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: Text('Measurements')),
      body: _buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        backgroundColor: kAccentColor,
        foregroundColor: Colors.white,
        label: const Text('Add Group'),
        onPressed: () => context.registry.get<MeasuresCoordinator>().toCreateMeasures(widget.userId),
      ),
    );
  }

  Widget _buildBody() {
    return ViewModelSubscriber<AppState, MeasuresViewModel>(
      converter: MeasuresViewModel.new,
      builder: (_, __, MeasuresViewModel vm) {
        if (vm.isLoading) {
          return const Center(child: LoadingSpinner());
        }

        if (vm.model == null || vm.model!.isEmpty) {
          return const Center(child: EmptyResultView(message: 'No measurements available'));
        }

        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (int i = 0; i < vm.grouped!.length; i++)
                  MeasureSlideBlock(
                    title: vm.grouped!.keys.elementAt(i),
                    measures: vm.grouped!.values.elementAt(i),
                    userId: vm.userId,
                  ),
                const SizedBox(height: 72.0)
              ],
            ),
          ),
        );
      },
    );
  }
}
