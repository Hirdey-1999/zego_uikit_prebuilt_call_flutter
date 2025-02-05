part of 'package:zego_uikit_prebuilt_call/src/invitation/service.dart';

/// @nodoc
mixin ZegoCallInvitationServiceIOSCallKitPrivatePrivate {
  final _iOSCallkitImpl =
      ZegoCallInvitationServiceIOSCallKitPrivatePrivateImpl();

  ZegoCallInvitationServiceIOSCallKitPrivatePrivateImpl get iOSCallkit =>
      _iOSCallkitImpl;
}

/// Here are the APIs related to invitation.
class ZegoCallInvitationServiceIOSCallKitPrivatePrivateImpl {
  ///
  bool _iOSCallKitServiceInit = false;

  /// callkit event subscriptions
  final List<StreamSubscription<dynamic>> _callkitServiceSubscriptions = [];

  /// init callkit service
  void _initIOSCallkitService() {
    if (_iOSCallKitServiceInit) {
      ZegoLoggerService.logInfo(
        'callkit service had been init',
        tag: 'call',
        subTag: 'iOS callkit service',
      );

      return;
    }

    _iOSCallKitServiceInit = true;
    _callkitServiceSubscriptions
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitProviderDidResetEventStream()
          .listen(_onCallkitProviderDidResetEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitProviderDidBeginEventStream()
          .listen(_onCallkitProviderDidBeginEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitActivateAudioEventStream()
          .listen(_onCallkitActivateAudioEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitDeactivateAudioEventStream()
          .listen(_onCallkitDeactivateAudioEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitTimedOutPerformingActionEventStream()
          .listen(_onCallkitTimedOutPerformingActionEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitPerformStartCallActionEventStream()
          .listen(_onCallkitPerformStartCallActionEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitPerformAnswerCallActionEventStream()
          .listen(_onCallkitPerformAnswerCallActionEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitPerformEndCallActionEventStream()
          .listen(_onCallkitPerformEndCallActionEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitPerformSetHeldCallActionEventStream()
          .listen(_onCallkitPerformSetHeldCallActionEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitPerformSetMutedCallActionEventStream()
          .listen(_onCallkitPerformSetMutedCallActionEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitPerformSetGroupCallActionEventStream()
          .listen(_onCallkitPerformSetGroupCallActionEvent))
      ..add(ZegoUIKit()
          .getSignalingPlugin()
          .getCallkitPerformPlayDTMFCallActionEventStream()
          .listen(_onCallkitPerformPlayDTMFCallActionEvent));

    ZegoLoggerService.logInfo(
      'service has been inited',
      tag: 'call',
      subTag: 'iOS callkit service',
    );
  }

  /// un-init callkit service
  void _uninitIOSCallkitService() {
    if (!_iOSCallKitServiceInit) {
      ZegoLoggerService.logInfo(
        'callkit service had not been init',
        tag: 'call',
        subTag: 'iOS callkit service',
      );

      return;
    }

    _iOSCallKitServiceInit = false;
    for (final subscription in _callkitServiceSubscriptions) {
      subscription.cancel();
    }

    ZegoLoggerService.logInfo(
      'service has been uninited',
      tag: 'call',
      subTag: 'iOS callkit service',
    );
  }

  void _onCallkitProviderDidResetEvent(
    ZegoSignalingPluginCallKitVoidEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit provider did reset',
      tag: 'call',
      subTag: 'iOS callkit service',
    );
  }

  void _onCallkitProviderDidBeginEvent(
    ZegoSignalingPluginCallKitVoidEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit provider did begin',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    ZegoCallPluginPlatform.instance.activeAudioByCallKit();
  }

  void _onCallkitActivateAudioEvent(
    ZegoSignalingPluginCallKitVoidEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit activate audio',
      tag: 'call',
      subTag: 'iOS callkit service',
    );
  }

  void _onCallkitDeactivateAudioEvent(
    ZegoSignalingPluginCallKitVoidEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit deactivate audio',
      tag: 'call',
      subTag: 'iOS callkit service',
    );
  }

  void _onCallkitTimedOutPerformingActionEvent(
    ZegoSignalingPluginCallKitActionEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit timeout performing action',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    event.action.fulfill();

    ZegoCallKitBackgroundService().setIOSCallKitCallingDisplayState(false);
  }

  void _onCallkitPerformStartCallActionEvent(
    ZegoSignalingPluginCallKitActionEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit perform start call action',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    ZegoCallPluginPlatform.instance.activeAudioByCallKit();

    event.action.fulfill();

    ZegoCallKitBackgroundService().setIOSCallKitCallingDisplayState(false);
  }

  void _onCallkitPerformAnswerCallActionEvent(
    ZegoSignalingPluginCallKitActionEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit perform answer call action',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    ZegoCallPluginPlatform.instance.activeAudioByCallKit();

    event.action.fulfill();

    ZegoCallKitBackgroundService().setIOSCallKitCallingDisplayState(false);

    getOfflineCallKitCallID().then((callKitCallID) {
      ZegoCallKitBackgroundService()
          .acceptCallKitIncomingCauseInBackground(callKitCallID);
      clearOfflineCallKitCallID();
    });
  }

  void _onCallkitPerformEndCallActionEvent(
    ZegoSignalingPluginCallKitActionEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit perform end call call action',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    event.action.fulfill();

    ZegoCallKitBackgroundService().setIOSCallKitCallingDisplayState(false);

    if (ZegoUIKitPrebuiltCallInvitationService().isInCalling) {
      /// exit call
      ZegoCallKitBackgroundService().handUpCurrentCallByCallKit();
    } else {
      /// There is no need to clear CallKit here;  manually clear the CallKit ID.
      ///
      /// This is because offline calls on iOS will wake up the app,
      /// and when you reject the call for the first time,
      /// you need to wait for a certain period of time for the refusal callback.
      /// Otherwise, it will automatically reject the second offline call that comes immediately after.
      clearOfflineCallKitCallID();

      /// refuse call request
      ZegoCallKitBackgroundService().refuseInvitationInBackground(
        needClearCallKit: false,
      );
    }
  }

  void _onCallkitPerformSetHeldCallActionEvent(
    ZegoSignalingPluginCallKitActionEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit perform set held call action',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    event.action.fulfill();
  }

  void _onCallkitPerformSetMutedCallActionEvent(
    ZegoSignalingPluginCallKitSetMutedCallActionEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit perform set muted call action',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    event.action.fulfill();

    ZegoUIKit().turnMicrophoneOn(!event.action.muted);
  }

  void _onCallkitPerformSetGroupCallActionEvent(
    ZegoSignalingPluginCallKitActionEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit perform set group call action',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    event.action.fulfill();
  }

  void _onCallkitPerformPlayDTMFCallActionEvent(
    ZegoSignalingPluginCallKitActionEvent event,
  ) {
    ZegoLoggerService.logInfo(
      'on callkit perform play DTMF call action',
      tag: 'call',
      subTag: 'iOS callkit service',
    );

    event.action.fulfill();
  }
}
