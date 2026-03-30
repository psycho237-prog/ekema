import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/procedure_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (context.watch<ProcedureProvider>().searchResults.length < context.watch<ProcedureProvider>().procedures.length || 
                      context.watch<ProcedureProvider>().searchResults.isEmpty) ...[
                    Text(
                      l10n.searchResults.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.muted,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildResultsList(context),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => context.read<ProcedureProvider>().search(''),
                      child: Text(l10n.backToCategories, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                    ),
                  ] else ...[
                    Text(
                      l10n.categories.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.muted,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryGrid(context),
                    const SizedBox(height: 24),
                    Text(
                      l10n.recentHistory.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.muted,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHistoryList(),
                  ],
                  const SizedBox(height: 24),
                  _buildOfflineBadge(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 48),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/logo.svg',
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.appTitle,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        l10n.appSubtitle,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => localeProvider.toggleLocale(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 0.5),
                          ),
                          child: Text(
                            localeProvider.locale.languageCode.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(child: Text('👤', style: TextStyle(fontSize: 18))),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.welcomeMessage,
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -24,
          left: 16,
          right: 16,
          child: EkemaSearchBar(
            onSearch: (q) => context.read<ProcedureProvider>().search(q),
            onVoiceTap: () {}, // To be implemented with STT
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {'icon': '🪪', 'label': 'CNI / Passeport'},
      {'icon': '📄', 'label': 'Actes civils'},
      {'icon': '🏢', 'label': 'Entreprise'},
      {'icon': '🎓', 'label': 'Concours'},
      {'icon': '⚖️', 'label': 'Judiciaire'},
      {'icon': '✍️', 'label': 'Rédiger'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return CategoryCard(
          icon: cat['icon'] as String,
          label: cat['label'] as String,
          onTap: () {
            if (cat['label'] == 'Rédiger') {
              Navigator.pushNamed(context, '/document-generator');
            } else {
              // Filter search results to the category to show common procedures
              context.read<ProcedureProvider>().search(cat['label'] as String);
            }
          },
        );
      },
    );
  }

  Widget _buildResultsList(BuildContext context) {
    final results = context.watch<ProcedureProvider>().searchResults;
    
    if (results.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: const Center(
          child: Text(
            'Pas de résultat. Essayez d\'autres mots-clés.',
            style: TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ),
      );
    }

    return Column(
      children: results.map((proc) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: ListTile(
          onTap: () {
            context.read<ProcedureProvider>().selectProcedure(proc);
            Navigator.pushNamed(context, '/dialogue');
          },
          leading: const Text('📋', style: TextStyle(fontSize: 18)),
          title: Text(proc.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          subtitle: Text(proc.category, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
        ),
      )).toList(),
    );
  }

  Widget _buildHistoryList() {
    final history = [
      'Renouvellement CNI',
      'Concours ENS 2026',
      'Demande de bourse MINESUP',
    ];

    return Column(
      children: history.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          onTap: () {},
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
          ),
          title: Text(item, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.chevron_right, size: 16, color: AppColors.muted),
        ),
      )).toList(),
    );
  }

  Widget _buildOfflineBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.offlineBadgeTitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.offlineBadgeBody,
            style: TextStyle(
              fontSize: 11,
              height: 1.5,
              color: AppColors.primaryDark.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('🏠', l10n.backToCategories, true), // Approx for Home
          _buildNavItem('💬', l10n.intelligentDialogue, false),
          _buildNavItem('📋', l10n.searchResults, false),
          _buildNavItem('✍️', l10n.writeDocument, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          if (active) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: active ? AppColors.primary : AppColors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
