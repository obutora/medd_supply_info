import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_med_supply/gen/assets.gen.dart';
import 'package:flutter_med_supply/provider/generic_name_tag.dart';
import 'package:flutter_med_supply/provider/pie_data.dart';
import 'package:flutter_med_supply/provider/search_med_word.dart';
import 'package:flutter_med_supply/provider/sqlite.dart';
import 'package:flutter_med_supply/theme/text_style.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../const/const.dart';

class SupplyPieChart extends HookConsumerWidget {
  const SupplyPieChart({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = useState(false);
    final tag = ref.watch(genericNameTagProvider);
    final pieData = ref.watch(pieDataProvider.notifier);
    final word = ref.watch(searchMedWordProvider);

    String cardTitle() {
      if (tag.length == 1) {
        return '${tag.first.name}の供給状況';
      } else {
        return '供給状況';
      }
    }

    String cardDescription() {
      if (tag.length == 1) {
        return '${tag.first.name}の供給状況を一気に把握しましょう';
      } else {
        return '成分を１種類に絞りこむと、供給状況グラフを表示できます';
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: kSurfaceWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kGreen,
                ),
                // ignore: deprecated_member_use_from_same_package
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.image.pie.svg(height: 28, color: kBgBlack),
                    const SizedBox(height: 6),
                    Text(
                      '供給グラフ',
                      style: kDescription().copyWith(color: kBgBlack),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardTitle(),
                      style: kCardTitle(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cardDescription(),
                      style: kDescription()
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              tag.length == 1
                  ? CircleAvatar(
                      backgroundColor: kBgBlack,
                      child: IconButton(
                        color: kWhite,
                        icon: isOpen.value
                            ? Assets.image.up.svg(
                                color: kWhite,
                              )
                            : Assets.image.down.svg(
                                color: kWhite,
                              ),
                        onPressed: () async {
                          isOpen.value = !isOpen.value;

                          print(word);
                          final pieData = await ref
                              .read(sqliteProviderProvider.notifier)
                              .pieData(word);

                          ref.read(pieDataProvider.notifier).set(pieData);
                        },
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          isOpen.value && tag.length == 1
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              startDegreeOffset: -90,
                              centerSpaceRadius: 40,
                              sections: pieData.getPieChartSection(),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('供給状況', style: kH3()),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: kBlue,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('通常出荷', style: kBody()),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: kGreen,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('供給不足', style: kBody()),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('出荷停止/販売中止', style: kBody()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
