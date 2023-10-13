//
//  HomeLightControlViewViewModel.swift
//  ArduinoDemo
//
//  Created by Leo Ho on 2023/10/7.
//

import Foundation

@Observable
final class HomeLightControlViewViewModel {
    
    /// 選擇到的跑馬燈效果
    var chosedMarqueeEffect: MarqueeEffects = .none
    
    /// 跑馬燈效果
    enum MarqueeEffects: Int, CaseIterable, Identifiable {
        
        /// 尚未選擇
        case none = 0
        
        /// 跑馬燈右旋
        case leftToRight = 1
        
        /// 跑馬燈左旋
        case rightToLeft = 2
        
        /// 跑馬燈全亮
        case on
        
        /// 跑馬燈全暗
        case off
        
        var id: Int { rawValue }
        
        var title: String {
            switch self {
            case .none: "尚未選擇"
            case .leftToRight: "跑馬燈效果 (右旋)"
            case .rightToLeft: "跑馬燈效果 (左旋)"
            case .on: "全亮"
            case .off: "全暗"
            }
        }
        
        var url: String {
            switch self {
            case .none: ""
            case .leftToRight: "/light/right"
            case .rightToLeft: "/light/left"
            case .on: "/light/on"
            case .off: "/light/off"
            }
        }
    }
    
    func send(effect: MarqueeEffects) async throws {
        guard effect != .none else {
            return
        }
        let manager = NetworkManager.shared
        let baseURL = "http://"
        let ip = "192.168.1.212"
        let url = URL(string: baseURL + ip + effect.url)!
        let request = GeneralRequest()
        let response: GeneralResponse = try await manager.requestData(with: url,
                                                                      method: .get,
                                                                      parameters: request)
        print(response.status)
    }
}
