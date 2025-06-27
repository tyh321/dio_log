import 'package:flutter/material.dart';

import 'dio_log.dart';

///
/// Created by rich on 2019-07-31
///

OverlayEntry? itemEntry;

///显示全局悬浮调试按钮
showDebugBtn(BuildContext context, {Color? btnColor}) async {
  ///widget第一次渲染完成
  try {
    await Future.delayed(Duration(milliseconds: 500));
    dismissDebugBtn();
    itemEntry = OverlayEntry(builder: (BuildContext context) => DraggableButtonWidget(btnColor: btnColor));

    ///显示悬浮menu
    Overlay.of(context).insert(itemEntry!);
  } catch (e) {
    print('$e');
  }
}

///关闭悬浮按钮
dismissDebugBtn() {
  itemEntry?.remove();
  itemEntry = null;
}

///悬浮按钮展示状态
bool debugBtnIsShow() {
  return !(itemEntry == null);
}

class DraggableButtonWidget extends StatefulWidget {
  final double btnSize;
  final Color? btnColor;

  DraggableButtonWidget({
    this.btnSize = 66,
    this.btnColor,
  });

  @override
  _DraggableButtonWidgetState createState() => _DraggableButtonWidgetState();
}

class _DraggableButtonWidgetState extends State<DraggableButtonWidget> {
  double right = 30;
  double bottom = 100;
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    ///默认点击事件
    var tap = () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HttpLogListWidget(),
        ),
      );
    };
    Widget w;
    Color primaryColor = widget.btnColor ?? Theme.of(context).primaryColor;
    primaryColor = primaryColor.withValues(alpha: .6);
    w = GestureDetector(
      onTap: tap,
      onPanUpdate: _dragUpdate,
      child: Container(
        width: widget.btnSize,
        height: widget.btnSize,
        color: primaryColor,
        child: Icon(Icons.bug_report_outlined, color: Colors.white, size: 30),
      ),
    );

    ///圆形
    w = ClipRRect(
      borderRadius: BorderRadius.circular(widget.btnSize / 2),
      child: w,
    );

    ///计算偏移量限制
    if (right < 1) {
      right = 1;
    }
    if (right > screenWidth - widget.btnSize) {
      right = screenWidth - widget.btnSize;
    }

    if (bottom < 1) {
      bottom = 1;
    }
    if (bottom > screenHeight - widget.btnSize) {
      bottom = screenHeight - widget.btnSize;
    }
    w = Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.only(right: right, bottom: bottom),
      child: w,
    );
    return w;
  }

  _dragUpdate(DragUpdateDetails detail) {
    Offset offset = detail.delta;
    right = right - offset.dx;
    bottom = bottom - offset.dy;
    setState(() {});
  }
}
