import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_med_supply/const/const.dart';
import 'package:flutter_med_supply/entity/med_supply.dart';
import 'package:flutter_med_supply/gen/assets.gen.dart';
import 'package:flutter_med_supply/provider/med_supplies.dart';
import 'package:flutter_med_supply/provider/search_med_word.dart';
import 'package:flutter_med_supply/provider/sqlite.dart';
import 'package:flutter_med_supply/theme/text_style.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../components/custom_chip.dart';

final homeKey = GlobalKey<ScaffoldState>();

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medSupplies = ref.watch(medSuppliesProvider);
    final dbNotifier = ref.watch(sqliteProviderProvider.notifier);
    final searchMedWord = ref.watch(searchMedWordProvider);
    final searchMedWordNotifier = ref.watch(searchMedWordProvider.notifier);

    final textController = useTextEditingController();
    final scrollController = useScrollController();

    useEffect(() {
      dbNotifier.init();
      return null;
    }, []);

    return SafeArea(
      child: Scaffold(
        key: homeKey,
        backgroundColor: kBgBlack,
        drawer: Drawer(
          width: 240,
          backgroundColor: kWhite,
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('MedKyu'),
              ),
              ListTile(
                leading: Assets.image.recept.svg(
                    // height: 20,
                    ),
                title: const Text('ライセンス'),
                onTap: () {
                  Navigator.pushNamed(context, '/license');
                },
              ),
              ListTile(
                leading: Assets.image.shield.svg(
                    // height: 20,
                    ),
                title: const Text('プライバシーポリシー/利用規約'),
                onTap: () {
                  launchUrlString(
                      'https://www.notion.so/ourevidence/9954cbe0f4034169bc17648945cb3053',
                      mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 72),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: medSupplies.length,
                  itemBuilder: (context, index) {
                    final med = medSupplies[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: MedCard(med: med),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: kSurfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          homeKey.currentState!.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: kBgBlack,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          controller: textController,
                          cursorColor: kBgBlack,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '薬の名前を入力してください',
                          ),
                          onChanged: (value) {
                            searchMedWordNotifier.set(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      searchMedWord.isNotEmpty
                          ? IconButton(
                              onPressed: () async {
                                searchMedWordNotifier.clear();
                                textController.clear();
                                FocusScope.of(context).unfocus();
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: kBgBlack,
                              ),
                            )
                          : const SizedBox(),
                      IconButton(
                        onPressed: () async {
                          dbNotifier.findByName(searchMedWord);
                          FocusScope.of(context).unfocus();
                          scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCirc,
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          color: kBgBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedCard extends HookConsumerWidget {
  const MedCard({
    super.key,
    required this.med,
  });

  final MedSupply med;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = useState(false);

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kSurfaceWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GenericChip(med: med),
                      const SizedBox(width: 4),
                      CustomChip(
                        chipColor: kSurfaceWhite,
                        isBorderEnable: true,
                        child: Row(
                          children: [
                            MakerIcon(med: med),
                            const SizedBox(width: 4),
                            Text(
                              med.maker,
                              style: kDescription(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    med.brandName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kBgBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SupplyChip(med: med),
                      const SizedBox(width: 4),
                      ShipmentChip(med: med),
                      // const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (isOpen.value)
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '改善予定',
                                  style: kDescription(),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  med.expectLiftingStatusString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: kBgBlack,
                                  ),
                                ),
                              ],
                            ),
                            med.expectLiftingDescription.isNotEmpty &&
                                    med.expectLiftingDescription != '－' &&
                                    med.expectLiftingDescription != '未定'
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '改善予定詳細',
                                            style: kDescription(),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            med.expectLiftingDescription,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: kBgBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '更新日時',
                                  style: kDescription(),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  MedSupply.dateFormattString
                                      .format(med.updatedAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: kBgBlack,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // FutureBuilder<bool>(
                        //     future: canLaunchUrl(url),
                        //     builder: (context, snapshot) {
                        //       print(snapshot.data);
                        //       if (snapshot.hasError) {
                        //         return const SizedBox();
                        //       }

                        //       if (!snapshot.hasData || !snapshot.data!) {
                        //         return const SizedBox();
                        //       }
                        //       return
                        //     }),
                        Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.black26,
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        children: [
                                          MakerIcon(med: med, iconSize: 28),
                                          const SizedBox(width: 8),
                                          Text('${med.maker}のサイトを開く',
                                              style: kBody()),
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      try {
                                        if (med.url.isEmpty) {
                                          throw Exception();
                                        }

                                        await launchUrlString(
                                          med.url,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'リンクが切れているようです\nGoogle検索ページを開きます',
                                            ),
                                          ),
                                        );
                                        launchUrlString(
                                            'https://www.google.co.jp/search?q=${med.maker}+製薬');
                                      }
                                    },
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.black26,
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        children: [
                                          Assets.image.note.image(
                                            height: 28,
                                          ),
                                          const SizedBox(width: 8),
                                          Text('添付文書/IF等を開く', style: kBody()),
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      try {
                                        if (med.url.isEmpty) {
                                          throw Exception();
                                        }

                                        launchUrlString(
                                          'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/GeneralList/${med.yjBase}',
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                ],
              ),
            ),
            CircleAvatar(
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
                onPressed: () {
                  isOpen.value = !isOpen.value;
                },
              ),
            )
          ],
        ));
  }
}

class MakerIcon extends StatelessWidget {
  const MakerIcon({
    super.key,
    required this.med,
    this.iconSize = 12,
  });

  final MedSupply med;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    Widget companyIcon() {
      return Assets.image.company.svg(
        height: iconSize,
        color: Colors.black54,
      );
    }

    // return companyIcon();

    if (med.faviconUrl.isEmpty) {
      return companyIcon();
    }
    return CachedNetworkImage(
      imageUrl: med.faviconUrl,
      placeholder: (context, url) {
        return companyIcon();
      },
      errorWidget: (context, url, error) {
        return companyIcon();
      },
      width: iconSize,
      height: iconSize,
    );
  }
}

class ShipmentChip extends StatelessWidget {
  const ShipmentChip({
    super.key,
    required this.med,
  });

  final MedSupply med;

  @override
  Widget build(BuildContext context) {
    return CustomChip(
      chipColor: med.shipmentStatusColor(),
      child: Text(
        med.shipmentStatusString(),
        style: kDescription(),
      ),
    );
  }
}

class GenericChip extends StatelessWidget {
  const GenericChip({
    super.key,
    required this.med,
  });

  final MedSupply med;

  @override
  Widget build(BuildContext context) {
    final chipText = med.isGeneric() ? '後発' : '先発';
    final chipColor = med.isGeneric() ? kGreen : kBlue;

    return CustomChip(
      chipColor: chipColor,
      child: Text(
        chipText,
        style: kDescription(),
      ),
    );
  }
}

class SupplyChip extends StatelessWidget {
  const SupplyChip({
    super.key,
    required this.med,
  });

  final MedSupply med;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 16;
    Widget statusIcon() {
      // final double iconSize = 16;

      switch (med.supplyStatus) {
        case 'normal':
          return Assets.image.faceNormal.image(height: iconSize);
        case "limitedSelf":
        case "limitedOpponent":
        case "limitedOther":
          return Assets.image.faceDown.image(height: iconSize);
        // case 'stop':
        //   return Assets.image.faceDown.image(height: iconSize);
        case 'stop':
          return Assets.image.skelton.image(height: iconSize);
        default:
          return const SizedBox();
      }
    }

    Color supplyStatusColor() {
      switch (med.supplyStatus) {
        case "normal":
          return kBlue;
        case "limitedSelf":
        case "limitedOpponent":
        case "limitedOther":
          return kGreen;
        case "stop":
          return kYellow;
        default:
          return kWhite;
      }
    }

    return CustomChip(
      chipColor: supplyStatusColor(),
      child: Row(
        children: [
          statusIcon(),
          const SizedBox(width: 4),
          Text(
            med.supplyStatusString(),
            style: kDescription(),
          ),
        ],
      ),
    );
  }
}
