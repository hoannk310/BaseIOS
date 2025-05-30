//
//  SignalingService.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 5/28/25.
//
import Foundation
import WebRTC

protocol SignalingService {
    func sendOffer(_ sdp: RTCSessionDescription)
    func sendAnswer(_ sdp: RTCSessionDescription)
    func sendCandidate(_ candidate: RTCIceCandidate)
    func observeRemoteSDP(onOffer: @escaping (RTCSessionDescription) -> Void,
                          onAnswer: @escaping (RTCSessionDescription) -> Void)
    func observeRemoteCandidate(_ onCandidate: @escaping (RTCIceCandidate) -> Void)
}
