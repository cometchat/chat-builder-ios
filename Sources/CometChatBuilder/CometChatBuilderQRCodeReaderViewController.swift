import UIKit
import AVFoundation

class CometChatBuilderQRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var onBarCodeFound: ((_ data: String) -> ())?
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - Views
    
    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()
    
    private lazy var torchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan QR Code"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan the QR to preview and interact with your design instantly."
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var previewView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let instructionsContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#FFFFFF").withAlphaComponent(0.12).cgColor
        view.layer.backgroundColor = UIColor(hex: "#141414").withAlphaComponent(0.8).cgColor
        return view
    }()

    private let howToUseLabel: UILabel = {
        let label = UILabel()
        label.text = "How to Use:"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

    private let stepLabel: UILabel = {
        let label = UILabel()
        label.text = """
        1. Go to the Visual builder & generate QR code."
        
        2. Point your camera at the QR code to scan.
        
        3. Preview your design live on this device instantly.
        """
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private let noteContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#0B7BEA").withAlphaComponent(0.16)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#0B7BEA").withAlphaComponent(0.20).cgColor
        view.layer.cornerRadius = 8
        return view
    }()

    private let noteTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Note:"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()

    private let noteDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Make sure to save changes on the builder before scanning again to view updates."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let scanningLine = UIView()
    let topGlow = UIView()
    let bottomGlow = UIView()
    var isMovingDown = true
    var scanningTimer: Timer?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#141414")
        setupLayout()
        startScanningAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkCameraPermissionAndStartSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    // MARK: - Actions
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if device.torchMode == .on {
                device.torchMode = .off
            } else {
                try device.setTorchModeOn(level: 1.0)
            }

            device.unlockForConfiguration()
        } catch {
            print("Torch error: \(error.localizedDescription)")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewLayer?.frame = previewView.bounds // <- fix camera preview issue

        // Scanning UI layout
        let glowHeight: CGFloat = 24
        let glowOffset: CGFloat = 0

        scanningLine.frame = CGRect(x: 0, y: 0, width: previewView.bounds.width, height: 4)

        topGlow.frame = CGRect(x: 0, y: scanningLine.frame.minY - glowHeight + glowOffset, width: scanningLine.frame.width, height: glowHeight)
        bottomGlow.frame = CGRect(x: 0, y: scanningLine.frame.maxY - glowOffset, width: scanningLine.frame.width, height: glowHeight)

        addGlowEffect(to: topGlow, upward: true)
        addGlowEffect(to: bottomGlow, upward: false)

        if topGlow.superview == nil { previewView.addSubview(topGlow) }
        if bottomGlow.superview == nil { previewView.addSubview(bottomGlow) }

        startScanningAnimation()
    }

    
    // MARK: - Layout
    
    private func setupLayout() {
        
        captureSession = AVCaptureSession()

        // 1. Get the back camera
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }

        // 2. Create input
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            failed()
            return
        }

        // 3. Add input to session
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        // 4. Add metadata output
        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        // Add subviews
        view.addSubview(headerView)
        view.addSubview(previewView)
        view.addSubview(instructionsContainerView)
        
        scanningLine.backgroundColor = UIColor(hex: "#6852D6")
        scanningLine.translatesAutoresizingMaskIntoConstraints = false
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewView.layer.addSublayer(previewLayer)
        
        previewView.addSubview(scanningLine)
        
        instructionsContainerView.addSubview(howToUseLabel)
        instructionsContainerView.addSubview(stepLabel)
        instructionsContainerView.addSubview(noteContainerView)
        
        noteContainerView.addSubview(noteTitleLabel)
        noteContainerView.addSubview(noteDetailLabel)

        headerView.addSubview(closeButton)
        headerView.addSubview(torchButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)

        // Disable autoresizing mask
        [headerView, previewView, instructionsContainerView,
             closeButton, torchButton, titleLabel, subtitleLabel,
             howToUseLabel, stepLabel, noteContainerView,
             noteTitleLabel, noteDetailLabel].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        // Layout constraints
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            closeButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),

            torchButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            torchButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
            torchButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),

            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),

            previewView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            previewView.heightAnchor.constraint(equalToConstant: 344),

            instructionsContainerView.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 30),
            instructionsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            howToUseLabel.topAnchor.constraint(equalTo: instructionsContainerView.topAnchor, constant: 20),
            howToUseLabel.leadingAnchor.constraint(equalTo: instructionsContainerView.leadingAnchor, constant: 12),
            howToUseLabel.trailingAnchor.constraint(equalTo: instructionsContainerView.trailingAnchor, constant: 12),

            stepLabel.topAnchor.constraint(equalTo: howToUseLabel.bottomAnchor, constant: 8),
            stepLabel.leadingAnchor.constraint(equalTo: howToUseLabel.leadingAnchor, constant: 10),
            stepLabel.trailingAnchor.constraint(equalTo: howToUseLabel.trailingAnchor, constant: -10),

            noteContainerView.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 20),
            noteContainerView.leadingAnchor.constraint(equalTo: instructionsContainerView.leadingAnchor, constant: 10),
            noteContainerView.trailingAnchor.constraint(equalTo: instructionsContainerView.trailingAnchor, constant: -10),
            noteContainerView.bottomAnchor.constraint(equalTo: instructionsContainerView.bottomAnchor, constant: -24),

            noteTitleLabel.topAnchor.constraint(equalTo: noteContainerView.topAnchor, constant: 10),
            noteTitleLabel.leadingAnchor.constraint(equalTo: noteContainerView.leadingAnchor, constant: 8),

            noteDetailLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 4),
            noteDetailLabel.leadingAnchor.constraint(equalTo: noteContainerView.leadingAnchor, constant: 8),
            noteDetailLabel.trailingAnchor.constraint(equalTo: noteContainerView.trailingAnchor, constant: -8),
            noteDetailLabel.bottomAnchor.constraint(equalTo: noteContainerView.bottomAnchor, constant: -10),
            
            scanningLine.heightAnchor.constraint(equalToConstant: 4),
            scanningLine.leadingAnchor.constraint(equalTo: previewView.leadingAnchor),
            scanningLine.trailingAnchor.constraint(equalTo: previewView.trailingAnchor),
            scanningLine.topAnchor.constraint(equalTo: previewView.topAnchor, constant: previewView.bounds.height - 2)
        ])
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func failed() {
        let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()

            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                      let stringValue = readableObject.stringValue else { return }

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }
        }

    func found(code: String) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        self.dismiss(animated: false)
        self.onBarCodeFound?(code)
    }
    
    func checkCameraPermissionAndStartSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Already authorized
            if !captureSession.isRunning {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.captureSession.startRunning()
                }
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.captureSession.startRunning()
                    } else {
                        self.showPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            showPermissionAlert()
        @unknown default:
            showPermissionAlert()
        }
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Required",
            message: "Please enable camera access in Settings to scan QR codes.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    override var prefersStatusBarHidden: Bool { return true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    
    func startScanningAnimation() {
        scanningLine.layer.removeAllAnimations()
        topGlow.layer.removeAllAnimations()
        bottomGlow.layer.removeAllAnimations()

        let fromY: CGFloat = 1
        let toY: CGFloat = previewView.bounds.height - 1
        let glowOffset: CGFloat = 8
        let duration: CFTimeInterval = 2.0

        // Animate the line
        let lineAnim = CABasicAnimation(keyPath: "position.y")
        lineAnim.fromValue = fromY
        lineAnim.toValue = toY
        lineAnim.duration = duration
        lineAnim.repeatCount = .infinity
        lineAnim.autoreverses = true
        lineAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scanningLine.layer.add(lineAnim, forKey: "scan")

        // Position animations (glow follows scanning line)
        let topGlowAnim = CABasicAnimation(keyPath: "position.y")
        topGlowAnim.fromValue = fromY - glowOffset
        topGlowAnim.toValue = toY - glowOffset
        topGlowAnim.duration = duration
        topGlowAnim.repeatCount = .infinity
        topGlowAnim.autoreverses = true
        topGlowAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        topGlow.layer.add(topGlowAnim, forKey: "topGlow")

        let bottomGlowAnim = CABasicAnimation(keyPath: "position.y")
        bottomGlowAnim.fromValue = fromY + glowOffset
        bottomGlowAnim.toValue = toY + glowOffset
        bottomGlowAnim.duration = duration
        bottomGlowAnim.repeatCount = .infinity
        bottomGlowAnim.autoreverses = true
        bottomGlowAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        bottomGlow.layer.add(bottomGlowAnim, forKey: "bottomGlow")

        // Start manual glow control
        scanningTimer?.invalidate()
        scanningTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.toggleGlow()
        }

        // Initial glow state
        updateGlow()
    }
    
    func toggleGlow() {
        isMovingDown.toggle()
        updateGlow()
    }

    func updateGlow() {
        if isMovingDown {
            topGlow.alpha = 1
            bottomGlow.alpha = 0
        } else {
            topGlow.alpha = 0
            bottomGlow.alpha = 1
        }
    }

    
    func addGlowEffect(to view: UIView, upward: Bool) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(hex: "#6852D6").withAlphaComponent(0.6).cgColor, // More visible
            UIColor(hex: "#6852D6").withAlphaComponent(0.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: upward ? 1.0 : 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: upward ? 0.0 : 1.0)
        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        view.layer.addSublayer(gradient)
    }

}
