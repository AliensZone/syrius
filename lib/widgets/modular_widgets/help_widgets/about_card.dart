import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:zenon_syrius_wallet_flutter/blocs/blocs.dart';
import 'package:zenon_syrius_wallet_flutter/model/model.dart';
import 'package:zenon_syrius_wallet_flutter/utils/utils.dart';
import 'package:zenon_syrius_wallet_flutter/widgets/widgets.dart';
import 'package:znn_sdk_dart/znn_sdk_dart.dart';

class AboutCard extends StatefulWidget {
  const AboutCard({Key? key}) : super(key: key);

  @override
  State createState() {
    return AboutCardState();
  }
}

class AboutCardState extends State<AboutCard> {
  GeneralStatsBloc? _generalStatsBloc;

  @override
  void initState() {
    super.initState();
    _generalStatsBloc = GeneralStatsBloc();
  }

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      title: 'About',
      description: 'Detailed information about wallet components',
      childBuilder: () => _getStreamBuilder(),
    );
  }

  Widget _getNewBody(GeneralStats generalStats) {
    return ListView(
      shrinkWrap: true,
      children: [
        CustomExpandablePanel(
          'Syrius wallet version',
          _getGenericTextExpandedChild(kWalletVersion),
        ),
        CustomExpandablePanel(
          'Zenon Node chain identifier',
          _getGenericTextExpandedChild(
              generalStats.frontierMomentum.chainIdentifier.toString()),
        ),
        CustomExpandablePanel(
          'Client chain identifier',
          _getGenericTextExpandedChild(getChainIdentifier().toString()),
        ),
        CustomExpandablePanel(
          'ZNN SDK version',
          _getGenericTextExpandedChild(znnSdkVersion),
        ),
        CustomExpandablePanel(
          'Zenon Node build version',
          _getGenericTextExpandedChild(generalStats.processInfo.version),
        ),
        CustomExpandablePanel(
          'Zenon Node git commit hash',
          _getGenericTextExpandedChild(generalStats.processInfo.commit),
        ),
        CustomExpandablePanel(
          'Zenon Node kernel version',
          _getGenericTextExpandedChild(generalStats.osInfo.kernelVersion),
        ),
        CustomExpandablePanel(
          'Zenon Node operating system',
          _getGenericTextExpandedChild(generalStats.osInfo.os),
        ),
        CustomExpandablePanel(
          'Zenon Node platform',
          _getGenericTextExpandedChild(generalStats.osInfo.platform),
        ),
        CustomExpandablePanel(
          'Zenon Node platform version',
          _getGenericTextExpandedChild(generalStats.osInfo.platformVersion),
        ),
        CustomExpandablePanel(
          'Zenon Node number of processors',
          _getGenericTextExpandedChild(generalStats.osInfo.numCPU.toString()),
        ),
        CustomExpandablePanel(
          'Zenon main data path',
          _getGenericButtonExpandedChild(znnDefaultPaths.main.absolute.path),
        ),
        CustomExpandablePanel(
          'syrius cache path',
          _getGenericButtonExpandedChild(znnDefaultPaths.cache.absolute.path),
        ),
        CustomExpandablePanel(
          'syrius wallet path',
          _getGenericButtonExpandedChild(znnDefaultPaths.wallet.absolute.path),
        ),
        CustomExpandablePanel(
          'Client hostname',
          _getGenericTextExpandedChild(Platform.localHostname),
        ),
        CustomExpandablePanel(
          'Client local IP address',
          _getGenericTextExpandedChild(kLocalIpAddress!),
        ),
        CustomExpandablePanel(
          'Client operating system',
          _getGenericTextExpandedChild(Platform.operatingSystem),
        ),
        CustomExpandablePanel(
          'Client operating system version',
          _getGenericTextExpandedChild(Platform.operatingSystemVersion),
        ),
        CustomExpandablePanel(
          'Client number of processors',
          _getGenericTextExpandedChild(Platform.numberOfProcessors.toString()),
        ),
      ],
    );
  }

  Widget _getGenericTextExpandedChild(String expandedText) {
    return Row(children: [
      CustomTableCell.withMarquee(
        expandedText.toString(),
      )
    ]);
  }

  Widget _getGenericButtonExpandedChild(String expandedText) {
    return Row(children: [
      CustomTableCell.withMarquee(
        expandedText.toString(),
      ),
      IconButton(
        splashRadius: 16,
        onPressed: () async {
          await OpenFilex.open(expandedText);
        },
        icon: const Icon(
          Icons.open_in_new,
          size: 16,
          color: AppColors.znnColor,
        ),
      ),
    ]);
  }

  Widget _getStreamBuilder() {
    return StreamBuilder<GeneralStats>(
      stream: _generalStatsBloc!.stream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return _getNewBody(snapshot.data!);
        } else if (snapshot.hasError) {
          return SyriusErrorWidget(
            snapshot.error.toString(),
          );
        }
        return const SyriusLoadingWidget();
      },
    );
  }

  @override
  void dispose() {
    _generalStatsBloc!.dispose();
    super.dispose();
  }
}
