import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ─── Primitive helper ────────────────────────────────────────────────────────

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

Color _baseColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
}

Color _highlightColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);
}

// ─── Generic shimmer widget ───────────────────────────────────────────────────

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// ─── Dashboard Tab shimmer ────────────────────────────────────────────────────

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ShimmerBox(width: double.infinity, height: 110, borderRadius: 20),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: _ShimmerBox(width: double.infinity, height: 96, borderRadius: 16)),
                SizedBox(width: 10),
                Expanded(child: _ShimmerBox(width: double.infinity, height: 96, borderRadius: 16)),
                SizedBox(width: 10),
                Expanded(child: _ShimmerBox(width: double.infinity, height: 96, borderRadius: 16)),
              ],
            ),
            const SizedBox(height: 24),
            const _ShimmerBox(width: 140, height: 18, borderRadius: 8),
            const SizedBox(height: 10),
            const _ShimmerBox(width: double.infinity, height: 70, borderRadius: 12),
            const SizedBox(height: 8),
            const _ShimmerBox(width: double.infinity, height: 70, borderRadius: 12),
            const SizedBox(height: 8),
            const _ShimmerBox(width: double.infinity, height: 70, borderRadius: 12),
            const SizedBox(height: 20),
            const _ShimmerBox(width: 140, height: 18, borderRadius: 8),
            const SizedBox(height: 10),
            const _ShimmerBox(width: double.infinity, height: 70, borderRadius: 12),
            const SizedBox(height: 8),
            const _ShimmerBox(width: double.infinity, height: 70, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}

// ─── Home Tab shimmer ─────────────────────────────────────────────────────────

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Greeting header
            const Row(
              children: [
                _ShimmerBox(width: 48, height: 48, borderRadius: 24),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(width: 80, height: 12),
                    SizedBox(height: 8),
                    _ShimmerBox(width: 140, height: 18),
                  ],
                ),
                Spacer(),
                _ShimmerBox(width: 40, height: 40, borderRadius: 20),
              ],
            ),
            const SizedBox(height: 20),
            // Ticker bar
            const _ShimmerBox(width: double.infinity, height: 44, borderRadius: 12),
            const SizedBox(height: 20),
            // Subscription card
            const _ShimmerBox(width: double.infinity, height: 160, borderRadius: 20),
            const SizedBox(height: 24),
            // Wallet section
            const _ShimmerBox(width: 120, height: 18),
            const SizedBox(height: 12),
            _walletRow(),
            const SizedBox(height: 24),
            // Quick actions label
            const _ShimmerBox(width: 100, height: 18),
            const SizedBox(height: 16),
            _quickActionsGrid(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _walletRow() {
    return Row(
      children: List.generate(3, (i) {
        final isLast = i == 2;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: isLast ? 0 : 12),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }),
    );
  }

  Widget _quickActionsGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: List.generate(
        8,
        (_) => const _ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 16,
        ),
      ),
    );
  }
}

// ─── Subscriptions Tab shimmer ────────────────────────────────────────────────

class SubscriptionsShimmer extends StatelessWidget {
  const SubscriptionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (_, __) => _PlanCardShimmer(),
      ),
    );
  }
}

class _PlanCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              _ShimmerBox(width: 130, height: 20),
              SizedBox(width: 10),
              _ShimmerBox(width: 60, height: 20, borderRadius: 12),
            ],
          ),
          SizedBox(height: 8),
          _ShimmerBox(width: 200, height: 13),
          SizedBox(height: 16),
          // Chip row
          Row(
            children: [
              _ShimmerBox(width: 90, height: 30, borderRadius: 12),
              SizedBox(width: 8),
              _ShimmerBox(width: 90, height: 30, borderRadius: 12),
            ],
          ),
          SizedBox(height: 16),
          // Price + button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(width: 100, height: 36),
              _ShimmerBox(width: 100, height: 40, borderRadius: 12),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Connected Devices shimmer ────────────────────────────────────────────────

class ConnectedDevicesShimmer extends StatelessWidget {
  const ConnectedDevicesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Network info card
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),
            // Stats header
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            // Device items
            ...List.generate(5, (_) => _DeviceItemShimmer()),
          ],
        ),
      ),
    );
  }
}

class _DeviceItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          _ShimmerBox(width: 44, height: 44, borderRadius: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 120, height: 14),
                SizedBox(height: 8),
                _ShimmerBox(width: 80, height: 12),
              ],
            ),
          ),
          _ShimmerBox(width: 60, height: 28, borderRadius: 10),
        ],
      ),
    );
  }
}

// ─── Chat / Support shimmer ───────────────────────────────────────────────────

class ChatShimmer extends StatelessWidget {
  const ChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, i) => _ChatBubbleShimmer(isUser: i % 3 != 0),
      ),
    );
  }
}

class _ChatBubbleShimmer extends StatelessWidget {
  final bool isUser;
  const _ChatBubbleShimmer({required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const _ShimmerBox(width: 30, height: 30, borderRadius: 15),
            const SizedBox(width: 8),
          ],
          _ShimmerBox(
            width: isUser ? 200 : 160,
            height: isUser ? 56 : 48,
            borderRadius: 18,
          ),
        ],
      ),
    );
  }
}

