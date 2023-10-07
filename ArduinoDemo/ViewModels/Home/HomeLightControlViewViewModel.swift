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
        
        var id: Int { rawValue }
        
        var title: String {
            switch self {
            case .none:
                "尚未選擇"
            case .leftToRight:
                "跑馬燈效果 (右旋)"
            case .rightToLeft:
                "跑馬燈效果 (左旋)"
            }
        }
    }
}
