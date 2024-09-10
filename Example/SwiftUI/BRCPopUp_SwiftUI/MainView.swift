//
//  ContentView.swift
//  BRCPopUp_SwiftUI
//
//  Created by sunzhixiong on 2024/8/12.
//

import SwiftUI
import BRCPopUp
import BRCFastTest
import BRCFlexTagBox

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

struct BRCPageView : View {
    
    func getImageArray() -> [String] {
        return [
            "https://is1-ssl.mzstatic.com/image/thumb/Features/v4/b7/3a/0a/b73a0aa8-394c-a08d-4e25-88ee7612a41b/c9430441-b1be-43e4-bbba-f443c1422852.png/548x1186.jpg",
            "https://is1-ssl.mzstatic.com/image/thumb/Features122/v4/ef/50/3f/ef503fb5-7ad5-ce94-76ae-5d211988b343/906ae116-b969-4f9e-a9f3-e3e6a5a492b2.png/548x1186.jpg",
            "https://www.apple.com/v/home/bm/images/heroes/apple-vision-pro-enhanced/hero_apple_vision_pro_enhanced_endframe__b917czne63hy_small_2x.jpg",
            "https://www.apple.com/v/home/bm/images/heroes/mothers-day-2024/hero_md24__e3yulubypvki_small_2x.jpg",
            "https://www.apple.com/v/home/bm/images/heroes/apple-event-may/hero_1_apple_event_may__b3bo6rpkqhle_small_2x.jpg",
            "https://www.apple.com/v/home/bm/images/promos/iphone-15-pro/promo_iphone15pro__e48p7n5x3nsm_small_2x.jpg"
        ]
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment:.center) {
                ForEach(Array(getImageArray().enumerated()),id:\.offset) { index,url in
                    WebImage(url: URL(string: url)) { image in
                        image.resizable(resizingMode:.stretch)
                    } placeholder: {
                        Rectangle().foregroundColor(.gray)
                    }
                    .onSuccess { image, data, cacheType in
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(width:180, height: 180, alignment: .center)
                    .padding(.horizontal)
                }
            }
            .frame(height: 180)
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
    @State var context : UIView = UIView();
    @State var tags : [String] = [
        "key.main.tag.01",
        "key.main.tag.02",
        "key.main.tag.03",
        "key.main.tag.06",
        "key.main.tag.07",
        "key.main.tag.04",
        "key.main.tag.05",
    ].map { key in
        return String.brctest_localizableWithKey(key)
    };
    @State var contentHeight : CGFloat = 0;
    
    
    
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
        
        VStack {
            
            BRCPopUpWrapper(.nearestScrollView) {
                
                ScrollView {
                    BRCFlexTagBox(testTags: tags,contentHeight: $contentHeight)
                        .tagBackgroundColor(.brtest_contentWhite)
                        .frame(height: contentHeight)
                    
                    VStack(spacing: 5) {
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
                                    .hideAfterDelay(2.0)
                                    .containerSize(.init(width: 100, height: 120))
                                    .contentInsets(.init(top: 15, leading: 15, bottom: 15, trailing: 15))
                                    .shadowOffset(.init(width: 0, height: 3))
                                    .shadowRadius(10.0)
                                    .shadowColor(.brtest_black.withAlphaComponent(0.2))
                                    .backgroundColor(.brtest_contentWhite)
                                    .textFont(.boldSystemFont(ofSize: 16.0))
                                    .textColor(.brtest_orange)
                                    .fitSize(.init(width: kBRCScreenWidth / 2, height: .infinity))
                                    .showCancelButton(withSize: .init(width: 12, height: 12), relativePosition: .init(x: -0.05, y: -0.05 ), color: UIColor.brtest_tertiaryBlack)
                                    .didClickCloseButton { popUp, view in
                                        
                                    }
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
                                    .contentInsets(.init(top: 15, leading: 15, bottom: 15, trailing: 15))
                                    .fitSize(.init(width: kBRCScreenWidth * 2 / 3, height: .infinity))
                                    .dismissMode(.none)
                                    .popUpContext(self.context)
                                    .showCancelButton(withSize: .init(width: 12, height: 12),absoultePosition: .init(x: -5, y: 5),image : .init(systemName: "xmark.square"), color : UIColor.brtest_red)
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
                            .brc_popUpMenu(isPresented: $isTest3Present, menuActions: [
                                BRCPopUpMenuAction(title: String.brctest_localizableWithKey("key.test.menu.01"), image: nil, handler: { action in
                                    isTest3Present.toggle()
                                }),
                                BRCPopUpMenuAction(title: String.brctest_localizableWithKey("key.test.menu.02"), image: nil, handler: { action in
                                    isTest3Present.toggle()
                                }),
                                BRCPopUpMenuAction(title: String.brctest_localizableWithKey("key.test.menu.03"), image: nil, handler: { action in
                                    isTest3Present.toggle()
                                })
                            ], customize: {
                                $0
                                    .textColor(.brtest_black)
                                    .textFont(UIFont.boldSystemFont(ofSize: 12.0))
                                    .contentInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .containerSize(.init(width: 100, height: 150))
                                    .menuSeparatorColor(.brtest_deepRed)
                                    .didUserDismissPopUper { popUp, view in
                                    BRCToast.show("didUserDismissPopUper");
                                    print("didUserDismissPopUper");
                                    }
                                    .didHidePopUper { popUp, view in
//                                    BRCToast.show("didHidePopUper");
                                    print("didHidePopUper");
                                    }
                                    .didShowPopUper { popUp, view in
//                                    BRCToast.show("didShowPopUper");
                                    print("didShowPopUper");
                                    }
                                    .willHidePopUper { popUp, view in
                                    print("willHidePopUper");
                                    }
                                    .willShowPopUper { popUp, view in
                                    print("willShowPopUper");
                                    }
                            })
                            .onTapGesture {
                                isTest3Present.toggle()
                            }
                        
                        HStack {
                            Text(String.brctest_localizableWithKey("key.test.label.04"))
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
                            .brc_popUpView(isPresented: $isTest4Present, view: {
                                BRCPageView()
                            },customize: {
                                $0
                                    .containerSize(.init(width: kBRCScreenWidth / 2, height: 200))
                                    .popUpContext(context)
                            })
                            .onTapGesture {
                                isTest4Present.toggle()
                            }
                    }
                }
                } onFindContextUIView: { contextView in
                    context = contextView;
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

struct TestView : View {
    var body: some View {
        VStack {
            Text("你好")
                .background(content: {
                    Rectangle()
                        .frame(width: 100,height: 100)
                        .foregroundColor(.black)
                })
                .overlay {
                    Rectangle()
                        .frame(width: 50,height: 50)
                        .foregroundColor(.red)
                }
        }
    }
}


#Preview {
    MainView()
}
