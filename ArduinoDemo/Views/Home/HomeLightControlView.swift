//
//  HomeLightControlView.swift
//  ArduinoDemo
//
//  Created by Leo Ho on 2023/10/7.
//

import Combine
import SwiftUI

import LHSFSymbolsHelpers

struct HomeLightControlView: View {

    private let imgNameAry: [SFSymbols] = Array(repeating: .lightbulbFill, count: 6)
    
    @State private var vm = HomeLightControlViewViewModel()
    
    /// 用來判斷右旋的目前 Index
    @State private var currentLeftToRightIndex: Int = -1
    
    /// 用來判斷左旋的目前 Index
    @State private var currentRightToLeftIndex: Int = 6
    
    @State private var timer: AnyCancellable?
    
    var body: some View {
        buildLightControl()
    }
}

#Preview {
    HomeView()
}

// MARK: - @ViewBuilder

extension HomeLightControlView {
    
    @ViewBuilder
    private func buildLightControl() -> some View {
        VStack {
            if vm.chosedMarqueeEffect != .rightToLeft {
                HStack {
                    ForEach(imgNameAry.indices, id: \.self) { imgIndex in
                        Image(systemIcon: imgNameAry[imgIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundStyle(imgIndex == currentLeftToRightIndex ? .red : .black)
                    }
                }
            } else {
                HStack {
                    ForEach(imgNameAry.reversed().indices, id: \.self) { imgIndex in
                        Image(systemIcon: imgNameAry[imgIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundStyle(imgIndex == currentRightToLeftIndex ? .red : .black)
                    }
                }
            }
            
            Menu {
                ForEach(HomeLightControlViewViewModel.MarqueeEffects.allCases) { effect in
                    Button {
                        vm.chosedMarqueeEffect = effect
                        
                        switch effect {
                        case .none:
                            currentLeftToRightIndex = -1
                            currentRightToLeftIndex = 6
                            resetTimer()
                        case .leftToRight, .rightToLeft:
                            timer = Timer.publish(every: 1, on: .main, in: .common)
                                .autoconnect()
                                .sink { _ in
                                    withAnimation {
                                        lightControl(with: effect)
                                    }
                                }
                        }
                    } label: {
                        Text(effect.title)
                    }
                }
            } label: {
                Text(vm.chosedMarqueeEffect.title)
            }
            .padding(.top)
        }
    }
}

// MARK: - Private Function

private extension HomeLightControlView {
    
    func lightControl(with effect: HomeLightControlViewViewModel.MarqueeEffects) {
        if effect == .leftToRight {
            guard currentLeftToRightIndex != 5 else {
                resetTimer()
                currentLeftToRightIndex = -1
                vm.chosedMarqueeEffect = .none
                return
            }
            currentLeftToRightIndex = (currentLeftToRightIndex + 1) % imgNameAry.count
            print("index：\(currentLeftToRightIndex)")
        } else if effect == .rightToLeft {
            guard currentRightToLeftIndex != 0 else {
                resetTimer()
                currentRightToLeftIndex = 6
                vm.chosedMarqueeEffect = .none
                return
            }
            currentRightToLeftIndex = (currentRightToLeftIndex + 5) % imgNameAry.count
            print("index：\(currentRightToLeftIndex)")
        }
    }
    
    /// 取消 Timer 的 Subscription
    func resetTimer() {
        if let timer {
            timer.cancel()
        }
    }
}
