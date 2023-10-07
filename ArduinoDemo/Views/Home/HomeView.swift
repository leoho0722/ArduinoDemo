//
//  HomeView.swift
//  ArduinoDemo
//
//  Created by Leo Ho on 2023/10/7.
//

import SwiftUI

import LHSFSymbolsHelpers

struct HomeView: View {
    
    @State private var vm = HomeViewViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                // Section 0
                buildArduinoConnectSection()
                
                // Section 1
                buildLightControlSection(status: vm.connectState)
            }
        }
        .navigationTitle("Arduino Demo")
        .onAppear {
            vm.getConnectStatus()
        }
    }
}

#Preview {
    HomeView()
}

// MARK: - @ViewBuilder

private extension HomeView {
    
    /// 建構 `與 Arduino 連線狀態的` Section
    @ViewBuilder
     func buildArduinoConnectSection() -> some View {
        Section {
            HStack {
                Text(vm.connectState.statusTitle)
                Spacer()
                if vm.connectState == .connected {
                    Image(systemIcon: .checkmarkSealFill)
                        .foregroundStyle(.green)
                } else {
                    if vm.connectState == .notConnected {
                        Image(systemIcon: .xmarkSealFill)
                            .foregroundStyle(.red)
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
        } header: {
            Text("Connect Status")
        }
    }
    
    @ViewBuilder
    func buildUnavailableView(status: HomeViewViewModel.ConnectState) -> some View {
        ContentUnavailableView {
            if status == .notConnected {
                Label(status.statusTitle, systemIcon: .xmarkSealFill)
            } else if status == .connecting {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                    Text(status.statusTitle)
                        .font(.bold(.title2)())
                }
            }
        }
    }
    
    @ViewBuilder
     func buildLightControlSection(status: HomeViewViewModel.ConnectState) -> some View {
        Section {
            switch status {
            case .notConnected:
                buildUnavailableView(status: .notConnected)
            case .connecting:
                buildUnavailableView(status: .connecting)
            case .connected:
                GeometryReader { proxy in
                    HomeLightControlView()
                        .position(.init(x: proxy.size.width / 2, y: proxy.size.height / 2))
                }.frame(minHeight: 100)
            }
        } header: {
            Text("Light Control")
        }
    }
}
