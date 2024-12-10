import 'package:flutter/material.dart';

class PrettyWaveButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;

  const PrettyWaveButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 3000),
  });

  @override
  _PrettyWaveButtonState createState() => _PrettyWaveButtonState();
}

class _PrettyWaveButtonState extends State<PrettyWaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Tạo AnimationController để điều khiển hiệu ứng
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(); // Lặp lại hiệu ứng liên tục
  }

  @override
  void dispose() {
    // Hủy controller khi không dùng nữa
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Mở rộng vùng chứa lớn hơn kích thước nút
      height: 50, // Mở rộng vùng chứa lớn hơn kích thước nút
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, // Cho phép viền thoát ra ngoài phạm vi Stack
        children: [
          // Hiệu ứng viền di chuyển ra xa
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                // Viền sẽ di chuyển ra xa theo giá trị của _controller.value
                left: -_controller.value * 10,
                right: -_controller.value * 10,
                top: -_controller.value * 10,
                bottom: -_controller.value * 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(1 - _controller.value), // Mờ dần viền
                      width: 2, // Độ rộng của viền không thay đổi
                    ),
                  ),
                ),
              );
            },
          ),
          // Nút thực tế
          GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: 200, // Kích thước nút
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    Theme.of(context).colorScheme.primary, // Màu nền của nút
              ),
              alignment: Alignment.center,
              child: widget.child, // Nội dung nút
            ),
          ),
        ],
      ),
    );
  }
}
