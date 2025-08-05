//
//  QRCodeLoadingViewController.swift
//  master-app
//
//  Created by Dawinder on 20/06/25.
//

import Foundation
import UIKit

class CometChatBuilderQRCodeLoadingViewController: UIViewController {

    var onStyleApplied: ((_ style: Style) -> Void)?
    var failure: (() -> Void)?
    var apiFailure: ((String) -> Void)?
    var data: String?
    
    private let centerImageView: UIImageView = {
        let imageView = UIImageView(image: CometChatBuilderAssets.image(named: "emptyChatState"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let leftIconView: UIImageView = {
        let imageView = UIImageView(image: CometChatBuilderAssets.image(named: "fontIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let rightIconView: UIImageView = {
        let imageView = UIImageView(image: CometChatBuilderAssets.image(named: "palatteIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let syncingLabel: UILabel = {
        let label = UILabel()
        label.text = "Syncing with Visual Builder..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let progressBar: GradientProgressView = {
        let progress = GradientProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.layer.cornerRadius = 4
        return progress
    }()
    
    private var progressTimer: Timer?
    private var progressValue: Float = 0.6
    
    private let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F5F5F5")
        
        setupViews()
        setupConstraints()
        startProgressAnimation()
        animateFloating(view: leftIconView, delay: 0)
        animateFloating(view: rightIconView, delay: 0.2)
    }

    private func setupViews() {
        view.addSubview(centerImageView)
        view.addSubview(leftIconView)
        view.addSubview(rightIconView)
        view.addSubview(syncingLabel)
        view.addSubview(progressBar)
    }

    private func setupConstraints() {
        [centerImageView, leftIconView, rightIconView,
         syncingLabel, progressBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            centerImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            centerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerImageView.widthAnchor.constraint(equalToConstant: 270),
            centerImageView.heightAnchor.constraint(equalToConstant: 495),
            centerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            leftIconView.topAnchor.constraint(equalTo: centerImageView.topAnchor, constant: 100),
            leftIconView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            leftIconView.widthAnchor.constraint(equalToConstant: 90),
            leftIconView.heightAnchor.constraint(equalToConstant: 90),
            
            rightIconView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            rightIconView.widthAnchor.constraint(equalToConstant: 90),
            rightIconView.heightAnchor.constraint(equalToConstant: 90),
            rightIconView.bottomAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: -100),
            
            syncingLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 24),
            syncingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            progressBar.topAnchor.constraint(equalTo: syncingLabel.bottomAnchor, constant: 24),
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])
        
    }
    
    func startProgressAnimation() {
        progressValue = 0.6
        progressBar.progress = CGFloat(progressValue)
        
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            if self.progressValue < 1.0 {
                self.progressValue += 0.005
                self.progressBar.progress = CGFloat(self.progressValue)
            } else {
                self.progressTimer?.invalidate()
            }
        }

        CometChatBuilderHelper.initiateBuilderWith(code: data ?? "", completion: { setting in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.progressTimer?.invalidate()
                self.navigationController?.popViewController(animated: true)
                self.onStyleApplied?(setting.style)
            }
        }, failure: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.progressTimer?.invalidate()
                self.navigationController?.popViewController(animated: true)
                self.failure?()
            }
        }, apiFailure: { error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.progressTimer?.invalidate()
                self.navigationController?.popViewController(animated: true)
                self.apiFailure?(error)
            }
        })
    }

    func stopProgressAnimation() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    private func animateFloating(view: UIView, delay: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.byValue = 10
        animation.duration = 1.2
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.beginTime = CACurrentMediaTime() + delay
        view.layer.add(animation, forKey: "floating")
    }
}

private class GradientProgressView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CALayer()

    var progress: CGFloat = 0 {
        didSet {
            updateMaskFrame()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(hex: "#6852D6").withAlphaComponent(0.4).cgColor,
            UIColor(hex: "#6852D6").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = bounds

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.5
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")

        layer.addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer
        layer.cornerRadius = 4
        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateMaskFrame()
    }

    private func updateMaskFrame() {
        maskLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * progress, height: bounds.height)
        maskLayer.backgroundColor = UIColor.black.cgColor
    }
}

public class CometChatBuilderAssets {
    public static func image(named name: String) -> UIImage? {
        // Locate the bundle the pod creates (e.g., CometChatBuilder.bundle)
        guard let bundleURL = Bundle(for: Self.self).url(forResource: "CometChatBuilder", withExtension: "bundle"),
              let bundle = Bundle(url: bundleURL) else {
            return nil
        }

        // Try to fetch image from bundle
        if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
            return image
        } else {
            return nil
        }
    }
}
