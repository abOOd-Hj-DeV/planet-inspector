import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_theme.dart';
import '../app/routes.dart';
import '../controllers/auth_controller.dart';
import '../controllers/image_controller.dart';
import '../widgets/history_actions.dart';
import '../widgets/history_state.dart';
import '../widgets/page_body.dart';
import '../widgets/plant_details_dialog.dart';
import '../widgets/plant_image.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final _search = TextEditingController(
    text: Get.find<ImageController>().query.value,
  );
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = Get.find<ImageController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            tooltip: 'Clear history',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () async {
              if (await confirmHistoryAction(
                    context,
                    'Clear history?',
                    'Delete all scans for your account on this device?',
                  ) &&
                  context.mounted) {
                await changeHistory(context, history.clearHistory);
              }
            },
          ),
        ],
      ),
      body: PageBody(
        maxWidth: 900,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _search,
                      onChanged: (value) => history.query.value = value,
                      decoration: const InputDecoration(
                        labelText: 'Search history',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Wrap(
                        spacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          FilterChip(
                            label: const Text('Favorites'),
                            selected: history.favoritesOnly.value,
                            onSelected: (value) =>
                                history.favoritesOnly.value = value,
                          ),
                          SizedBox(
                            width: 260,
                            child: DropdownButton<HistorySort>(
                              isExpanded: true,
                              value: history.sort.value,
                              items: const [
                                DropdownMenuItem(
                                  value: HistorySort.newest,
                                  child: Text(
                                    'Newest first',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: HistorySort.oldest,
                                  child: Text(
                                    'Oldest first',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: HistorySort.name,
                                  child: Text(
                                    'Name A–Z',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) history.sort.value = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              final images = history.filteredImages;
              if (history.isLoading.value ||
                  history.error.value.isNotEmpty ||
                  images.isEmpty) {
                return SliverToBoxAdapter(
                  child: HistoryState(
                    loading: history.isLoading.value,
                    error: history.error.value,
                    filtered:
                        history.query.value.isNotEmpty ||
                        history.favoritesOnly.value,
                    onRetry: () => history.loadImages(
                      Get.find<AuthController>().userId.value,
                    ),
                  ),
                );
              }
              return SliverLayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.crossAxisExtent < 360
                      ? 1
                      : constraints.crossAxisExtent < 650
                      ? 2
                      : 3;
                  final textScale = MediaQuery.textScalerOf(context).scale(1);
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 220 + 36 * (textScale - 1),
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        final image = images[index];
                        return Card(
                          color: AppColors.lightGreen,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => showPlantDetails(context, image),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: PlantImage(
                                      path: image.imagePath,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                                child: Text(
                                  image.plantName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.green,
                                  ),
                                ),
                              ),
                              HistoryActions(image: image),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.results),
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('Make a new search'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
