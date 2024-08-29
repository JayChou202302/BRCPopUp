/*
 * This file is part of the SDWebImage package.
 * (c) DreamPiggy <lizhuoli1126@126.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

import Foundation
import SwiftUI
import BRCFastTest

#if os(macOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformImage = NSImage
#else
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformImage = UIImage
#endif

#if os(macOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformView = NSView
#endif
#if os(iOS) || os(tvOS) || os(visionOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformView = UIView
#endif
#if os(watchOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformView = WKInterfaceObject
#endif

#if os(macOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformViewRepresentable = NSViewRepresentable
#endif
#if os(iOS) || os(tvOS) || os(visionOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformViewRepresentable = UIViewRepresentable
#endif
#if os(watchOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformViewRepresentable = WKInterfaceObjectRepresentable
#endif

#if os(macOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension NSViewRepresentable {
    typealias PlatformViewType = NSViewType
}
#endif
#if os(iOS) || os(tvOS) || os(visionOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension UIViewRepresentable {
    typealias PlatformViewType = UIViewType
}
#endif
#if os(watchOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension WKInterfaceObjectRepresentable {
    typealias PlatformViewType = WKInterfaceObjectType
}
#endif
