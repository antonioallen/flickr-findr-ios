//
//  DispatchQueueExt.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/7/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import Foundation

public enum ThreadType { case main, background }

public func run(on threadType: ThreadType, after time: DispatchTime? = .now(), priority: DispatchQoS.QoSClass = .userInitiated, work: @escaping () -> Void) {
    if threadType == .main {
        DispatchQueue.main.asyncAfter(deadline: time ?? .now(), execute: { work() })
    } else {
        DispatchQueue.global(qos: priority).async { work() }
    }
}
