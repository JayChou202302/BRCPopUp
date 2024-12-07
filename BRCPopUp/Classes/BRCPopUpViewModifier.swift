//
//  BRCPopUpViewModifier.swift
//  BRCPopUp
//
//  Created by sunzhixiong on 2024/8/19.
//

import SwiftUI
import UIKit

internal struct BRCFrameGetter: ViewModifier {
    @Binding var frame: CGRect
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    DispatchQueue.main.async {
                        let rect = proxy.frame(in: .global)
                        if rect.integral != self.frame.integral {
                            self.frame = rect
                        }
                    }
                    return AnyView(EmptyView())
                }
            )
    }
}

class BRCFindTopFrontViewController : UIViewController {
    var onViewChange: (() -> Void)? = nil
    init(onViewHasChange: ((BRCFindTopFrontViewController) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.onViewChange = { [weak self] in
            guard let self else {
                return
            }
            onViewHasChange?(self)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { parent?.preferredStatusBarStyle ?? super.preferredStatusBarStyle }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewChange?()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent);
        onViewChange?()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        onViewChange?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewChange?()
    }
}

struct BRCFindTopFrontView : UIViewControllerRepresentable {
    
    @Binding private var observed: Void;
    
    var onChangeFrontViewController : (BRCFindTopFrontViewController) -> Void
    
    typealias UIViewControllerType = BRCFindTopFrontViewController;
    
    
    init(onChangeFrontViewController: @escaping (BRCFindTopFrontViewController) -> Void) {
        self._observed = .constant(());
        self.onChangeFrontViewController = onChangeFrontViewController;
    }
    
    func makeUIViewController(context: Context) -> BRCFindTopFrontViewController {
        let vc = BRCFindTopFrontViewController { controller in
            onChangeFrontViewController(controller);
        };
        return vc;
    }
    
    func updateUIViewController(_ uiViewController: BRCFindTopFrontViewController, context: Context) {
        onChangeFrontViewController(uiViewController);
    }
    
    static func dismantleUIViewController(_ uiViewController: BRCFindTopFrontViewController, coordinator: ()) {
        uiViewController.onViewChange = nil;
    }
    
}

internal struct BRCFindTopUIViewModifier : ViewModifier {
    
    let id : UUID = UUID()
    let onFindTopView: (UIView?) -> Void
    
    @State var backController : BRCFindTopFrontViewController?
    @State var frontController : BRCFindTopFrontViewController?
    
    init(onFindTopView: @escaping (UIView?) -> Void) {
        self.onFindTopView = onFindTopView
    }
    
    func findCommonAncestor(view1: UIView?, view2: UIView?) -> UIView? {
        var superviewsOfView1 = Set<UIView>()
        
        var currentView: UIView? = view1
        while let view = currentView {
            superviewsOfView1.insert(view)
            currentView = view.superview
        }
        
        currentView = view2
        while let view = currentView {
            if superviewsOfView1.contains(view) {
                return view  // 找到共同的祖先
            }
            currentView = view.superview
        }
        
        return nil
    }
    
    func findTopUIViewInSwiftUIView() {
        guard let backView = self.backController?.view,let frontView = self.frontController?.view else{
            return
        }
        guard let backSuperSwiftUIView = backView.superview, let frontSuperSwiftUIView = frontView.superview else {
            return
        }
        guard let findCommonAncestor = findCommonAncestor(view1: backSuperSwiftUIView, view2: frontSuperSwiftUIView) else {
            return
        }
        guard let backIndex = findCommonAncestor.subviews.firstIndex(of: backSuperSwiftUIView),
              let frontIndex = findCommonAncestor.subviews.firstIndex(of: frontSuperSwiftUIView) else {
            return
        }
        var contentTopView : UIView = findCommonAncestor;
        if (frontIndex > 1 && backIndex < frontIndex) {
           contentTopView = findCommonAncestor.subviews[frontIndex - 1]
       }
        onFindTopView(contentTopView);
    }

    
    func body(content: Content) -> some View {
        content
            .background(
                BRCFindTopFrontView(onChangeFrontViewController: { backController in
                    DispatchQueue.main.async {
                        self.backController = backController;
                    }
                })
                .frame(width: 0,height: 0)
                .accessibility(hidden: true)
            )
            .overlay(
                BRCFindTopFrontView(onChangeFrontViewController: { frontController in
                    DispatchQueue.main.async {
                        self.frontController = frontController;
                        findTopUIViewInSwiftUIView();
                    }
                })
                .frame(width: 0, height: 0)
                .accessibility(hidden: true)
            )
    }
    
}

internal extension View {
    func brc_frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(BRCFrameGetter(frame: frame))
    }
    
    @MainActor
    func brc_findTopUIView(customize: @escaping (UIView?) -> Void) -> some View {
        self.modifier(BRCFindTopUIViewModifier(onFindTopView: customize))
    }
}

internal extension UIView {
    func brc_findFirstSubview<T: UIView>(ofType viewType: T.Type) -> T? {
        if self.isKind(of: viewType) {
            return self as? T
        }
        for subview in self.subviews {
            if let matchingSubview = subview.brc_findFirstSubview(ofType: viewType) {
                return matchingSubview
            }
        }
        return nil
    }
}


