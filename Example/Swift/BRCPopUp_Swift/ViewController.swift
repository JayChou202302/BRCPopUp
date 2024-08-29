//
//  ViewController.swift
//  BRCPopUp_Swift
//
//  Created by sunzhixiong on 2024/8/4.
//

import UIKit
import SnapKit
import BRCPopUp

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}


class ViewController : UIViewController {
    
    var lastView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = .systemBackground;
        setNavigationBar();
        addTest1Button();
        addTest2Button();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.navigationItem.titleView?.brc_popUpTip("你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!", direction: .bottom,hideAfter: 2.0);
        };
    }
    
    func setNavigationBar() {
        let label = UILabel.init();
        label.text = "PopUp";
        label.textColor = .black;
        label.font = .boldSystemFont(ofSize: 16.0);
        self.navigationItem.titleView = label;
    }
    
    func addTest1Button() {
        let button = createTestButton("测试1") { button in
            button.brc_popUpTip("你好呀", direction: .bottom);
        };
        addTestView(button, "示例1", kBRCScreenWidth - 40, 10);
    }
    
    func addTest2Button() {
        let containerView = UIView.init();
        let button = UIButton.init();
        button.setTitle("UserName", for: .normal);
        button.setTitleColor(.black, for: .normal);
        button.tintColor = .black;
        button.setImage(UIImage.init(systemName: "person"), for: .normal);
        button.isUserInteractionEnabled = false;
        containerView.addSubview(button);
        let label = UILabel.init();
        label.text = "JayChou";
        label.textColor = .black;
        containerView.addSubview(label);
        let warnButton = UIButton.init();
        containerView.addSubview(warnButton);
        warnButton.setImage(UIImage(systemName: "lock.trianglebadge.exclamationmark.fill"), for: .normal);
        warnButton.tintColor = .systemYellow;
        
        let popUper = BRCPopUper.init(contentStyle: .text);
        popUper.shadowColor = .black.withAlphaComponent(0.2);
        popUper.shadowOffset = .init(width: 5, height: 5);
        popUper.shadowRadius = 10.0;
        popUper.popUpDirection = .bottom;
        
        let animationGroup = CAAnimationGroup();
        let alphaAnimation = CABasicAnimation(keyPath: "opacity");
        alphaAnimation.fromValue = 0;
        alphaAnimation.toValue = 1;
        let springAnimation = CASpringAnimation(keyPath: "transform.scale");
        springAnimation.fromValue = 0.8;
        springAnimation.toValue = 1.0;
        springAnimation.initialVelocity = 0.8;
        springAnimation.damping = 1.2;
        animationGroup.animations = [alphaAnimation,springAnimation];
        animationGroup.duration = 0.6;        
        animationGroup.fillMode = .forwards;
        animationGroup.isRemovedOnCompletion = false;
        popUper.popUpAnimation = animationGroup;
        
        let highlightStr = "Swift code is safe by design and produces software that runs lightning-fast.";
        let attributedString : NSMutableAttributedString = NSAttributedString.init(string: "Swift is a powerful and intuitive programming language for all Apple platforms. It’s easy to get started using Swift, with a concise-yet-expressive syntax and modern features you’ll love. Swift code is safe by design and produces software that runs lightning-fast.",attributes: [.foregroundColor : UIColor.black]).mutableCopy() as! NSMutableAttributedString;
        let ranges = attributedString.string.range(of: highlightStr)!;
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: attributedString.string.nsRange(from: ranges));
        popUper.offsetToAnchorView = 10.0;
        popUper.marginToAnchorView = -10.0;
        popUper.setContentText(attributedString);
        popUper.anchorView = warnButton;
        popUper.contentAlignment = .right;
        popUper.contentInsets = .init(top: 10, left: 10, bottom: 10, right: 10);
        popUper.sizeThatFits(.init(width: kBRCScreenWidth - 40, height: CGFloat(HUGE)));
        
        warnButton.addAction(UIAction.init(handler: { action in
            popUper.toggleDisplay();
        }), for: .touchUpInside);
        button.snp.makeConstraints { make in
            make.leading.equalTo(containerView);
            make.top.bottom.equalTo(containerView);
        };
        label.snp.makeConstraints { make in
            make.trailing.equalTo(warnButton.snp.leading).offset(-5);
            make.top.bottom.equalTo(containerView);
        };
        warnButton.snp.makeConstraints { make in
            make.trailing.equalTo(containerView);
            make.top.bottom.equalTo(containerView);
        };
        addTestView(containerView, "示例2", kBRCScreenWidth - 40, 30);
    }
    
    func createTestButton(_ title:String,_ clickBlock:@escaping (UIButton) -> Void) -> UIButton {
        let button = UIButton.init();
        button.addAction(UIAction.init(handler: { action in
            clickBlock(button);
        }), for: .touchUpInside);
        button.setTitle(title, for: .normal);
        button.setTitleColor(.white, for: .normal);
        button.backgroundColor = .red;
        button.layer.cornerRadius = 4.0;
        button.clipsToBounds = true;
        return button;
    }
    
    func addTestView(_ view : UIView,_ title: String,_ width : CGFloat,_ space : CGFloat) {
        let label = UILabel.init();
        label.text = title;
        label.textColor = .black;
        addSubView(label, .init(width: 0, height: 0), space);
        addSubView(view, .init(width: width, height: 50), 10);
    }
    
    func addSubView(_ view : UIView,_ size : CGSize ,_ space : CGFloat) {
        self.view.addSubview(view);
        view.snp.makeConstraints { make in
            if (lastView == nil) {
                make.top.equalTo(self.view).offset(100);
            } else {
                make.top.equalTo(lastView!.snp.bottom).offset(space);
            }
            make.leading.equalTo(self.view).offset(20);
            if (size.width > 0) {
                make.width.equalTo(size.width);
            }
            if (size.height > 0) {
                make.height.equalTo(size.height);
            }
        };
        self.lastView = view;
    }

}

