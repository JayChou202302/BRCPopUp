//
//  ContentView.swift
//  BRCPopUp_SwiftUI
//
//  Created by sunzhixiong on 2024/8/12.
//

import SwiftUI
import BRCPopUp
import BRCFastTest

struct TagView : View {
    var backgroundColor : Color
    var text : String
    init(_ backgroundColor: Color,_ text: String) {
        self.backgroundColor = backgroundColor
        self.text = text
    }
    var body: some View {
        Text(NSString.brctest_localizable(withKey: text))
            .font(.footnote)
            .fontWeight(.bold)
            .foregroundColor(.brtest_white())
            .padding(.init(top: 3, leading: 5, bottom: 3, trailing: 5))
            .background(backgroundColor)
            .cornerRadius(4)
            .clipped()
    }
}

struct MenuButton : View {
    var menuArray : [String]
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                VStack(spacing: 10){
                    ForEach(Array(menuArray.enumerated()),id:\.offset) { index,item in
                        Button {
                            
                        } label: {
                            Text(item)
                                .foregroundColor(.brtest_black())
                                .background(.clear)
                        }
                    }
                }
                Spacer()
            }
            .padding(.vertical,5)
            .background(.clear)
        }
    }
}

struct MainView: View {
    
    @State var isLeftNavigationItemPresent : Bool = false;
    @State var isRightNavigationItemPresent : Bool = false;
    
    @State var isTest1Present : Bool = false;
    @State var isTest2Present : Bool = false;
    @State var isTest3Present : Bool = false;
    @State var isTest4Present : Bool = false;
    
