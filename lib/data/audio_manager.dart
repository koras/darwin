import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';

class AudioManager {
  static final AudioPlayer _player = AudioPlayer();
  static bool _soundsEnabled = true;

  static Soundpool? _soundpool;
  static AudioPlayer? _webPlayer;
  static int? _soundId;

  static void toggleSounds(bool enabled) {
    _soundsEnabled = enabled;
  }

  static Future<void> playAddItemSound() async {
    try {
      await _player.stop();
      await _player.setVolume(0.3);
      await _player.play(UrlSource('assets/sounds/add3.mp3'));
      //     if (!_soundsEnabled) return;
      //     await _player.play(AssetSource('sounds/fail_merge.ogg'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playClearSound() async {
    try {
      await _player.stop();
      await _player.setVolume(0.3);
      await _player.play(UrlSource('assets/sounds/clear.mp3'));
      //     if (!_soundsEnabled) return;
      //     await _player.play(AssetSource('sounds/fail_merge.ogg'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  /// неудачное слияние
  static Future<void> playMergeFailSound() async {
    try {
      await _player.stop();
      await _player.setVolume(0.3);
      await _player.play(UrlSource('assets/sounds/fail_merge.mp3'));
      //     if (!_soundsEnabled) return;
      //     await _player.play(AssetSource('sounds/fail_merge.ogg'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  ///
  static Future<void> playOpenHintSound() async {
    try {
      await _player.stop();
      await _player.setVolume(0.3);
      await _player.play(UrlSource('assets/sounds/hint.mp3'));
      //     if (!_soundsEnabled) return;
      //     await _player.play(AssetSource('sounds/fail_merge.ogg'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playNextLevelSound() async {
    try {
      await _player.stop();
      await _player.setVolume(0.7);
      await _player.play(UrlSource('assets/sounds/next_level.mp3'));
      //     if (!_soundsEnabled) return;
      //     await _player.play(AssetSource('sounds/fail_merge.ogg'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playMergeGoodSound() async {
    try {
      print('playing sound');
      await _player.stop();
      await _player.setVolume(0.5);
      if (kIsWeb) {
        print('kIsWeb');
        //     _webPlayer = AudioPlayer();

        await _player.play(UrlSource('assets/sounds/merge_good.mp3'));
      } else {
        print('mp3');
        _soundpool = Soundpool.fromOptions();
        _soundId = await rootBundle
            .load('assets/sounds/merge_good2.mp3')
            .then((data) => _soundpool!.load(data));
      }
      debugPrint('Sound playback started');
      //  if (!_soundsEnabled) return;
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // static Future<void> playErrorSound() async {
  //   if (!_soundsEnabled) return;
  //   await _player.play(AssetSource('sounds/error.mp3'));
  // }
}
