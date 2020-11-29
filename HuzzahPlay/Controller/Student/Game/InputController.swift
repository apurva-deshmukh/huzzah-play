//
//  InputController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import UIKit
import AVKit
import Speech

class InputController: UIViewController {
    
    // MARK: - Properties
    
    var student: Student
    var partner: Student
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark
        view.layer.cornerRadius = 5
        view.addSubview(label)
        label.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                     right: view.rightAnchor, paddingBottom: 10)
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Recording", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND!", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        return button
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your turn! Enter your sentence!"
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let textView: InputTextView = {
        let tv = InputTextView()
        tv.backgroundColor = .light
        tv.textColor = .dark
        tv.layer.cornerRadius = 10
        return tv
    }()
    
    let audioEngine = AVAudioEngine()
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    // MARK: - Lifecycle
    
    init(student: Student, partner: Student) {
        self.student = student
        self.partner = partner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSpeech()
        
        view.addSubview(headerView)
        view.addSubview(mainLabel)
        view.addSubview(textView)
        view.addSubview(nextButton)
        view.addSubview(recordButton)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 100)
        mainLabel.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        recordButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingLeft: 50, paddingBottom: 100, paddingRight: 50)
        nextButton.anchor(top: recordButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20,
                          paddingLeft: 50, paddingRight: 50)
        textView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: recordButton.topAnchor, right: view.rightAnchor,
                        paddingTop: 20, paddingLeft: 32, paddingBottom: 50, paddingRight: 32)
        
    }
    
    // MARK: - Selectors
    
    @objc func didTapSend() {
        guard let text = textView.text else { return }
        textView.resignFirstResponder()
        student.sentences.append(text)
        GameService.shared.uploadSentence(text, from: student, to: partner) { (error) in
            if let error = error {
                print("DEBUG: error uploading sentence - \(error.localizedDescription)")
                return
            }
            if (self.partner.sentences.count < 2) {
                let controller = LoadingController(student: self.student, partner: self.partner)
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = FinishedController(student: self.student, partner: self.partner)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
    
    @objc func didTapRecord(_ sender: UIButton) {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.recordButton.isEnabled = false
            self.recordButton.setTitle("Start Recording", for: .normal)
        } else {
            self.startRecording()
            self.recordButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    // MARK: - Helpers
    
    func setupSpeech() {
        
        self.recordButton.isEnabled = false
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.recordButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func configureUI() {
        view.backgroundColor = .primary
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        guard let customFont = UIFont(name: "GloriaHallelujah", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        label.text = "ROUND \(student.sentences.count+1)"
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        label.adjustsFontForContentSizeCategory = true
        
        nextButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        nextButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        recordButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        recordButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(22)
        mainLabel.adjustsFontForContentSizeCategory = true
    }
}

extension InputController: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.recordButton.isEnabled = true
        } else {
            self.recordButton.isEnabled = false
        }
    }
}
