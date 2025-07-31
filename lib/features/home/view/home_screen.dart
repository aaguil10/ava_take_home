import 'package:ava_take_home/features/home/cubit/home_cubit.dart';
import 'package:ava_take_home/features/home/cubit/home_state.dart';
import 'package:ava_take_home/features/home/widgets/credit_score_card.dart';
import 'package:ava_take_home/features/home/widgets/credit_score_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {
            context.push('/employment');
          },
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24, right: 20, left: 20),
                  child: CreditScoreCard(
                    score: state.score.value,
                    label: state.score.label,
                    delta: state.score.delta,
                  ),
                ),
              ),
              Expanded(
                child: GridView.extent(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  maxCrossAxisExtent: 375,
                  crossAxisSpacing: 16,
                  children: [
                    GridTile(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32),
                          Text(
                            'Chart',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          CreditScoreChart(),
                        ],
                      ),
                    ),
                    GridTile(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32),
                          Text(
                            'Creadit factors',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Card(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
