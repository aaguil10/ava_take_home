import 'package:ava_take_home/features/home/cubit/home_cubit.dart';
import 'package:ava_take_home/features/home/cubit/home_state.dart';
import 'package:ava_take_home/features/home/widgets/credit_account_card.dart';
import 'package:ava_take_home/features/home/widgets/credit_factors_carousel.dart';
import 'package:ava_take_home/features/home/widgets/credit_score_card.dart';
import 'package:ava_take_home/features/home/widgets/credit_score_chart.dart';
import 'package:ava_take_home/features/home/widgets/spend_limit_card.dart';
import 'package:ava_take_home/features/home/widgets/total_balance_card.dart';
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
                  child: CreditScoreCard(history: state.creditScoreHistory),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return _buildTile(
                          context,
                          'Chart',
                          CreditScoreChart(history: state.creditScoreHistory),
                        );
                      case 1:
                        return _buildTile(
                          context,
                          'Credit factors',
                          CreditFactorsCarousel(factors: state.factors),
                        );
                      case 2:
                        return _buildTile(
                          context,
                          'Account details',
                          Column(
                            children: [
                              SpendLimitCard(
                                accountDetails: state.accountDetails,
                              ),
                              SizedBox(height: 16),
                              TotalBalanceCard(accounts: state.accounts),
                            ],
                          ),
                        );
                      case 3:
                        return _buildTile(
                          context,
                          'Open credit card accounts',
                          CreditAccountCard(accounts: state.accounts),
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, Widget child) {
    return GridTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
