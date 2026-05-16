// Carousel and dot indicator widgets for InsightsScreen
part of 'insights_screen.dart';

class _InsightCarousel extends StatefulWidget {
  const _InsightCarousel({required this.insights, required this.data});
  final List<InsightEntry> insights;
  final InsightData data;

  @override
  State<_InsightCarousel> createState() => _InsightCarouselState();
}

class _InsightCarouselState extends State<_InsightCarousel> {
  late final PageController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.insights.length;
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
              child: _InsightCard(
                insight: widget.insights[i],
                data: widget.data,
                index: i,
                total: count,
              ),
            ),
          ),
        ),
        _DotIndicator(
            count: count, current: _current, controller: _controller),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator(
      {required this.count,
      required this.current,
      required this.controller});
  final int count;
  final int current;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return GestureDetector(
          onTap: () => controller.animateToPage(i,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: active ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: active
                  ? AppColors.primary
                  : AppColors.primary.withAlpha(60),
            ),
          ),
        );
      }),
    );
  }
}
