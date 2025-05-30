//
//  WebRTCManager.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 5/14/25.
//
import Foundation
import WebRTC
import AVFoundation

final class WebRTCManager: NSObject {
    
    // MARK: - Properties
    
    private let peerConnectionFactory: RTCPeerConnectionFactory
    private var peerConnection: RTCPeerConnection?
    private let signalingService: SignalingService
    
    var localVideoTrack: RTCVideoTrack?
    var localAudioTrack: RTCAudioTrack?
    
    var remoteVideoTrack: RTCVideoTrack?
    var remoteAudioTrack: RTCAudioTrack?
    
    var onRemoteVideoTrack: ((RTCVideoTrack) -> Void)?
    
    private var videoCapturer: RTCCameraVideoCapturer?
    private var isCapturing = false
    
    // MARK: - Init
    
    init(signalingService: SignalingService) {
        self.signalingService = signalingService
        RTCInitializeSSL()
        self.peerConnectionFactory = RTCPeerConnectionFactory()
        super.init()
        
        setupPeerConnection()
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Setup
    
    private func setupPeerConnection() {
        let config = RTCConfiguration()
        config.iceServers = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
        
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        peerConnection = peerConnectionFactory.peerConnection(with: config, constraints: constraints, delegate: self)
    }
    
    private func observeRemoteSignaling() {
        signalingService.observeRemoteSDP(
            onOffer: { [weak self] sdp in self?.handleRemoteOffer(sdp) },
            onAnswer: { [weak self] sdp in self?.handleRemoteAnswer(sdp) }
        )
        
        signalingService.observeRemoteCandidate { [weak self] candidate in
            self?.peerConnection?.add(candidate) { error in
                if let error = error {
                    print("[WebRTCManager] addCandidate error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Local Stream
    
    func startLocalStream(cameraPosition: AVCaptureDevice.Position = .front) -> RTCVideoTrack? {
        observeRemoteSignaling()
        let videoSource = peerConnectionFactory.videoSource()
        let audioSource = peerConnectionFactory.audioSource(with: nil)
        
        var videoTrack: RTCVideoTrack?
        
        #if targetEnvironment(simulator)
        print("📱 Simulator detected - skipping video capturer")
        #else
        let devices = RTCCameraVideoCapturer.captureDevices()
        if devices.isEmpty {
            print("⚠️ No camera devices found - skipping video setup")
        } else {
            videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
            videoTrack = peerConnectionFactory.videoTrack(with: videoSource, trackId: "video0")
            localVideoTrack = videoTrack
            startCapture(cameraPosition: cameraPosition)
        }
        #endif
        
        let audioTrack = peerConnectionFactory.audioTrack(with: audioSource, trackId: "audio0")
        localAudioTrack = audioTrack
        
        if let peerConnection = peerConnection {
            peerConnection.add(audioTrack, streamIds: ["stream"])
            if let videoTrack = videoTrack {
                peerConnection.add(videoTrack, streamIds: ["stream"])
            }
        }
        return videoTrack
    }
    
    func startCapture(fps: Int = 30, width: Int = 640, height: Int = 480, cameraPosition: AVCaptureDevice.Position = .front) {
        guard let capturer = videoCapturer else { return }
        
        if isCapturing {
            capturer.stopCapture { [weak self] in
                self?.isCapturing = false
                self?.startCaptureInternal(fps: fps, width: width, height: height, cameraPosition: cameraPosition)
            }
        } else {
            startCaptureInternal(fps: fps, width: width, height: height, cameraPosition: cameraPosition)
        }
    }
    
    private func startCaptureInternal(fps: Int, width: Int, height: Int, cameraPosition: AVCaptureDevice.Position) {
        guard let capturer = videoCapturer else { return }
        guard let device = RTCCameraVideoCapturer.captureDevices().first(where: { $0.position == cameraPosition }) else { return }
        
        let formats = RTCCameraVideoCapturer.supportedFormats(for: device)
        let selectedFormat = formats
            .filter {
                let dims = CMVideoFormatDescriptionGetDimensions($0.formatDescription)
                return dims.width == width && dims.height == height
            }
            .sorted {
                let maxFps1 = $0.videoSupportedFrameRateRanges.first?.maxFrameRate ?? 0
                let maxFps2 = $1.videoSupportedFrameRateRanges.first?.maxFrameRate ?? 0
                return maxFps1 > maxFps2
            }
            .first ?? formats.first!
        
        let fpsRange = selectedFormat.videoSupportedFrameRateRanges
        let selectedFps = fpsRange.first(where: { $0.minFrameRate <= Float64(fps) && Float64(fps) <= $0.maxFrameRate })?.maxFrameRate ?? 30
        
        capturer.startCapture(with: device, format: selectedFormat, fps: Int(selectedFps))
        isCapturing = true
    }
    
    // MARK: - Signaling Handlers
    
    func makeOffer() {
        let constraints = RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "true"], optionalConstraints: nil)
        
        peerConnection?.offer(for: constraints, completionHandler: { [weak self] sdp, error in
            if let error = error {
                print("[WebRTCManager] makeOffer error: \(error.localizedDescription)")
                return
            }
            guard let sdp = sdp else { return }
            
            self?.peerConnection?.setLocalDescription(sdp) { error in
                if let error = error {
                    print("[WebRTCManager] setLocalDescription error: \(error.localizedDescription)")
                }
            }
            
            print("📡 SDP makeOffer:\n\(sdp.sdp)")
            self?.signalingService.sendOffer(sdp)
        })
    }
    
    private func makeAnswer() {
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        peerConnection?.answer(for: constraints, completionHandler: { [weak self] sdp, error in
            if let error = error {
                print("[WebRTCManager] makeAnswer error: \(error.localizedDescription)")
                return
            }
            guard let sdp = sdp else { return }
            
            self?.peerConnection?.setLocalDescription(sdp) { error in
                if let error = error {
                    print("[WebRTCManager] setLocalDescription (answer) error: \(error.localizedDescription)")
                }
            }
            
            print("📡 SDP makeAnswer:\n\(sdp.sdp)")
            self?.signalingService.sendAnswer(sdp)
        })
    }
    
    private func handleRemoteOffer(_ sdp: RTCSessionDescription) {
        guard peerConnection?.signalingState == .stable else {
            print("⚠️ Ignored offer due to bad signaling state handleRemoteOffer: \(String(describing: peerConnection?.signalingState.rawValue))")
            return
        }
        print("tạo: \(String(describing: self.peerConnection?.signalingState.rawValue)) ", sdp)
        peerConnection?.setRemoteDescription(sdp) { [weak self] error in
            if let error = error {
                print("[WebRTCManager] setRemoteDescription (offer) error: \(error.localizedDescription)")
                return
            }
            self?.makeAnswer()
        }
    }
    
    private func handleRemoteAnswer(_ sdp: RTCSessionDescription) {
        guard peerConnection?.signalingState == .haveLocalOffer else {
            print("⚠️ Ignored offer due to bad signaling state handleRemoteAnswer: \(String(describing: peerConnection?.signalingState.rawValue))")
            return
        }
        print("join: \(String(describing: self.peerConnection?.signalingState.rawValue)) ", sdp)
        peerConnection?.setRemoteDescription(sdp) { error in
            if let error = error {
                print("[WebRTCManager] setRemoteDescription (answer) error: \(error.localizedDescription)")
            }
        }
    }

    
    // MARK: - Controls
    
    func setMic(enabled: Bool) {
        localAudioTrack?.isEnabled = enabled
    }
    
    func stop() {
        if isCapturing {
            videoCapturer?.stopCapture(completionHandler: {})
            isCapturing = false
        }
        peerConnection?.close()
        peerConnection = nil
        
        localVideoTrack = nil
        localAudioTrack = nil
        remoteVideoTrack = nil
        remoteAudioTrack = nil
    }
}

// MARK: - RTCPeerConnectionDelegate

extension WebRTCManager: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        DispatchQueue.main.async { [weak self] in
            self?.remoteVideoTrack = stream.videoTracks.first
            if let remoteTrack = stream.videoTracks.first {
                self?.onRemoteVideoTrack?(remoteTrack)
            }
            self?.remoteAudioTrack = stream.audioTracks.first
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd receiver: RTCRtpReceiver, streams: [RTCMediaStream]) {
        print("🔥 didAdd receiver called")
        if let track = receiver.track as? RTCVideoTrack {
            DispatchQueue.main.async { [weak self] in
                self?.remoteVideoTrack = track
                self?.onRemoteVideoTrack?(track)
            }
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        signalingService.sendCandidate(candidate)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}
}
