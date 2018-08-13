import 'dart:math';

import 'package:flutter/material.dart';
import 'package:card_tinder/photos.dart';
import 'package:fluttery/layout.dart';

class DraggableCard extends StatefulWidget {
  @override
  _DraggableCardState createState() => new _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {

  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;

  @override
  Widget build(BuildContext context) {
    return new AnchoredOverlay(
      showOverlay: true,
      child: Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child: new Transform(
            transform: new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
              ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: Container(
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: const EdgeInsets.all(16.0),
              child: new GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: new ProfileCard(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition-dragStart;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      dragStart = null;
      dragPosition = null;
      cardOffset = Offset(0.0,0.0);
    });
  }

  double _rotation(Rect anchorBounds) {
    if(dragStart!=null){
      final rotationCorner = dragStart.dy>=(anchorBounds.height)/2?1:-1;
      return (pi/8)*(cardOffset.dx/anchorBounds.width)*rotationCorner;
    }else{
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect anchorBounds) {
    if(dragStart!=null){
      return dragStart-anchorBounds.topLeft;
    }else{
      return Offset(0.0,0.0);
    }
  }
}

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => new _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  _buildBackground() {
    return new PhotoBrowser(
      photoPaths: [
        'https://picsum.photos/800/600?image=1048',
        'https://picsum.photos/800/600?image=1049',
        'https://picsum.photos/800/600?image=1047',
        'https://picsum.photos/800/600?image=1046',
      ],
      visiblePhotoIndex: 2,
    );
  }

  _buildProfile() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ]),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'First Last',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    'some day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.info,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            )
          ]),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(10.0),
        child: new Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
              _buildProfile(),
            ],
          ),
        ),
      ),
    );
  }
}
