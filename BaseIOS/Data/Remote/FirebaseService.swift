//
//  FirebaseSignalingService.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 5/29/25.
//

import WebRTC
import FirebaseDatabase

class FirebaseSignalingService {
    private let db: DatabaseReference
    private let roomId: String
    
    private var onOffer: ((RTCSessionDescription) -> Void)?
    private var onAnswer: ((RTCSessionDescription) -> Void)?
    private var onCandidate: ((RTCIceCandidate) -> Void)?
    
    init(roomId: String) {
        self.roomId = roomId
        Database.database().reference().child("rooms").child(roomId).removeValue()
        self.db = Database.database().reference().child("rooms").child(roomId)
    }
    
    private func sdpTypeFrom(value: Int) -> RTCSdpType? {
        switch value {
        case 0: return .offer
        case 2: return .answer
        case 1: return .prAnswer
        case 3: return .rollback
        default: return nil
        }
    }

    private func observeSDP() {
        db.child("offer").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let val = snapshot.value as? [String: Any],
                  let typeStr = val["type"] as? Int,
                  let sdpStr = val["sdp"] as? String,
                  let sdpType = self.sdpTypeFrom(value: typeStr)
            else { return }
            
            let sdp = RTCSessionDescription(type: sdpType, sdp: sdpStr)
            self.onOffer?(sdp)
        }

        db.child("answer").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let val = snapshot.value as? [String: Any],
                  let typeStr = val["type"] as? Int,
                  let sdpStr = val["sdp"] as? String,
                  let sdpType = self.sdpTypeFrom(value: typeStr)
            else { return }
            
            let sdp = RTCSessionDescription(type: sdpType, sdp: sdpStr)
            self.onAnswer?(sdp)
        }
    }

    private func observeCandidate() {
        db.child("candidates").observe(.childAdded) { [weak self] snapshot in
            guard let self = self,
                  let val = snapshot.value as? [String: Any],
                  let sdpMid = val["sdpMid"] as? String,
                  let sdpMLineIndex = val["sdpMLineIndex"] as? Int32,
                  let candidateStr = val["candidate"] as? String
            else { return }
            
            let candidate = RTCIceCandidate(sdp: candidateStr, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
            self.onCandidate?(candidate)
        }
    }
}

extension FirebaseSignalingService: SignalingService {
    func sendOffer(_ sdp: RTCSessionDescription) {
        let sdpDict: [String: Any] = [
            "type": sdp.type.rawValue,
            "sdp": sdp.sdp
        ]
        db.child("offer").setValue(sdpDict)
    }

    func sendAnswer(_ sdp: RTCSessionDescription) {
        let sdpDict: [String: Any] = [
            "type": sdp.type.rawValue,
            "sdp": sdp.sdp
        ]
        db.child("answer").setValue(sdpDict)
    }

    func sendCandidate(_ candidate: RTCIceCandidate) {
        let candidateDict: [String: Any] = [
            "sdpMid": candidate.sdpMid ?? "",
            "sdpMLineIndex": candidate.sdpMLineIndex,
            "candidate": candidate.sdp
        ]
        db.child("candidates").childByAutoId().setValue(candidateDict)
    }

    func observeRemoteSDP(
        onOffer: @escaping (RTCSessionDescription) -> Void,
        onAnswer: @escaping (RTCSessionDescription) -> Void
    ) {
        self.onOffer = onOffer
        self.onAnswer = onAnswer
        observeSDP()
    }

    func observeRemoteCandidate(
        _ onCandidate: @escaping (RTCIceCandidate) -> Void
    ) {
        self.onCandidate = onCandidate
        observeCandidate()
    }
}
