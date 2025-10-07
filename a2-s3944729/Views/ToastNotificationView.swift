//
//  ToastNotificationView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 7/10/2025.
//

import UIKit
import SwiftUI

private let AUTO_CLOSE_DELAY = 2.0

/// Toast notification implementation using UiKit.
class ToastNotificationView: UIView {
    private let messageLabel = UILabel()

    init(message: String) {
        super.init(frame: .zero)
        setupUI(message: message)
        setupCloseGesture()
    }

    private func setupUI(message: String) {
        clipsToBounds = true
        backgroundColor = UIColor(red: 0, green: 0.7, blue: 0.2, alpha: 1.0)
        layer.cornerRadius = 12
        
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }

    func show(parent: UIView) {
        frame = CGRect(x: 20, y: -100, width: parent.frame.width - 40, height: 60)
        parent.addSubview(self)
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            self.frame.origin.y = 30
        }
        
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }

    private func setupCloseGesture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipe.direction = .up
        addGestureRecognizer(swipe)
    }

    @objc func close() {
        UIView.animate(withDuration: 0.1, animations: {
            self.frame.origin.y = -100
        }) { _ in
            self.removeFromSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}

/// Bridges the UiKit ToastNotificationView with SwiftUi, allowing Toast Notifications to be added in SwiftUi Views.
struct ToastHostView: UIViewControllerRepresentable {
    let message: String
    let show: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if show {
            let toast = ToastNotificationView(message: message)
            toast.show(parent: uiViewController.view)

            DispatchQueue.main.asyncAfter(deadline: .now() + AUTO_CLOSE_DELAY) {
                toast.close()
            }
        }
    }
}

/// Service that enables notification pop-up to be displayed at the top of any view.
class ToastNotificationService: ObservableObject {
    @Published var showToast: Bool = false
    @Published var message: String = ""
    
    /// Displays a notification on the current screen.
    func displayNotification(message: String) {
        self.message = message
        self.showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showToast = false
        }
    }
}
