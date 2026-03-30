import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/procedure_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    'CATÉGORIES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryGrid(context),
                  const SizedBox(height: 24),
                  const Text(
                    'HISTORIQUE RÉCENT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildHistoryList(),
                  const SizedBox(height: 24),
                  _buildOfflineBadge(),
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
                      Text(
                        'EKEMA',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Text(
                        'Vos démarches, simplifiées.',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
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
              const SizedBox(height: 16),
              Text(
                'Bonjour 👋 Comment puis-je vous aider ?',
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
      {'icon': '🪪', 'label': 'CNI / Passeport', 'route': '/dialogue'},
      {'icon': '📄', 'label': 'Actes civils', 'route': null},
      {'icon': '🏢', 'label': 'Entreprise', 'route': null},
      {'icon': '🎓', 'label': 'Concours', 'route': null},
      {'icon': '⚖️', 'label': 'Judiciaire', 'route': null},
      {'icon': '✍️', 'label': 'Rédiger', 'route': '/document-generator'},
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
            if (cat['route'] != null) {
              if (cat['label'] == 'CNI / Passeport') {
                final provider = context.read<ProcedureProvider>();
                if (provider.procedures.isNotEmpty) {
                  provider.selectProcedure(provider.procedures.first);
                  Navigator.pushNamed(context, '/dialogue');
                }
              } else {
                Navigator.pushNamed(context, cat['route'] as String);
              }
            }
          },
        );
      },
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

  Widget _buildOfflineBadge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡 Fonctionnement hors ligne',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'EKEMA fonctionne sans connexion internet. Toutes les procédures sont stockées localement sur votre appareil.',
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
    return Container(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('🏠', 'Accueil', true),
          _buildNavItem('💬', 'Dialogue', false),
          _buildNavItem('📋', 'Plan', false),
          _buildNavItem('✍️', 'Rédiger', false),
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
