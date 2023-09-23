//
//  View+Extension.swift
//  CoreML-demo
//
//  Created by Martin Regas on 15/09/2023.
//

import SwiftUI

extension View {
    func snapshot(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
       
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
