import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CustomVideoPlayerComponent extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayerComponent({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<CustomVideoPlayerComponent> createState() =>
      _CustomVideoPlayerComponentState();
}

class _CustomVideoPlayerComponentState
    extends State<CustomVideoPlayerComponent> {
  late CachedVideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  late CustomVideoPlayerWebController _customVideoPlayerWebController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _videoPlayerController = CachedVideoPlayerController.asset(
      widget.videoUrl,
    )..initialize().then((_) {
        setState(() {}); // Update the UI once the controller is initialized
      });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );

    if (kIsWeb) {
      _customVideoPlayerWebController = CustomVideoPlayerWebController(
        webVideoPlayerSettings: CustomVideoPlayerWebSettings(
          src: widget.videoUrl,
        ),
      );
    }
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? CustomVideoPlayerWeb(
            customVideoPlayerWebController: _customVideoPlayerWebController,
          )
        : CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController,
          );
  }
}
