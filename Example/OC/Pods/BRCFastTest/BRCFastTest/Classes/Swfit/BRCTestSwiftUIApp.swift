//
//  BRCTestSwiftUIApp.swift
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/15.
//

import SwiftUI

@available(iOS 13.0,*)
struct BRCDebugButtonView: View {
    var onClickDebugButton : (() -> ())
    @State private var offset: CGSize = .init(width: -10, height: 0)
    @State private var startLocation: CGSize = .zero

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "hammer")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.brtest_red())
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .clipped()
                    .offset(x: offset.width, y: offset.height)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { gesture in
                                // 基于起始位置更新 offset，保持每次拖动都是叠加效果
                                self.offset = CGSize(
                                    width: self.startLocation.width + gesture.translation.width,
                                    height: self.startLocation.height + gesture.translation.height
                                )
                            }
                            .onEnded { _ in
                                // 拖动结束时保存最终位置，并执行吸附动画
                                self.startLocation = self.offset

                                withAnimation {
                                    if (offset.width < -kBRCScreenWidth / 2) {
                                        // 吸附到左边
                                        offset.width = -kBRCScreenWidth + 10 + 50
                                    } else {
                                        // 吸附到右边
                                        offset.width = -10
                                    }
                                    if (offset.height > 0) {
                                        offset.height = 0;
                                    }
                                    if (offset.height < -kBRCScreenHeight + 50 + 100) {
                                        offset.height = -kBRCScreenHeight + 50 + 100;
                                    }
                                }

                                // 更新起始位置
                                self.startLocation = self.offset
                            }
                        )
                        .onTapGesture {
                            onClickDebugButton()
                        }
            }
        }
    }
}

@available(iOS 13.0,*)
public struct BRCMainContentView<ContentView> : View where ContentView : View{
    var contentView : (() -> ContentView)
    var onClickDebugButton : (() -> ())
    public init(@ViewBuilder contentView: @escaping () -> ContentView, onClickDebugButton: @escaping () -> Void) {
        self.contentView = contentView
        self.onClickDebugButton = onClickDebugButton
    }
    public var body: some View {
        ZStack {
            contentView();
            BRCDebugButtonView(onClickDebugButton: onClickDebugButton);
        }
    }
}

extension String {
    static public func brctest_localizableWithKey(_ key : String) -> String{
        return NSLocalizedString(key,comment: "");
    }
    
    static public func brctest_localizationStringWithFormat(key: String, _ args: CVarArg...) -> String {
        // 获取本地化字符串
        let localizedString = NSLocalizedString(key, comment: "")

        // 检查本地化字符串中是否包含占位符
        if localizedString.contains("%@") {
            // 使用 String(format:) 将参数插入到占位符
            let formattedString = String(format: localizedString, arguments: args)
            
            // 去除换行符和空格
            let cleanedString = formattedString.replacingOccurrences(of: "\n", with: "")
                                                .replacingOccurrences(of: " ", with: "")
            return cleanedString
        }

        // 如果没有占位符，直接返回本地化字符串
        return localizedString
    }
}


