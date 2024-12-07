//
//  BRCTestFlexTagBox.swift
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/9/10.
//

import SwiftUI
import BRCFlexTagBox

public extension BRCFlexTagBox {
    init(testTags: [String], contentHeight : Binding<CGFloat>) {
        var array : [String] = UIColor.componentTagColors() as! [String];
        var tagModels : [BRCFlexTagModel] = [];
        var index = 0;
        testTags.forEach { tag in
            let tagModel = BRCFlexTagModel();
            tagModel.text = tag;
            tagModel.style.tagTextColor = .white;
            tagModel.style.tagTextFont = .boldSystemFont(ofSize: 13.0)
            tagModel.style.tagBorderWidth = 1.0;
            tagModel.style.tagBorderColor = .brtest_fifthGray;
            tagModel.style.tagCornerRadius = 5.0;
            tagModel.style.tagContentInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
            tagModel.style.tagTextAlignment = .left;
            
            if (index < array.count) {
                let colorString : String = array[index];
                tagModel.style.tagBackgroundColor = UIColor.colorWithHexString(colorString)!;
                array.remove(at: index);
            } else {
                let colorString : String = array.last ?? "";
                tagModel.style.tagBackgroundColor = UIColor.colorWithHexString(colorString)!;
                array.removeLast();
            }
            
            tagModels.append(tagModel)
            index += 1;
        }
        self.init(tags: .constant(tagModels), contentHeight: contentHeight)
    }
}
