library appinio_video_player;

export 'package:cached_video_player/cached_video_player.dart';
export 'src/custom_video_player.dart';
export 'src/web_video_player/conditional_native_web_video_player/conditional_native_web_video_player.dart';
export 'src/models/custom_video_player_progress_bar_settings.dart';
export 'src/models/custom_video_player_settings.dart';
export 'src/custom_video_player_controller.dart'
    hide ProtectedCustomVideoPlayerController;

// web exports
export 'src/web_video_player/custom_video_player_web.dart';
export 'src/web_video_player/custom_video_player_web_controller.dart';
export 'src/web_video_player/web_video_player_settings.dart';
