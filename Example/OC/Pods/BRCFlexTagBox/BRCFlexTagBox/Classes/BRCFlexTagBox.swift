//
//  BRCFlexTagBoxView.swift
//  BRCFlexBoxView
//
//  Created by sunzhixiong on 2024/9/5.
//

import SwiftUI
import UIKit

internal struct BRCFlexTagBoxParameters {
    var lineSpacing : CGFloat = 5;
    var itemSpacing : CGFloat = 5;
    var tagBorderWidth : CGFloat = 0;
    var tagShadowRadius : CGFloat = 0;
    var tagShadowOpacity : CGFloat = 1;
    var tagCornerRadius : CGFloat = 0;
    var tagTextColor : UIColor = .black;
    var tagBackgroundColor : UIColor = .clear;
    var tagBorderColor : UIColor = .clear;
    var tagShadowColor : UIColor = .clear;
    var tagMaxWidth : CGFloat = .infinity;
    var tagShadowOffset : CGSize = .zero;
    var tagTextAlignment : NSTextAlignment = .center;
    var tagContentInsets : UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2);
    var tagTextFont : UIFont = .systemFont(ofSize: 13.0, weight: .medium);
}

public struct BRCFlexTagBox : UIViewRepresentable {
    public typealias UIViewType = BRCFlexTagBoxView;
    @Binding var tags : Array<Any>;
    @Binding var params : BRCFlexTagBoxParameters;
    @Binding var contentHeight : CGFloat;
    
    public init(tags: [Any], contentHeight: Binding<CGFloat>) {
        self._tags = Binding.constant(tags)
        self._params = Binding.constant(BRCFlexTagBoxParameters());
        self._contentHeight = contentHeight;
    }
    
    public init(tags: Binding<[Any]>,contentHeight: Binding<CGFloat>) {
        self._tags = tags;
        self._params = Binding.constant(BRCFlexTagBoxParameters());
        self._contentHeight = contentHeight;
    }
    
    public func makeUIView(context: Context) -> BRCFlexTagBoxView {
        let boxView = BRCFlexTagBoxView();
        boxView.setTagList(tags);
        return boxView;
    }
    
    public func updateUIView(_ uiView: BRCFlexTagBoxView, context: Context) {
        uiView.setTagList(tags);
        var isNeedUpdate = false;
        if (uiView.lineSpacing != params.lineSpacing) {
            uiView.lineSpacing = params.lineSpacing;
            isNeedUpdate = true;
        }
        if (uiView.itemSpacing != params.itemSpacing) {
            uiView.itemSpacing = params.itemSpacing;
            isNeedUpdate = true;
        }
        let newStyle : BRCFlexTagStyle = BRCFlexTagStyle();
        newStyle.tagBorderColor = params.tagBorderColor;
        newStyle.tagBorderWidth = params.tagBorderWidth;
        newStyle.tagShadowRadius = params.tagShadowRadius;
        newStyle.tagCornerRadius = params.tagCornerRadius;
        newStyle.tagTextColor = params.tagTextColor;
        newStyle.tagBackgroundColor = params.tagBackgroundColor;
        newStyle.tagBorderColor = params.tagBorderColor;
        newStyle.tagShadowColor = params.tagShadowColor;
        newStyle.tagMaxWidth = params.tagMaxWidth;
        newStyle.tagShadowOffset = params.tagShadowOffset;
        newStyle.tagContentInsets = params.tagContentInsets;
        newStyle.tagTextFont = params.tagTextFont;
        newStyle.tagTextAlignment = params.tagTextAlignment;
        if (!uiView.defaultTagStyle.isEqual(newStyle)) {
            isNeedUpdate = true;
        }
        uiView.defaultTagStyle = newStyle;
        if (isNeedUpdate) {
            uiView.reload();
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            contentHeight = uiView.contentSize.height;
        }
    }
}

public extension BRCFlexTagBox {
    private func updateParams(_ block : ((inout BRCFlexTagBoxParameters) -> Void)) -> some View {
        var input = self;
        var params = input.params;
        block(&params);
        input._params = Binding.constant(params);
        return input;
    }
    func tagSpacing(line : CGFloat = 5,item : CGFloat = 5) -> some View {
       return updateParams { params in
           params.lineSpacing = line;
           params.itemSpacing = item;
       }
    }
    func tagBorder(width : CGFloat,color : UIColor) -> some View {
        return updateParams { params in
            params.tagBorderWidth = width;
            params.tagBorderColor = color;
        }
    }
    func tagShadow(radius : CGFloat,color : UIColor,offset : CGSize) -> some View {
        return updateParams { params in
            params.tagShadowRadius = radius;
            params.tagShadowColor = color;
            params.tagShadowOffset = offset;
        }
    }
    func tagCornerRadius(_ radius : CGFloat) -> some View {
        return updateParams { params in
            params.tagCornerRadius = radius;
        }
    }
    
    func tagMaxWidth(_ width : CGFloat) -> some View {
        return updateParams { params in
            params.tagMaxWidth = width;
        }
    }
    
    func tagTextStyle(_ color : UIColor = .black,_ font : UIFont = .systemFont(ofSize: 13.0,weight: .medium),_ alignment : NSTextAlignment = .center) -> some View {
        return updateParams { params in
            params.tagTextColor = color;
            params.tagTextFont = font;
            params.tagTextAlignment = alignment;
        }
    }
    
    func tagContentInsets(_ insets: UIEdgeInsets) -> some View {
        return updateParams { params in
            params.tagContentInsets = insets;
        }
    }
    
    func tagBackgroundColor(_ color : UIColor) -> some View {
        return updateParams { params in
            params.tagBackgroundColor = color;
        }
    }
    
}
