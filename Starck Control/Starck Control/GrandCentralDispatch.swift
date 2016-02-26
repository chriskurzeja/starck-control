//
//  GrandCentralDispatch.swift
//  Starck Control
//
//  Created by Chris Kurzeja on 25/02/2016.
//  Copyright © 2016 Chris Kurzeja. All rights reserved.
//

import Foundation

infix operator ~> {}

private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)

func ~> (
    backgroundClosure:  () -> (),
    mainClosure:        () -> ())
{
    dispatch_async(queue) {
        backgroundClosure()
        dispatch_async(dispatch_get_main_queue(), mainClosure)
    }
}
