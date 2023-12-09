import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_med_supply/components/custom_chip.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../const/const.dart';
import '../entity/med_supply.dart';
import '../gen/assets.gen.dart';
import '../theme/text_style.dart';

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
                        onTap: () {},
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
                    med.genericName,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    med.brandName,
                    style: kCardTitle(),
                  ),
                  const SizedBox(height: 8),
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
                                        // ignore: use_build_context_synchronously
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
      onTap: () {},
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
      onTap: () {},
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
      onTap: () {},
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
