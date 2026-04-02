import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/page_model.dart';
import '../providers/cells_provider.dart';
import '../providers/language_provider.dart';
import '../providers/legends_provider.dart';
import '../providers/pages_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import 'settings_screen.dart';
import 'tracker_screen.dart';

class PageListScreen extends StatefulWidget {
  const PageListScreen({super.key});

  @override
  State<PageListScreen> createState() => _PageListScreenState();
}

class _PageListScreenState extends State<PageListScreen> {
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PagesProvider>().fetchPages();
    });
  }

  List<PageModel> _pagesForYear(List<PageModel> pages) {
    return pages.where((p) => p.year == _selectedYear).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  Future<void> _createPage() async {
    final prov = context.read<PagesProvider>();
    await prov.createPage('Untitled');
    // Navigate to the newly created page
    final pages = _pagesForYear(prov.pages);
    if (pages.isNotEmpty && mounted) {
      final newest = pages.last;
      _openTracker(newest);
    }
  }

  void _openTracker(PageModel page) {
    final cellsProv = context.read<CellsProvider>();
    final legendsProv = context.read<LegendsProvider>();
    cellsProv.setPageId(page.id);
    legendsProv.setPageId(page.id);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TrackerScreen(page: page),
      ),
    );
  }

  Future<void> _deletePage(PageModel page) async {
    final lang = context.read<LanguageProvider>();
    final confirmed = await ConfirmDialog.show(
      context,
      title: lang.t('common.delete'),
      message: lang.t('tracker.deletePageConfirm'),
      confirmLabel: lang.t('common.delete'),
      cancelLabel: lang.t('common.cancel'),
      destructive: true,
    );

    if (confirmed == true && mounted) {
      await context.read<PagesProvider>().deletePage(page.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final pages = context.watch<PagesProvider>().pages;
    final yearPages = _pagesForYear(pages);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\u70B9\u70B9',
                        style: AppFonts.pixel(
                          fontSize: 24,
                          color: AppColors.title,
                        ),
                      ),
                      Text(
                        'Dian Dian',
                        style: AppFonts.pixel(
                          fontSize: 11,
                          color: AppColors.subtitle,
                        ),
                      ),
                    ],
                  ),
                  // Settings button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.shell,
                        border: Border.all(color: AppColors.shellBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Year navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedYear--),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '<',
                      style: AppFonts.pixel(
                        fontSize: 18,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$_selectedYear',
                  style: AppFonts.pixel(
                    fontSize: 20,
                    color: AppColors.title,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => setState(() => _selectedYear++),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '>',
                      style: AppFonts.pixel(
                        fontSize: 18,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Page grid
            Expanded(
              child: yearPages.isEmpty
                  ? Center(
                      child: Text(
                        lang.t('tracker.noLegends'),
                        style: AppFonts.dot(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: yearPages.length,
                      itemBuilder: (_, index) {
                        final page = yearPages[index];
                        return _PageCard(
                          page: page,
                          onTap: () => _openTracker(page),
                          onLongPress: () => _deletePage(page),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: GestureDetector(
        onTap: _createPage,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.btnAdd,
            border: Border.all(color: AppColors.btnAddBorder, width: 1.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              '+',
              style: AppFonts.pixel(
                fontSize: 24,
                color: AppColors.btnAddText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A card displaying a page with a mini grid preview and title.
class _PageCard extends StatelessWidget {
  final PageModel page;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _PageCard({
    required this.page,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.shell,
          border: Border.all(color: AppColors.shellBorder),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mini grid preview placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.screen,
                  border: Border.all(color: AppColors.screenBorder),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: _MiniGrid(),
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              page.title,
              style: AppFonts.pixel(fontSize: 11, color: AppColors.text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${page.year}',
              style: AppFonts.dot(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders a tiny 12x31 preview grid of dots.
class _MiniGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dotSize = (constraints.maxWidth / 14).clamp(2.0, 5.0);
        final gap = dotSize * 0.3;

        return Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              // Show fewer rows in the mini view
              12,
              (row) {
                return Padding(
                  padding: EdgeInsets.only(bottom: gap),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(12, (col) {
                      return Padding(
                        padding: EdgeInsets.only(right: gap),
                        child: Container(
                          width: dotSize,
                          height: dotSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.dotEmpty,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
