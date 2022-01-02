import 'package:astrology_app/Screens/first_screen.dart';
import 'package:astrology_app/Screens/second_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  void onTabChanged(int index) {
    setState(() => currentIndex = index);
  }

  final List _tabIcons = List.unmodifiable([
    {'icon': 'assets/home.png', 'title': 'Home'},
    {'icon': 'assets/talk.png', 'title': 'Talk to Astrologer'},
    {'icon': 'assets/ask.png', 'title': 'Ask Question'},
    {'icon': 'assets/reports.png', 'title': 'Reports'},
  ]);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex == 0) {
          return true;
        } else {
          currentIndex = 0;
          setState(() {});
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Image.asset(
            "assets/hamburger.png",
            width: 30,
            height: 30,
          ),
          title: Image.asset(
            "assets/logo.png",
            height: 60,
            width: 60,
          ),
          actions: [
            Image.asset(
              "assets/profile.png",
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        body: IndexedStack(index: currentIndex, children: [
          const FirstScreen(),
          const SecondScreen(),
          Container(),
          Container()
        ]),
        bottomNavigationBar: NavBar(
          tabIcons: _tabIcons,
          activeIndex: currentIndex,
          onTabChanged: onTabChanged,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class NavBar extends StatelessWidget {
  final List _tabIcons;
  final int activeIndex;
  final ValueChanged<int> onTabChanged;
  NavBar({
    required List tabIcons,
    required this.activeIndex,
    required this.onTabChanged,
  }) : _tabIcons = tabIcons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_tabIcons.length, (index) {
          return NavBarItem(
            icon: _tabIcons[index],
            index: index,
            activeIndex: activeIndex,
            onTabChanged: onTabChanged,
          );
        }),
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final int index;
  final int activeIndex;
  final dynamic icon;
  final ValueChanged<int> onTabChanged;
  const NavBarItem({
    this.icon,
    required this.index,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 1,
      upperBound: 1.3,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onTap() {
    // change currentIndex to this tab's index
    if (widget.index != widget.activeIndex) {
      widget.onTabChanged(widget.index);
      _controller.forward().then((value) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ScaleTransition(
            scale: _controller,
            child: Image.asset(widget.icon['icon'],
                width: 20,
                height: 20,
                color: widget.activeIndex == widget.index
                    ? Colors.orange[800]
                    : Colors.grey),
          ),
          Text(
            widget.icon['title'],
            style: TextStyle(
                fontSize: 10,
                color: widget.activeIndex == widget.index
                    ? Colors.orange[800]
                    : Colors.grey),
          ),
        ],
      ),
    );
  }
}
