//
//  CometChatVCB.swift
//  master-app
//
//  Created by Dawinder on 22/06/25.
//

import Foundation
import UIKit

public class CometChatVCB {
    
    public static func startScanning(from viewController: UIViewController, onStyleApplied: @escaping (Style) -> Void) {
        let barCodeReaderViewController = BarCodeReaderViewController()
        
        barCodeReaderViewController.onBarCodeFound = { code in
            let vc = QRCodeLoadingViewController()
            vc.data = code
            
            vc.onStyleApplied = { style in
                barCodeReaderViewController.dismiss(animated: true) {
                    onStyleApplied(style)
                }
            }
            
            vc.failure = {
                barCodeReaderViewController.dismiss(animated: true) {
                    showAlert(on: viewController, title: "QR Code Not Recognized", message: "The scanned QR code is invalid or not supported by this app. Please try scanning a valid code.")
                }
            }
            
            vc.apiFailure = { error in
                let message = error.localizedCaseInsensitiveContains("internet") ?
                    "No internet connection detected. Please check your network and try again." :
                    "Unknown Error. Please try again later."
                barCodeReaderViewController.dismiss(animated: true) {
                    showAlert(on: viewController, title: "", message: message)
                }
            }
            
            viewController.navigationController?.pushViewController(vc, animated: false)
        }
        
        barCodeReaderViewController.modalPresentationStyle = .overFullScreen
        viewController.present(barCodeReaderViewController, animated: true)
    }
    
    /// Common alert utility
    private static func showAlert(on viewController: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }
}

