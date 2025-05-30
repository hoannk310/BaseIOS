//
//  ViewModel.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//

import RxSwift
import RxCocoa
import WebRTC

class ViewModel: BaseViewModelType {
    private let webRTCManager: WebRTCManager
    let errorTracker = ErrorTracker()
    
    private let remoteVideoRelay = BehaviorRelay<RTCVideoTrack?>(value: nil)
    private let localVideoRelay = BehaviorRelay<RTCVideoTrack?>(value: nil)
    private var isMicEnable = true
    
    init(roomId: String = "room1") {
        self.webRTCManager = WebRTCManager(signalingService: FirebaseSignalingService(roomId: roomId))        
        self.webRTCManager.onRemoteVideoTrack = { [weak self] track in
            self?.remoteVideoRelay.accept(track)
        }
    }
    
    func transform(input: Input) -> Output {
        let localVideoStart = input.start
            .flatMapLatest { [weak self] _ -> Observable<RTCVideoTrack?> in
                guard let self = self else { return Observable.just(nil) }
                if let localTrack = self.webRTCManager.startLocalStream() {
                    self.webRTCManager.makeOffer()
                    return Observable.just(localTrack)
                } else {
                    return Observable.just(nil)
                }
            }
        
        let localVideoJoin = input.join
            .flatMapLatest { [weak self] _ -> Observable<RTCVideoTrack?> in
                guard let self = self else { return Observable.just(nil) }
                if let localTrack = self.webRTCManager.startLocalStream() {
                    return Observable.just(localTrack)
                } else {
                    return Observable.just(nil)
                }
            }
        
        let localVideo = Observable.merge(localVideoStart, localVideoJoin)
            .do(onNext: { [weak self] track in
                self?.localVideoRelay.accept(track)
            })
            .mapToVoid()
        
        let setMic = input.setMic
            .do(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.isMicEnable.toggle()
                self.webRTCManager.setMic(enabled: isMicEnable)
            })
            .mapToVoid()
        
        let emptyOutput: Observable<Void> = Observable.merge(localVideo, setMic)
        
        return Output(
            localVideoOutput: localVideoRelay.asDriverOnErrorJustComplete(),
            remoteVideoOutput: remoteVideoRelay.asDriverOnErrorJustComplete(),
            emptyOutput: emptyOutput.asDriverOnErrorJustComplete()
        )
    }
}

extension ViewModel {
    struct Input {
        let start: Observable<Void>
        let join: Observable<Void>
        let setMic: Observable<Void>
    }
    struct Output {
        let localVideoOutput: Driver<RTCVideoTrack?>
        let remoteVideoOutput: Driver<RTCVideoTrack?>
        let emptyOutput: Driver<Void>
    }
}