// ─── Notifications shimmer ────────────────────────────────────────────────────

class NotificationsShimmer extends StatelessWidget {
  const NotificationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _ShimmerBox(width: 70, height: 40, borderRadius: 12),
                  SizedBox(width: 12),
                  _ShimmerBox(width: 110, height: 40, borderRadius: 12),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                children: List.generate(5, (_) => _NotificationItemShimmer()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 44, height: 44, borderRadius: 12),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 140, height: 14),
                SizedBox(height: 8),
                _ShimmerBox(width: double.infinity, height: 12),
                SizedBox(height: 4),
                _ShimmerBox(width: 200, height: 12),
                SizedBox(height: 8),
                _ShimmerBox(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Invoice / Activity Log shimmer ──────────────────────────────────────────

class InvoiceShimmer extends StatelessWidget {
  const InvoiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, __) => const _ShimmerBox(
                  width: 80,
                  height: 40,
                  borderRadius: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                children: List.generate(5, (_) => _LogEntryShimmer()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogEntryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          _ShimmerBox(width: 44, height: 44, borderRadius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 160, height: 14),
                SizedBox(height: 6),
                Row(
                  children: [
                    _ShimmerBox(width: 80, height: 12),
                    SizedBox(width: 8),
                    _ShimmerBox(width: 60, height: 20, borderRadius: 8),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          _ShimmerBox(width: 20, height: 20, borderRadius: 4),
        ],
      ),
    );
  }
}

// ─── Payment shimmer ──────────────────────────────────────────────────────────

class PaymentShimmer extends StatelessWidget {
  const PaymentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: List.generate(4, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i < 3 ? 8 : 0),
                    child: const _ShimmerBox(
                      width: double.infinity,
                      height: 48,
                      borderRadius: 12,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            const _ShimmerBox(width: 140, height: 20),
            const SizedBox(height: 16),
            ...List.generate(
              4,
              (_) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const _ShimmerBox(
              width: double.infinity,
              height: 60,
              borderRadius: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Settings shimmer ─────────────────────────────────────────────────────────

class SettingsShimmer extends StatelessWidget {
  const SettingsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ShimmerBox(width: 180, height: 28),
            const SizedBox(height: 6),
            const _ShimmerBox(width: 120, height: 24),
            const SizedBox(height: 8),
            const _ShimmerBox(width: 240, height: 14),
            const SizedBox(height: 32),
            const _SettingsSectionShimmer(itemCount: 3),
            const SizedBox(height: 24),
            const _SettingsSectionShimmer(itemCount: 2),
            const SizedBox(height: 24),
            const _SettingsSectionShimmer(itemCount: 3),
          ],
        ),
      ),
    );
  }
}

class _SettingsSectionShimmer extends StatelessWidget {
  final int itemCount;
  const _SettingsSectionShimmer({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: _ShimmerBox(width: 100, height: 16),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(itemCount, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: const Row(
                  children: [
                    _ShimmerBox(width: 38, height: 38, borderRadius: 10),
                    SizedBox(width: 14),
                    Expanded(
                      child: _ShimmerBox(
                        width: double.infinity,
                        height: 15,
                      ),
                    ),
                    SizedBox(width: 8),
                    _ShimmerBox(width: 20, height: 20, borderRadius: 4),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─── Maintenance shimmer ──────────────────────────────────────────────────────

class MaintenanceShimmer extends StatelessWidget {
  const MaintenanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ShimmerBox(width: 220, height: 28),
            const SizedBox(height: 8),
            const _ShimmerBox(width: 200, height: 14),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 290,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tasks List shimmer ───────────────────────────────────────────────────────

class TasksListShimmer extends StatelessWidget {
  const TasksListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, __) => _TaskCardShimmer(),
      ),
    );
  }
}

class _TaskCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 44, height: 44, borderRadius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 160, height: 15),
                SizedBox(height: 8),
                _ShimmerBox(width: double.infinity, height: 12),
                SizedBox(height: 4),
                _ShimmerBox(width: 200, height: 12),
                SizedBox(height: 10),
                _ShimmerBox(width: 80, height: 11),
              ],
            ),
          ),
          SizedBox(width: 8),
          _ShimmerBox(width: 20, height: 20, borderRadius: 4),
        ],
      ),
    );
  }
}

// ─── Speed Test shimmer ───────────────────────────────────────────────────────

class SpeedTestShimmer extends StatelessWidget {
  const SpeedTestShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _ShimmerBox(
                    width: double.infinity,
                    height: 130,
                    borderRadius: 16,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ShimmerBox(
                    width: double.infinity,
                    height: 130,
                    borderRadius: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            _ShimmerBox(width: double.infinity, height: 270, borderRadius: 24),
            SizedBox(height: 24),
            _ShimmerBox(width: double.infinity, height: 56, borderRadius: 16),
            SizedBox(height: 24),
            _ShimmerBox(width: double.infinity, height: 60, borderRadius: 16),
            SizedBox(height: 24),
            _ShimmerBox(width: double.infinity, height: 120, borderRadius: 20),
          ],
        ),
      ),
    );
  }
}
