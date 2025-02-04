// This source code is a part of Project Violet.
// Copyright (C) 2020-2021.violet-team. Licensed under the Apache-2.0 License.

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:violet/settings/settings.dart';

class ThumbnailWidget extends StatelessWidget {
  final double pad;
  final bool showDetail;
  final String thumbnail;
  final String thumbnailTag;
  final int imageCount;
  final bool isBookmarked;
  final FlareControls flareController;
  final String id;
  final bool isBlurred;
  final bool isLastestRead;
  final int latestReadPage;
  final bool disableFiltering;
  final Map<String, String> headers;

  ThumbnailWidget({
    this.pad,
    this.showDetail,
    this.thumbnail,
    this.thumbnailTag,
    this.imageCount,
    this.isBookmarked,
    this.flareController,
    this.id,
    this.isBlurred,
    this.headers,
    this.isLastestRead,
    this.latestReadPage,
    this.disableFiltering,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: isLastestRead &&
              imageCount - latestReadPage <= 2 &&
              !disableFiltering &&
              Settings.showArticleProgress
          ? BoxDecoration(
              color: Settings.themeWhat
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              backgroundBlendMode: BlendMode.saturation,
            )
          : null,
      width: showDetail ? 100 - pad / 6 * 5 : null,
      child: thumbnail != null
          ? ClipRRect(
              borderRadius: showDetail
                  ? const BorderRadius.horizontal(left: Radius.circular(3.0))
                  : BorderRadius.circular(3.0),
              child: Stack(
                children: <Widget>[
                  ThumbnailImageWidget(
                    headers: headers,
                    thumbnail: thumbnail,
                    thumbnailTag: thumbnailTag,
                    isBlurred: isBlurred,
                  ),
                  BookmarkIndicatorWidget(
                    flareController: flareController,
                    isBookmarked: isBookmarked,
                  ),
                  ReadProgressOverlayWidget(
                    imageCount: imageCount,
                    latestReadPage: latestReadPage,
                    isLastestRead: isLastestRead,
                  ),
                  PagesOverlayWidget(
                    imageCount: imageCount,
                    showDetail: showDetail,
                  ),
                ],
              ),
            )
          : const FlareActor(
              "assets/flare/Loading2.flr",
              alignment: Alignment.center,
              fit: BoxFit.fitHeight,
              animation: "Alarm",
            ),
    );
  }
}

class ThumbnailImageWidget extends StatelessWidget {
  final String thumbnailTag;
  final String thumbnail;
  final Map<String, String> headers;
  final bool isBlurred;

  ThumbnailImageWidget(
      {this.thumbnail, this.thumbnailTag, this.headers, this.isBlurred});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: thumbnailTag,
      child: CachedNetworkImage(
        imageUrl: thumbnail,
        fit: BoxFit.cover,
        httpHeaders: headers,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
          child: isBlurred
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                )
              : Container(),
        ),
        placeholder: (b, c) {
          return const FlareActor(
            "assets/flare/Loading2.flr",
            alignment: Alignment.center,
            fit: BoxFit.fitHeight,
            animation: "Alarm",
          );
        },
      ),
    );
  }
}

class BookmarkIndicatorWidget extends StatelessWidget {
  final bool isBookmarked;
  final FlareControls flareController;

  BookmarkIndicatorWidget({this.isBookmarked, this.flareController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.topLeft,
      child: Transform(
        transform: Matrix4.identity()..scale(0.9),
        child: SizedBox(
          width: 35,
          height: 35,
          child: FlareActor(
            'assets/flare/likeUtsua.flr',
            animation: isBookmarked ? "Like" : "IdleUnlike",
            controller: flareController,
          ),
        ),
      ),
    );
  }
}

class ReadProgressOverlayWidget extends StatelessWidget {
  final bool isLastestRead;
  final int latestReadPage;
  final int imageCount;

  ReadProgressOverlayWidget(
      {this.isLastestRead, this.latestReadPage, this.imageCount});

  @override
  Widget build(BuildContext context) {
    return !isLastestRead || !Settings.showArticleProgress
        ? Container()
        : Align(
            alignment: FractionalOffset.topRight,
            child: Container(
              // margin: EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.all(4),
              width: 50,
              height: 5,
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  value: isLastestRead && imageCount - latestReadPage <= 2
                      ? 1.0
                      : latestReadPage / imageCount,
                  backgroundColor: Colors.grey.withAlpha(100),
                ),
              ),
            ),
          );
  }
}

class PagesOverlayWidget extends StatelessWidget {
  final bool showDetail;
  final int imageCount;

  const PagesOverlayWidget({this.showDetail, this.imageCount});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !showDetail,
      child: Align(
        alignment: FractionalOffset.bottomRight,
        child: Transform(
          transform: Matrix4.identity()..scale(0.9),
          child: Theme(
            data: ThemeData(canvasColor: Colors.transparent),
            child: RawChip(
              labelPadding: EdgeInsets.all(0.0),
              label: Text(
                '' + imageCount.toString() + ' Page',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: const EdgeInsets.all(6.0),
            ),
          ),
        ),
      ),
    );
  }
}
