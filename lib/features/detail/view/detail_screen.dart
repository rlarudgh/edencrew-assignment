import 'package:edencrew_assignment_starter/domain/models/candle_point.dart';
import 'package:edencrew_assignment_starter/domain/models/daily_price_row.dart';
import 'package:edencrew_assignment_starter/domain/models/period_option.dart';
import 'package:edencrew_assignment_starter/domain/models/quote.dart';
import 'package:edencrew_assignment_starter/domain/models/stock.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/candle_chart.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/candle_chart_skeleton.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/daily_price_table.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/daily_price_table_skeleton.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/detail_header.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/period_tabs.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/price_hero.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/price_hero_skeleton.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/summary_card.dart';
import 'package:edencrew_assignment_starter/features/detail/widgets/summary_card_skeleton.dart';
import 'package:edencrew_assignment_starter/providers/candle_data_provider.dart';
import 'package:edencrew_assignment_starter/providers/detail_quote_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `03 · 종목상세` 화면입니다. 관심/검색 화면에서 종목을 눌러 이동합니다.
class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key, required this.stock});

  final Stock stock;

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  // 다른 화면이 이 값을 읽을 일이 없어서 전역 provider가 아니라 화면
  // 로컬 상태로 둡니다.
  PeriodOption _selectedPeriod = PeriodOption.oneMonth;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final AsyncValue<Quote?> quoteAsync = ref.watch(detailQuoteProvider(widget.stock.symbol));
    final AsyncValue<List<CandlePoint>> candlesAsync = ref.watch(
      candleDataProvider((symbol: widget.stock.symbol, period: _selectedPeriod)),
    );

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            DetailHeader(stock: widget.stock),
            Expanded(
              child: quoteAsync.when(
                // 기간 탭은 화면 로컬 상태만 필요해서 시세 로딩과 무관하게
                // 항상 보여줍니다 — 로딩 중에도 탭을 누를 수 있는 게
                // 자연스럽습니다. 다만 화면 순서는 항상 "가격 → 기간 탭"이라
                // 두 분기 모두 PriceHero(스켈레톤)/PeriodTabs 순서를 지킵니다.
                loading: () => ListView(
                  children: <Widget>[
                    const PriceHeroSkeleton(),
                    PeriodTabs(
                      selected: _selectedPeriod,
                      onSelected: (PeriodOption option) => setState(() => _selectedPeriod = option),
                    ),
                    _buildChartSection(candlesAsync, dimens, colors),
                    const SummaryCardSkeleton(),
                    _buildTableSection(candlesAsync, colors),
                  ],
                ),
                error: (Object error, StackTrace stackTrace) => Center(
                  child: Text('시세를 불러오지 못했습니다.', style: TextStyle(color: colors.textSecondary)),
                ),
                data: (Quote? quote) {
                  if (quote == null) {
                    return Center(
                      child: Text('시세를 불러오지 못했습니다.', style: TextStyle(color: colors.textSecondary)),
                    );
                  }
                  return ListView(
                    children: <Widget>[
                      PriceHero(quote: quote),
                      PeriodTabs(
                        selected: _selectedPeriod,
                        onSelected: (PeriodOption option) => setState(() => _selectedPeriod = option),
                      ),
                      _buildChartSection(candlesAsync, dimens, colors),
                      SummaryCard(quote: quote),
                      _buildTableSection(candlesAsync, colors),
                      SizedBox(height: dimens.space4),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(AsyncValue<List<CandlePoint>> candlesAsync, AppDimens dimens, AppColors colors) {
    return candlesAsync.when(
      loading: () => const CandleChartSkeleton(),
      error: (Object error, StackTrace stackTrace) => SizedBox(
        height: 180,
        child: Center(child: Text('차트를 불러오지 못했습니다.', style: TextStyle(color: colors.textSecondary))),
      ),
      data: (List<CandlePoint> candles) => Padding(
        padding: EdgeInsets.symmetric(horizontal: dimens.space4),
        child: CandleChart(candles: candles),
      ),
    );
  }

  Widget _buildTableSection(AsyncValue<List<CandlePoint>> candlesAsync, AppColors colors) {
    return candlesAsync.when(
      loading: () => const DailyPriceTableSkeleton(),
      error: (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
      data: (List<CandlePoint> candles) => DailyPriceTable(rows: DailyPriceRow.listFromCandles(candles)),
    );
  }
}
