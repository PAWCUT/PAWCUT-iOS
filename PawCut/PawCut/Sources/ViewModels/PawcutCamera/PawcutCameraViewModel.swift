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
    @Published var totalShots: Int = 8
    @Published var countdownNumber: Int? = nil
    @Published var isCountingDown: Bool = false
    @Published var isRecording: Bool = false
    @Published var capturedImages: [UIImage] = []
    @Published var showShutter: Bool = false

    // 카메라 프리뷰
    @Published var rawImage: UIImage?

    // 줌 옵션
    struct ZoomOption: Identifiable, Hashable {
        let id: String
        let title: String
    }

    @Published var zoomOptions: [ZoomOption] = [
        ZoomOption(id: "0.5", title: ".5"),
        ZoomOption(id: "1.0", title: "1x"),
        ZoomOption(id: "2.0", title: "2"),
    ]
    @Published var selectedZoomId: String = "1.0"

    // 카메라 상태
    @Published var isFrontCamera: Bool = false
    @Published var isTimerEnabled: Bool = false
    @Published var isFlashEnabled: Bool = false
    @Published var cameraPermissionGranted: Bool = false

    // 툴팁 상태
    @Published var showSoundTooltip: Bool = true

    // AVFoundation 세션
    @Published var session: AVCaptureSession = AVCaptureSession()
    private var photoOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var currentCamera: AVCaptureDevice?
    private var currentInput: AVCaptureDeviceInput?

    // 타이머
    private var countdownTimer: Timer?
    private var loopTimer: Timer?
    private var tooltipTimer: Timer?

    // 카메라 설정
    enum CameraPosition {
        case front, back
    }
    @Published var cameraPosition: CameraPosition = .back

    override init() {
        super.init()
        setupCamera()
        setupTooltipTimer()
    }

    deinit {
        session.stopRunning()
        countdownTimer?.invalidate()
        loopTimer?.invalidate()
        tooltipTimer?.invalidate()
    }

    // MARK: - 툴팁 관리

    private func setupTooltipTimer() {
        // 3초 후에 툴팁 자동 숨김
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

    func hideSoundTooltip() {
        tooltipTimer?.invalidate()
        withAnimation(.easeInOut(duration: 0.3)) {
            showSoundTooltip = false
        }
    }

    // MARK: - Camera Setup
    func setupCamera() {
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

        // 세션 설정
        session.sessionPreset = .photo

        // 카메라 디바이스 설정
        guard let camera = getCameraDevice() else {
            session.commitConfiguration()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: camera)

            // 기존 입력 제거
            if let currentInput = currentInput {
                session.removeInput(currentInput)
            }
            // 새 입력 추가
            if session.canAddInput(input) {
                session.addInput(input)
                currentInput = input
                currentCamera = camera
            }

            // 사진 출력 설정
            if photoOutput == nil {
                photoOutput = AVCapturePhotoOutput()
                if let photoOutput = photoOutput,
                    session.canAddOutput(photoOutput)
                {
                    session.addOutput(photoOutput)
                }
            }

            // 비디오 출력 설정 (프리뷰용)
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
            print("카메라 설정 오류: \(error)")
        }

        session.commitConfiguration()

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }

    private func getCameraDevice() -> AVCaptureDevice? {
        switch cameraPosition {
        case .front:
            return AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .front
            )
        case .back:
            return AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            )
        }
    }

    // MARK: - Camera Actions
    func startLoopedCountdown() {
        startCountdown { [weak self] in
            self?.performCapture()
        }
    }

    private func startCountdown(completion: @escaping () -> Void) {
        isCountingDown = true
        countdownNumber = 6

        countdownTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] timer in
            DispatchQueue.main.async {
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
    }

    func performCapture() {
        showShutter = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.showShutter = false

            if let image = self?.rawImage {
                self?.capturedImages.append(image)
                self?.currentShotIndex = self?.capturedImages.count ?? 0

                if self?.capturedImages.count == 8 {
                    print("촬영 완료! 8장 모두 촬영됨")
                    // 여기서 다음 화면으로 이동하는 로직을 구현할 수 있습니다
                    return
                }
            }

            // 다음 루프 시작
            self?.startLoopedCountdown()
        }
    }

    func cancelCountdown() {
        countdownTimer?.invalidate()
        loopTimer?.invalidate()
        isCountingDown = false
        countdownNumber = nil
    }

    func extendCountdown() {
        if let current = countdownNumber {
            countdownNumber = current + 3
        }
    }

    private func capturePhoto() {
        guard let photoOutput = photoOutput else { return }

        let settings = AVCapturePhotoSettings()

        // 플래시 설정
        if isFlashEnabled, currentCamera?.hasFlash == true {
            settings.flashMode = .on
        } else {
            settings.flashMode = .off
        }

        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func toggleCamera() {
        cameraPosition = (cameraPosition == .front) ? .back : .front
        configureCameraSession()
    }

    func toggleFlash() {
        isFlashEnabled.toggle()
    }

    func setZoom(_ zoomId: String) {
        selectedZoomId = zoomId

        guard let camera = currentCamera else { return }

        let zoomFactor: CGFloat
        switch zoomId {
        case "0.5":
            zoomFactor = 0.5
        case "2.0":
            zoomFactor = 2.0
        default:
            zoomFactor = 1.0
        }

        do {
            try camera.lockForConfiguration()
            camera.videoZoomFactor = min(
                max(zoomFactor, camera.minAvailableVideoZoomFactor),
                camera.maxAvailableVideoZoomFactor
            )
            camera.unlockForConfiguration()
        } catch {
            print("줌 설정 오류: \(error)")
        }
    }

    func stopShooting() {
        countdownTimer?.invalidate()
        loopTimer?.invalidate()
        isCountingDown = false
        isRecording = false
        countdownNumber = nil
        currentShotIndex = 0
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension PawcutCameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard error == nil else {
            print("사진 촬영 오류: \(error!)")
            return
        }

        guard let photoData = photo.fileDataRepresentation() else {
            print("사진 데이터 변환 실패")
            return
        }

        // 포토 라이브러리에 저장
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("포토 라이브러리 권한이 필요합니다")
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(
                    with: .photo,
                    data: photoData,
                    options: nil
                )
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        print(
                            "사진 저장 완료: \(self.currentShotIndex)/\(self.totalShots)"
                        )
                    } else if let error = error {
                        print("사진 저장 실패: \(error)")
                    }
                }
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

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()

        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        else { return }

        DispatchQueue.main.async { [weak self] in
            self?.rawImage = UIImage(cgImage: cgImage)
        }
    }
}
