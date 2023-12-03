import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_med_supply/const/const.dart';
import 'package:flutter_med_supply/entity/med_supply.dart';
import 'package:flutter_med_supply/gen/assets.gen.dart';
import 'package:flutter_med_supply/provider/med_supplies.dart';
import 'package:flutter_med_supply/provider/sqlite.dart';
import 'package:flutter_med_supply/theme/text_style.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/custom_chip.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kWhite),
        useMaterial3: true,
        fontFamily: 'Line',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medSupplies = ref.watch(medSuppliesProvider);
    final dbNotifier = ref.watch(sqliteProviderProvider.notifier);

    useEffect(() {
      dbNotifier.init();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: kBgBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: kSurfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                child: Row(
                  children: [
                    const Flexible(
                      child: TextField(
                        cursorColor: kBgBlack,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '薬の名前を入力してください',
                        ),
                      ),
                    ),
                    // const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        dbNotifier.findByName('アムロ');
                      },
                      icon: const Icon(
                        Icons.search,
                        color: kBgBlack,
                      ),
                    ),
                    // const SizedBox(width: 8)
                  ],
                ),
              ),
              const Text('Hello Worlds'),
              Expanded(
                child: ListView.builder(
                  itemCount: medSupplies.length,
                  itemBuilder: (context, index) {
                    final med = medSupplies[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: MedCard(med: med),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MedCard extends StatelessWidget {
  const MedCard({
    super.key,
    required this.med,
  });

  final MedSupply med;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kSurfaceWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Flexible(
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
                              CachedNetworkImage(
                                imageUrl: med.faviconUrl,
                                placeholder: (context, url) {
                                  return const CircularProgressIndicator();
                                },
                                errorWidget: (context, url, error) {
                                  return Assets.image.company.svg(
                                    height: 12,
                                    color: Colors.black54,
                                  );
                                },
                                width: 12,
                                height: 12,
                              ),
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
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: kBgBlack,
                child: IconButton(
                  color: kWhite,
                  icon: Assets.image.down.svg(
                    color: kWhite,
                  ),
                  onPressed: () {
                    print('ss');
                  },
                ),
              )
            ],
          ),
        ));
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
