import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/shimmer_widgets.dart';
import 'package:wallet/core/components/state_views.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/state/paged_list_state.dart';
import 'package:wallet/pages/notifications/cubit/notifications_cubit.dart';
import 'package:wallet/pages/notifications/model/notification_model.dart';
import 'package:wallet/pages/notifications/notification_navigator.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key, this.cubit});
  final NotificationsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    const body = _NotificationsView();
    if (cubit != null) return BlocProvider.value(value: cubit!, child: body);
    return BlocProvider(create: (_) => NotificationsCubit()..load(), child: body);
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();
  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  bool _onlyUnread = false;

  void _open(NotificationModel n) {
    if (!n.isRead) context.read<NotificationsCubit>().markAsRead(n.id);
    NotificationNavigator.open(referenceType: n.referenceType, referenceId: n.referenceId);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── Filter bar ────────────────────────────────────────────────────
        Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(children: [
            _FilterChip(
              label: 'filter_all'.tr,
              selected: !_onlyUnread,
              onTap: () {
                setState(() => _onlyUnread = false);
                cubit.load(onlyUnread: false);
              },
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'filter_unread'.tr,
              selected: _onlyUnread,
              onTap: () {
                setState(() => _onlyUnread = true);
                cubit.load(onlyUnread: true);
              },
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: cubit.markAllRead,
              icon: Icon(Icons.done_all_rounded, size: 16, color: colorScheme.primary),
              label: Text(
                'mark_all_read'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo-Bold',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ]),
        ),
        Divider(height: 1, color: colorScheme.outline),

        // ── List ──────────────────────────────────────────────────────────
        Expanded(
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final list = state.list;
              if (list.isInitialLoading) return const NotificationsShimmer();
              if (list.status == ViewStatus.error && list.items.isEmpty) {
                return ErrorStateView(
                    message: list.error ?? '', onRetry: () => cubit.load(onlyUnread: _onlyUnread));
              }
              if (list.status == ViewStatus.empty) {
                return EmptyStateView(
                  icon: Icons.notifications_none_rounded,
                  title: 'notifications_empty_title'.tr,
                  message: 'notifications_empty_message'.tr,
                );
              }
              return RefreshIndicator(
                color: colorScheme.primary,
                onRefresh: () => cubit.load(onlyUnread: _onlyUnread, refresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  itemCount: list.items.length,
                  itemBuilder: (context, i) =>
                      _NotificationTile(n: list.items[i], onTap: () => _open(list.items[i])),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppColors.radiusFull),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.n, required this.onTap});
  final NotificationModel n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = n.isRead
        ? colorScheme.surface
        : (isDark
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.primary.withValues(alpha: 0.05));

    final borderColor = n.isRead
        ? colorScheme.outline
        : colorScheme.primary.withValues(alpha: 0.3);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppColors.radiusMd),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
          highlightColor: Colors.transparent,
          splashColor: colorScheme.primary.withValues(alpha: 0.08),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Icon badge ───────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppColors.radiusSm),
                  ),
                  child: Icon(n.type.icon, size: 18, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),

                // ── Content ──────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Cairo-Bold',
                                fontSize: 14,
                                fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w700,
                                color: colorScheme.onSurface,
                                height: 1.4,
                              ),
                            ),
                          ),
                          if (!n.isRead) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        n.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Cairo-Bold',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      if (n.createdAt != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          intl.DateFormat('d/M/yyyy • HH:mm').format(n.createdAt!.toLocal()),
                          style: TextStyle(
                            fontFamily: 'Cairo-Bold',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('notifications'.tr)),
      body: const NotificationsBody(),
    );
  }
}
