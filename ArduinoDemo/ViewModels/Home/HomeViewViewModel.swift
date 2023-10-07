//
//  HomeViewViewModel.swift
//  ArduinoDemo
//
//  Created by Leo Ho on 2023/10/7.
//

import Foundation

import LHSFSymbolsHelpers

@Observable
final class HomeViewViewModel {
    
    /// 與 Arduino 的連線狀態
    var connectState: ConnectState = .notConnected
    
    enum ConnectState {
        
        /// 尚未連線到 Arduino
        case notConnected
        
        /// 與 Arduino 正在連線中
        case connecting
        
        /// 已連線到 Arduino
        case connected
        
        var statusTitle: String {
            switch self {
            case .notConnected:
                "尚未連線到 Arduino"
            case .connecting:
                "與 Arduino 正在連線中..."
            case .connected:
                "已連線到 Arduino"
            }
        }
    }
    
    /// 取得與 Arduino 的連線狀態
    func getConnectStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.connectState = .connecting
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.connectState = .connected
        }
    }
}
