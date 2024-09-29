//
//  main.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.09.2024.
//

import AppKit

// 1
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// 2
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