    func GetTest2AttributedText() -> NSAttributedString{
        let string =  "SwiftUI helps you build great-looking apps across all Apple platforms with the power of Swift — and surprisingly little code. You can bring even better experiences to everyone, on any Apple device, using just one set of tools and APIs.";
        let attributedText = NSMutableAttributedString.init(string:string,attributes: [
            .foregroundColor : UIColor.brtest_black,
            .font            : UIFont.boldSystemFont(ofSize: 15.0)
        ]);
        attributedText.addAttributes([
            .foregroundColor : UIColor.brtest_red,
        ], range: .init(location: 0, length: 7))
        return attributedText;
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 5) {
                    HStack {
                       TagView(.brtest_red(),"Objective-C")
                       TagView(.brtest_orange(),"Swift")
                       TagView(.brtest_green(),"SwiftUI")
                        TagView(.brtest_cyan(),"key.tag.api.useful")
                        TagView(.brtest_deepPink(),"key.tag.api.easy.use")
                       Spacer()
                    }
                    HStack {
                        TagView(.brtest_gold(),"key.tag.api.ios.available")
                        Spacer()
                    }
                    HStack {
                        Text(String.brctest_localizableWithKey("key.test.label.01"))
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    
                    Text(String.brctest_localizableWithKey("key.test.button.click.me"))
                        .frame(width: 100, height: 40)
                        .background(Color.brtest_red())
                        .cornerRadius(4)
                        .clipped()
                        .foregroundColor(.brtest_white())
                        .onTapGesture {
                            isTest1Present.toggle()
                        }
                        .brc_popUpTip(isPresented: $isTest1Present, tipText: "SwiftUI 是为不同Apple 平台构建App 的最佳方式。了解用于自定App 外观和使用感受的新增功能，以及UIKit 和AppKit 在构建动画和手势方面增强的互操作性。") {
                            $0
                                .contentInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .shadowOffset(.init(width: 0, height: 3))
                                .shadowRadius(10.0)
                                .shadowColor(.brtest_black.withAlphaComponent(0.2))
                                .backgroundColor(.brtest_contentWhite)
                                .textFont(.boldSystemFont(ofSize: 16.0))
                                .textColor(.brtest_orange)
                                .fitSize(.init(width: kBRCScreenWidth / 2, height: .infinity))
                        }
                    
                    HStack {
                        Text(String.brctest_localizableWithKey("key.test.label.02"))
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    .padding(.top)
                    
                    Text(String.brctest_localizableWithKey("key.test.button.click.me"))
                        .frame(width: 100, height: 40)
                        .background(Color.brtest_red())
                        .cornerRadius(4)
                        .clipped()
                        .foregroundColor(.brtest_white())
                        .brc_popUpTip(isPresented: $isTest2Present, attributedText:GetTest2AttributedText(),customize: {
                            $0
                                .animationType(.bounce)
                                .contentInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .fitSize(.init(width: kBRCScreenWidth * 2 / 3, height: .infinity))
                                .dismissMode(.none)
                        })
                        .onTapGesture {
                            isTest2Present.toggle()
                        }
                    
                    HStack {
                        Text(String.brctest_localizableWithKey("key.test.label.03"))
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    .padding(.top)
                    
                    Text(String.brctest_localizableWithKey("key.test.button.click.me"))
                        .frame(width: 100, height: 40)
                        .background(Color.brtest_red())
                        .cornerRadius(4)
                        .clipped()
                        .foregroundColor(.brtest_white())
                        .brc_popUpView(isPresented: $isTest3Present) {
                            MenuButton(menuArray: [
                                String.brctest_localizableWithKey("key.test.menu.01"),
                                String.brctest_localizableWithKey("key.test.menu.02"),
                                String.brctest_localizableWithKey("key.test.menu.03"),
                                String.brctest_localizableWithKey("key.test.menu.04")
                            ])
                            .background(.clear)
                        } customize: {
                            $0
                            .hideAfterDelay(2.0)
                             .containerSize(.init(width: 100, height: 150))
                             .didUserDismissPopUper { popUp, view in
                                 BRCToast.show("didUserDismissPopUper");
                                 print("didUserDismissPopUper");
                             }
                             .didHidePopUper { popUp, view in
                                 BRCToast.show("didHidePopUper");
                                 print("didHidePopUper");
                             }
                             .didShowPopUper { popUp, view in
                                 BRCToast.show("didShowPopUper");
                                 print("didShowPopUper");
                             }
                             .willHidePopUper { popUp, view in
                                 print("willHidePopUper");
                             }
                             .willShowPopUper { popUp, view in
                                 print("willShowPopUper");
                             }
                        }
                        .onTapGesture {
                            isTest3Present.toggle()
                        }
                }
            }
            .padding(.leading)
            .background(Color.brtest_contentWhite())
            .frame(maxWidth: kBRCScreenWidth,maxHeight: kBRCScreenHeight)
            .navigationTitle("BRCPopUp")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Image(systemName: "chevron.left")
                        .onTapGesture {
                            isLeftNavigationItemPresent.toggle()
                        }
                        .brc_popUpTip(isPresented: $isLeftNavigationItemPresent, tipText: String.brctest_localizableWithKey("key.test.left.navigation.back"), customize: {
                            $0
                                .dismissMode(.none)
                                .contentInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                                .fitSize(.init(width: 200, height: .max))
                                .arrowCenterAlignToAnchor(true)
                                .contentAlignment(.left)
                                .offsetToAnchorView(-10)
                        })
                }
                ToolbarItem(placement: .principal){
                    
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName: "ellipsis")
                        .onTapGesture {
                            isRightNavigationItemPresent.toggle()
                        }
                        .brc_popUpImage(isPresented: $isRightNavigationItemPresent, imageUrl:"https://www.apple.com/v/home/bm/images/promos/iphone-15-pro/promo_iphone15pro__e48p7n5x3nsm_small_2x.jpg") {
                            $0
                            .webImageLoadBlock({ imageView, url in
                                imageView.sd_setImage(with: url)
                            })
                            .contentAlignment(.right)
                            .arrowCenterAlignToAnchor(true)
                            .containerSize(.init(width: 200, height: 200))
                            .offsetToAnchorView(20)
                        }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
