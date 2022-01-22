import Foundation
import Cocoa
import SwiftUI

class EditProcessWindowController: NSWindowController {
    convenience init(process: ManagedProcess, context: NSManagedObjectContext) {
        let rootViewModel = EditProcessViewModel(
            process: process,
            context: context
        )
        let rootView = EditProcessView(viewModel: rootViewModel)
        
        let hostingController = NSHostingController(rootView: rootView)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Edit Process"
        window.setContentSize(NSSize(width: 320, height: 400))

        self.init(window: window)
        
        window.delegate = self

        rootViewModel.onClose = { [weak self] in
            self?.close()
        }
    }
}

extension EditProcessWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        self.window = nil
    }
}
