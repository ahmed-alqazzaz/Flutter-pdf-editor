import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/homepage/views/files_view/drawer.dart';

import 'package:pdf_editor/homepage/views/generics/app_bars/homepage_app_bar.dart';
import 'package:pdf_editor/homepage/views/generics/app_bars/homepage_navigation_bar.dart';
import 'package:pdf_editor/homepage/views/tools_view.dart/homepage_tool_view.dart';

import '../../bloc/app_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_events.dart';

import 'files_view/homepage_files_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  static const _pageNavigationCurve = Curves.linear;
  static const _pageNavigationDuration = Duration(milliseconds: 400);

  late final PageController _pageController;
  late final StreamController<int> _currentPageController;
  late final bloc = context.read<HomePageBloc>();
  @override
  void initState() {
    _currentPageController = StreamController.broadcast();
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageController.close();
    super.dispose();
  }

  Future<void> navigateTo(int page) async {
    // in case the page is not already being scrolled
    if (!_pageController.position.isScrollingNotifier.value) {
      await _pageController.animateToPage(
        page,
        duration: _pageNavigationDuration,
        curve: _pageNavigationCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: HomePageAppBar(
        onSearchQueryUpdate: (query) {
          homePageBloc.add(
            HomePageEventDisplayFiles(
              filter: (pdfFile) => pdfFile.name.contains(query),
            ),
          );
        },
        indexController: _currentPageController,
      ),
      bottomNavigationBar: HomePageNavigationBar(
        indexController: _currentPageController,
        onItemTapped: (int index) async {
          if (index == 1) {
            await navigateTo(1);
          } else {
            await navigateTo(0);
          }
        },
      ),
      drawer: HomePageDrawer(email: context.read<AppBloc>().currentUser?.email),
      body: PageView(
        onPageChanged: (value) => _currentPageController.add(value),
        controller: _pageController,
        children: [
          const HomePageFilesView(),
          HomePageToolsView(context),
        ],
      ),
    );
  }
}
