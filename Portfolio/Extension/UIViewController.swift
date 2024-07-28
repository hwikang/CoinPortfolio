//
//  UIViewController.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//

import UIKit

extension UIViewController {
    
    func showToast(message: String, duration: TimeInterval = 3.0) {
        view.subviews
            .filter({ $0 is ToastView })
            .forEach({ $0.removeFromSuperview() })
        
        let toastView = ToastView(message: message)
        toastView.alpha = 0.0
        self.view.addSubview(toastView)
        
        toastView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(80)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            toastView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastView.alpha = 0.0
            }) { _ in
                toastView.removeFromSuperview()
            }
        }
    }
}
