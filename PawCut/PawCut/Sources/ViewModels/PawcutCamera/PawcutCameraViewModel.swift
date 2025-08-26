//
//  PawcutCameraViewModel.swift
//  PawCut
//
//  Created by 광로 on 8/12/25.
//

import AVFoundation
import Foundation
import Photos
import SwiftUI

final class PawcutCameraViewModel: NSObject, ObservableObject {
    // 촬영 상태
    @Published var currentShotIndex: Int = 0
    @Published var countdownNumber: Int? = nil
    @Published var isCountingDown: Bool = false
    @Published var capturedImages: [UIImage] = []
    @Published var showShutter: Bool = false
    @Published var rawImage: UIImage?
    // 카메라 상태
    @Published var selectedZoomId: String = "1.0"
    @Published var isFlashEnabled: Bool = false
    @Published var cameraPermissionGranted: Bool = false
    @Published var cameraPosition: CameraPosition = .back
    @Published var session: AVCaptureSession = AVCaptureSession()
    // 전면 카메라 줌 상태
    @Published var isZoomedIn: Bool = false
    @Published var currentZoomLevel: CGFloat = 1.0
    // UI 상태
    @Published var showSoundTooltip: Bool = true
    @Published var soundButtonScale: CGFloat = 1.0
    // 사운드 재생
    private let navigationManager = NavigationManager.shared
    private let audioManager = AudioManager()
    
    let totalShots: Int = 8
    
    let zoomOptions: [ZoomOption] = [
        ZoomOption(id: "0.5", title: ".5"),
        ZoomOption(id: "1.0", title: "1x"),
        ZoomOption(id: "2.0", title: "2"),
    ]
    
    enum CameraPosition {
        case front, back
    }
    
    struct ZoomOption: Identifiable, Hashable {
        let id: String
        let title: String
    }
    
    // MARK: - Private Properties
    private var photoOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var currentCamera: AVCaptureDevice?
    private var currentInput: AVCaptureDeviceInput?
    private var countdownTimer: Timer?
    private var loopTimer: Timer?
    private var tooltipTimer: Timer?
    
    override init() {
        super.init()
        setupCamera()
        setupTooltipTimer()
        startSoundButtonAnimation()
    }
    
    deinit {
        session.stopRunning()
        countdownTimer?.invalidate()
        loopTimer?.invalidate()
        tooltipTimer?.invalidate()
    }
    
    func tapBackButton() {
        DispatchQueue.main.async {
            self.navigationManager.popUntil(to: 2)
        }
    }
    
    func startLoopedCountdown() {
        startCountdown { [weak self] in
            self?.performCapture()
        }
    }
    
