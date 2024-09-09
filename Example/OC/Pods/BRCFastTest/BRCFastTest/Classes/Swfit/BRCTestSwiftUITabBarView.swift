//
//  BRCTestTabBarView.swift
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/15.
//

import SwiftUI

@available(iOS 13.0,*)
public struct BRCTestSwiftUITabBarItem<ContentView> : Equatable where ContentView : View{
    
    static public func == (lhs: BRCTestSwiftUITabBarItem<ContentView>, rhs: BRCTestSwiftUITabBarItem<ContentView>) -> Bool {
        return lhs.title == rhs.title;
    }
    
    var title : String?;
    var image : UIImage?;
    var contentView : (() -> ContentView)
    public init(title: String? = nil, image: UIImage? = nil,@ViewBuilder contentView: @escaping () -> ContentView) {
        self.title = title
        self.image = image
        self.contentView = contentView
    }
    
}

@available(iOS 13.0,*)
public struct BRCTestSwiftUITabBarView<ContentView : View> : View {
    
    @State var currentSelectIndex : Int =  0;
    
    var tabBarItems : [BRCTestSwiftUITabBarItem<ContentView>]
    
    public init(tabBarItems: [BRCTestSwiftUITabBarItem<ContentView>]) {
        self.tabBarItems = tabBarItems
    }
    
    public var body: some View {
        ZStack {
            
            if (currentSelectIndex < tabBarItems.count) {
                tabBarItems[currentSelectIndex].contentView();
            } else {
                Text("UnKown View")
            }
            
            VStack {
                Spacer()
                BRCTestSwiftUITabBar<ContentView>(currentSelectIndex: $currentSelectIndex,tabBarItems: tabBarItems);
            }
        }
    }
}

@available(iOS 13.0,*)
public struct BRCTestSwiftUITabBar<ContentView : View> : View {
    
    @Binding var currentSelectIndex : Int
    
    var tabBarItems : [BRCTestSwiftUITabBarItem<ContentView>]
    
    public var body: some View {
        VStack {
            HStack(alignment: .center,spacing: 10) {
                ForEach(Array(tabBarItems.enumerated()),id: \.offset) { index,item in
                    Spacer()
                    BRCTestSwiftUITabBarItemView(title: item.title,image: item
                        .image,index: index, onSelected: {
                            currentSelectIndex = index;
                        }, currentSelectIndex: $currentSelectIndex);
                    Spacer()
                }
            }
        }
        .frame(height: 48)
        .background(Color.brtest_contentWhite())
    }
}

@available(iOS 13.0,*)
public struct BRCTestSwiftUITabBarItemView : View {
    
    var title : String?
    var image : UIImage?
    var index : Int
    var onSelected : (() -> ())
    @Binding var currentSelectIndex : Int
    
    public var body: some View {
        VStack {
            if (image != nil) {
                Image(uiImage: image!)
                    .renderingMode(.template)
                    .foregroundColor(currentSelectIndex == index ? Color.brtest_black() : Color.brtest_gray())
            }
            if (title != nil) {
                Text(title!)
                    .foregroundColor(currentSelectIndex == index ? Color.brtest_black() : Color.brtest_gray())
                    .font(.footnote)
            }
        }
        .onTapGesture {
            onSelected();
        }
    }
}
