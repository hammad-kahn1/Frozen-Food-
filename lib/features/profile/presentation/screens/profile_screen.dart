import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                MediaQuery.of(context).padding.top + AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Muhammad Hassan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'hassan@example.com',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionTitle('Account'),
                _MenuItem(icon: Icons.location_on_outlined, label: 'My Addresses', onTap: () {}),
                _MenuItem(icon: Icons.receipt_long_outlined, label: 'Order History', onTap: () {}),
                _MenuItem(icon: Icons.favorite_border, label: 'Wishlist', onTap: () {}),
                const SizedBox(height: AppSpacing.md),

                _SectionTitle('Preferences'),
                _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
                _MenuItem(icon: Icons.language_outlined, label: 'Language', trailing: 'English', onTap: () {}),
                const SizedBox(height: AppSpacing.md),

                _SectionTitle('Support'),
                _MenuItem(icon: Icons.help_outline, label: 'Help & FAQ', onTap: () {}),
                _MenuItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
                _MenuItem(icon: Icons.info_outline, label: 'About', onTap: () {}),
                const SizedBox(height: AppSpacing.md),

                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  tileColor: AppColors.errorContainer.withOpacity(0.3),
                ),
                const SizedBox(height: AppSpacing.xl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.outline,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: trailing != null
            ? Text(trailing!, style: TextStyle(color: AppColors.outline))
            : const Icon(Icons.chevron_right, color: AppColors.outline),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        tileColor: Colors.white,
      ),
    );
  }
}
