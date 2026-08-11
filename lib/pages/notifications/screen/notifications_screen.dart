import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/app_text.dart';
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
    final body = const _NotificationsView();
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(children: [
            ChoiceChip(
              label: Text('filter_all'.tr),
              selected: !_onlyUnread,
              onSelected: (_) {
                setState(() => _onlyUnread = false);
                cubit.load(onlyUnread: false);
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text('filter_unread'.tr),
              selected: _onlyUnread,
              onSelected: (_) {
                setState(() => _onlyUnread = true);
                cubit.load(onlyUnread: true);
              },
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: cubit.markAllRead,
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: Text('mark_all_read'.tr),
            ),
          ]),
        ),
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

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.n, required this.onTap});
  final NotificationModel n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: n.isRead
            ? Theme.of(context).cardColor
            : AppColors.kPrimaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: n.isRead
              ? AppColors.kGreyColor.withOpacity(0.12)
              : AppColors.kPrimaryColor.withOpacity(0.25),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(n.type.icon, size: 20, color: AppColors.kPrimaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(child: AppText(n.title, fontSize: 14, maxLines: 1)),
                        if (!n.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: AppColors.kPrimaryColor, shape: BoxShape.circle),
                          ),
                      ]),
                      const SizedBox(height: 4),
                      AppText(n.message,
                          fontSize: 12,
                          maxLines: 2,
                          fontWeight: FontWeight.w400,
                          color: AppColors.kGreyColor),
                      if (n.createdAt != null) ...[
                        const SizedBox(height: 6),
                        AppText(intl.DateFormat('yyyy/MM/dd – HH:mm').format(n.createdAt!.toLocal()),
                            fontSize: 10, color: AppColors.kGreyColor, fontWeight: FontWeight.w400),
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
