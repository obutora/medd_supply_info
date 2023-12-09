import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_med_supply/components/animation/fade_animation.dart';
import 'package:flutter_med_supply/components/animation/scale_animation.dart';
import 'package:flutter_med_supply/const/const.dart';
import 'package:flutter_med_supply/gen/assets.gen.dart';
import 'package:flutter_med_supply/provider/med_supplies.dart';
import 'package:flutter_med_supply/provider/search_med_word.dart';
import 'package:flutter_med_supply/provider/sqlite.dart';
import 'package:flutter_med_supply/theme/text_style.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../components/custom_chip.dart';
import '../components/med_card.dart';
import '../provider/generic_name_tag.dart';

final homeKey = GlobalKey<ScaffoldState>();

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medSupplies = ref.watch(medSuppliesProvider);
    final dbNotifier = ref.watch(sqliteProviderProvider.notifier);
    final genericTags = ref.watch(genericNameTagProvider);
    final genericTagsNotifier = ref.watch(genericNameTagProvider.notifier);
    final searchMedWord = ref.watch(searchMedWordProvider);
    final searchMedWordNotifier = ref.watch(searchMedWordProvider.notifier);

    final textController = useTextEditingController();
    final scrollController = useScrollController();

    useEffect(() {
      dbNotifier.init();
      return null;
    }, []);

    Future<void> searchStart() async {
      FocusScope.of(context).unfocus();
      await dbNotifier.findByName(searchMedWord);
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCirc,
      );
    }

    void clear() {
      searchMedWordNotifier.clear();
      genericTagsNotifier.clear();
      textController.clear();
      FocusScope.of(context).unfocus();
    }

    Future<void> tapTag(String name) async {
      textController.text = name;
      searchMedWordNotifier.set(name);

      await dbNotifier.findByName(name);
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCirc,
      );
    }

    return SafeArea(
      child: Scaffold(
        key: homeKey,
        backgroundColor: kBgBlack,
        drawer: Drawer(
          width: 240,
          backgroundColor: kWhite,
          child: ListView(
            children: [
              const DrawerHeader(
                child: Text('Reimei'),
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
                padding: const EdgeInsets.only(top: 64),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: medSupplies.length,
                  itemBuilder: (context, index) {
                    final med = medSupplies[index];

                    if (index == 0 &&
                        genericTags.isNotEmpty &&
                        genericTags.length > 1) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: kSurfaceWhite,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '一般名検索',
                                  style: kCardTitle(),
                                ),
                                Text('複数の成分がヒットした場合に表示。タップするとその成分の薬を一覧表示します',
                                    style: kDescription().copyWith(
                                      fontWeight: FontWeight.w500,
                                    )),
                                const SizedBox(height: 6),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: genericTags.length,
                                    itemBuilder: (context, index) {
                                      final tag = genericTags[index];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: ScaleAnimation(
                                          delay: Duration(
                                              milliseconds: 200 * index),
                                          duration:
                                              const Duration(milliseconds: 600),
                                          child: CustomChip(
                                            chipColor: kBgBlack,
                                            isBorderEnable: true,
                                            onTap: () async {
                                              await tapTag(tag.name);
                                            },
                                            child: Text(
                                              tag.name,
                                              style: kDescription()
                                                  .copyWith(color: kWhite),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: FadeAnimation(
                              duration: const Duration(milliseconds: 800),
                              child: MedCard(med: med),
                            ),
                          ),
                        ],
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: FadeAnimation(
                        duration: const Duration(milliseconds: 800),
                        child: MedCard(med: med),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  children: [
                    Container(
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
                                hintText: '薬やメーカーの名前を入力してください',
                              ),
                              onChanged: (value) {
                                searchMedWordNotifier.set(value);
                              },
                              onSubmitted: (_) => searchStart(),
                            ),
                          ),
                          const SizedBox(width: 4),
                          searchMedWord.isNotEmpty
                              ? IconButton(
                                  onPressed: () async {
                                    clear();
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: kBgBlack,
                                  ),
                                )
                              : const SizedBox(),
                          IconButton(
                            onPressed: () => searchStart(),
                            icon: const Icon(
                              Icons.search,
                              color: kBgBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
