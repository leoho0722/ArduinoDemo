//
//  HomeViewViewModel.swift
//  ArduinoDemo
//
//  Created by Leo Ho on 2023/10/7.
//

import Foundation

import SwiftHelpers

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
    func getConnectStatus() async {
        DispatchQueue.main.async {
            self.connectState = .connecting
        }
        
        let manager = NetworkManager.shared
        let baseURL = "http://"
        let ip = "192.168.1.212"
        let path = "/connect"
        let url = URL(string: baseURL + ip + path)!
        let request = GeneralRequest()
        
        do {
            let response: GeneralResponse = try await manager.requestData(with: url,
                                                                          method: .get,
                                                                          parameters: request)
            print(response.status)
            await MainActor.run {
                self.connectState = .connected
            }
        } catch {
            await MainActor.run {
                self.connectState = .notConnected
            }
        }
    }
}