    func performCapture() {
        showShutter = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.showShutter = false
            
            if let image = self?.rawImage {
                self?.capturedImages.append(image)
                self?.currentShotIndex = self?.capturedImages.count ?? 0
                
                if self?.capturedImages.count == 8 {
                    self?.audioManager.stopAudio()
                    
                    DispatchQueue.main.async {
                        self?.navigationManager
                            .navigate(to: .main(.pawcutSelection(images: self?.capturedImages ?? [])))
                    }
                    return
                }
            }
            
            self?.startLoopedCountdown()
        }
    }
    
    func cancelCountdown() {
        countdownTimer?.invalidate()
        loopTimer?.invalidate()
        isCountingDown = false
        countdownNumber = nil
    }
    
    func pauseCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isCountingDown = false
    }
    
    func extendCountdown() {
        if let current = countdownNumber {
            countdownNumber = current + 3
        }
    }
    
    func toggleCamera() {
        cameraPosition = (cameraPosition == .front) ? .back : .front
        
        if cameraPosition == .front {
            isZoomedIn = false
            currentZoomLevel = 1.0
        } else {
            selectedZoomId = "1.0"
        }
        
        configureCameraSession()
    }
    
    func toggleFlash() {
        isFlashEnabled.toggle()
        updateFlashMode()
    }
    
    private func updateFlashMode() {
        guard let camera = currentCamera, camera.hasTorch else { return }
        
        do {
            try camera.lockForConfiguration()
            
            if isFlashEnabled {
                if camera.isTorchModeSupported(.on) {
                    camera.torchMode = .on
                }
            } else {
                if camera.isTorchModeSupported(.off) {
                    camera.torchMode = .off
                }
            }
            
            camera.unlockForConfiguration()
        } catch {
            // 토치 설정 실패
        }
    }
    
    func setZoom(_ zoomId: String) {
        selectedZoomId = zoomId
        if zoomId == "0.5" {
            switchToUltraWideCamera()
        } else {
            switchToWideCamera(zoomLevel: zoomId)
        }
    }
    
    private func switchToUltraWideCamera() {
        guard let newCamera = getCameraDevice(for: "0.5") else { return }
        
        session.beginConfiguration()
        
        if let currentInput = currentInput {
            session.removeInput(currentInput)
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: newCamera)
            if session.canAddInput(input) {
                session.addInput(input)
                currentInput = input
                currentCamera = newCamera
            }
        } catch {
            // 카메라 전환 실패
        }
        
        session.commitConfiguration()
    }
    
    private func switchToWideCamera(zoomLevel: String) {
        guard let newCamera = getCameraDevice(for: zoomLevel) else { return }
        
        session.beginConfiguration()
        
        if let currentInput = currentInput {
            session.removeInput(currentInput)
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: newCamera)
            if session.canAddInput(input) {
                session.addInput(input)
                currentInput = input
                currentCamera = newCamera
                
                // 줌 설정
                let zoomFactor: CGFloat
                switch zoomLevel {
                case "2.0": zoomFactor = 2.0
                default: zoomFactor = 1.0
                }
                
                try newCamera.lockForConfiguration()
                newCamera.videoZoomFactor = min(
                    max(zoomFactor, newCamera.minAvailableVideoZoomFactor),
                    newCamera.maxAvailableVideoZoomFactor
                )
                newCamera.unlockForConfiguration()
            }
        } catch {
            // 카메라 전환 실패
        }
        
        session.commitConfiguration()
    }
    
    func toggleFrontZoom() {
        guard cameraPosition == .front, let camera = currentCamera else {
            return
        }
        
        isZoomedIn.toggle()
        let targetZoom: CGFloat = isZoomedIn ? 1.5 : 1.0
        currentZoomLevel = targetZoom
        
        do {
            try camera.lockForConfiguration()
            camera.videoZoomFactor = min(
                max(targetZoom, camera.minAvailableVideoZoomFactor),
                camera.maxAvailableVideoZoomFactor
            )
            camera.unlockForConfiguration()
        } catch {
            // 전면 줌 설정 실패
        }
    }
    
    func hideSoundTooltip() {
        tooltipTimer?.invalidate()
        withAnimation(.easeInOut(duration: 0.3)) {
            showSoundTooltip = false
        }
    }
    
    func playSound() {
        let petStorage = PetStorage()
        let currentPetType = petStorage.getPetType()
        
        if let savedFileName = petStorage.getSelectedAudioFileName(for: currentPetType),
           let savedAudioFile = AudioFile(rawValue: savedFileName) {
            audioManager.playAudio(audioFile: savedAudioFile)
            return
        }
        
        // 로컬에 오디오 파일이 없을 경우 실행됩니다.
        let defaultAudio = AudioFile.plasticBag
        audioManager.playAudio(audioFile: defaultAudio)
    }
    
    private func startSoundButtonAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.soundButtonScale = 1.2
        }
    }
    
    private func setupTooltipTimer() {
        tooltipTimer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: false
        ) { [weak self] _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self?.showSoundTooltip = false
                }
            }
        }
    }
    
    private func setupCamera() {
        checkCameraPermission { [weak self] granted in
            DispatchQueue.main.async {
                self?.cameraPermissionGranted = granted
                if granted {
                    self?.configureCameraSession()
                }
            }
        }
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func configureCameraSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let camera = getCameraDevice() else {
            session.commitConfiguration()
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            if let currentInput = currentInput {
                session.removeInput(currentInput)
            }
            
            if session.canAddInput(input) {
                session.addInput(input)
                currentInput = input
                currentCamera = camera
            }
            
            if photoOutput == nil {
                photoOutput = AVCapturePhotoOutput()
                if let photoOutput = photoOutput,
                   session.canAddOutput(photoOutput)
                {
                    session.addOutput(photoOutput)
                }
            }
            
            if videoOutput == nil {
                videoOutput = AVCaptureVideoDataOutput()
                videoOutput?.setSampleBufferDelegate(
                    self,
                    queue: DispatchQueue(label: "camera.preview")
                )
                if let videoOutput = videoOutput,
                   session.canAddOutput(videoOutput)
                {
                    session.addOutput(videoOutput)
                }
            }
            
        } catch {
            // 카메라 설정 실패
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    private func getCameraDevice(for zoomLevel: String = "1.0")
    -> AVCaptureDevice?
    {
        switch cameraPosition {
        case .front:
            return AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .front
            )
        case .back:
            if zoomLevel == "0.5" {
                return AVCaptureDevice.default(
                    .builtInUltraWideCamera,
                    for: .video,
                    position: .back
                )
                ?? AVCaptureDevice.default(
                    .builtInWideAngleCamera,
                    for: .video,
                    position: .back
                )
            } else {
                return AVCaptureDevice.default(
                    .builtInWideAngleCamera,
                    for: .video,
                    position: .back
                )
            }
        }
    }
    
    private func startCountdown(completion: @escaping () -> Void) {
        isCountingDown = true
        countdownNumber = 6
        
        countdownTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else { return }
            
            if let current = self.countdownNumber {
                if current <= 1 {
                    timer.invalidate()
                    self.isCountingDown = false
                    self.countdownNumber = nil
                    completion()
                } else {
                    self.countdownNumber = current - 1
                }
            }
        }
    }
    
    private func capturePhoto() {
        guard let photoOutput = photoOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        
        if isFlashEnabled, currentCamera?.hasFlash == true {
            settings.flashMode = .on
        } else {
            settings.flashMode = .off
        }
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension PawcutCameraViewModel: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard error == nil else { return }
        guard let photoData = photo.fileDataRepresentation() else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(
                    with: .photo,
                    data: photoData,
                    options: nil
                )
            }) { success, error in
                // 저장 완료 처리
            }
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension PawcutCameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else { return }
        
        // 카메라 방향 설정
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.rawImage = UIImage(cgImage: cgImage)
        }
    }
}
