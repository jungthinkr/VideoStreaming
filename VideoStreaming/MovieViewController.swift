//
//  MovieViewController.swift
//  VideoStreaming
//
//  Created by Aaron Liu on 4/29/17.
//  Copyright © 2017 Aaron Liu. All rights reserved.
//

import UIKit
import AVFoundation

class MovieViewController: UIViewController {
    
    var mView:MovieView!
    var mItem:MovieItem!
    var videoUrl:String?
    var mPlayer:MoviePlayer!
    var mLayer:AVPlayerLayer!
    var mIndicator:UIActivityIndicatorView!
    var loadedBar: UIView!
    var loadedWidthConstraint: NSLayoutConstraint!
    var containerView:UIView!
    var videoBtn: UIButton!
    var slider: UISlider!
    var bufferTimer:Timer!
    var mTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = mTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem?.title = "0%"
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        setupUI()
        setupMovie()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mLayer.removeFromSuperlayer()
        if mPlayer != nil{
            mPlayer.pause()
            mPlayer = nil
            containerView.removeFromSuperview()
        }
        bufferTimer.invalidate()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.black
        containerView = UIView()
        view.addSubview(containerView)
        setUpContainerView()
        
        mView = MovieView()
        view.addSubview(mView)
        setUpMovieView()
        
        let progressBar = UIView()
        containerView.addSubview(progressBar)
        setUpProgressbar(progressBar: progressBar)
        
        slider = BigSlider()
        view.addSubview(slider)
        setUpSlider()
        
        videoBtn = UIButton()
        containerView.addSubview(videoBtn)
        setUpVideoBtn()
        
        let resetBtn = UIButton()
        containerView.addSubview(resetBtn)
        setUpResetBtn(button:resetBtn)
        
        let saveBtn = UIButton()
        containerView.addSubview(saveBtn)
        setUpSaveBtn(button: saveBtn)
        
        mIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.addSubview(mIndicator)
        setUpActivityIndicator()

        self.view.layoutIfNeeded()
        
    }
    func setUpContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.backgroundColor = UIColor(red: 61/255,
                                                green: 91/255,
                                                blue: 151/255,
                                                alpha: 1)
    }
    
    func setUpMovieView() {
        mView.translatesAutoresizingMaskIntoConstraints = false
        let rightConstraint = NSLayoutConstraint(item: mView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: mView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem:containerView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: mView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant:0 )
        let bottomConstraint = NSLayoutConstraint(item: mView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.top, multiplier:1, constant: 0)
        view.addConstraints([rightConstraint, leftConstraint, topConstraint, bottomConstraint])
    }
    
    func setUpProgressbar(progressBar: UIView) {
        progressBar.backgroundColor = UIColor.darkGray
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        progressBar.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        progressBar.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        loadedBar = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 2))
        progressBar.addSubview(loadedBar)
        loadedBar.backgroundColor = UIColor.lightGray
        loadedBar.translatesAutoresizingMaskIntoConstraints = false
        loadedBar.leftAnchor.constraint(equalTo: progressBar.leftAnchor).isActive = true
        loadedBar.topAnchor.constraint(equalTo: progressBar.topAnchor, constant: 0).isActive = true
        loadedBar.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 0).isActive = true
        loadedWidthConstraint = loadedBar.widthAnchor.constraint(equalToConstant: 0)
        loadedWidthConstraint.isActive = true
        
    }
    
    func setUpSlider(){
        slider.addTarget(self, action: #selector(slideToTime), for: .valueChanged)
        slider.minimumTrackTintColor = UIColor(red: 190/255, green: 50/255, blue: 50/255, alpha: 1)
        slider.maximumTrackTintColor = UIColor.clear
        slider.backgroundColor = UIColor.clear
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -1).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    func setUpVideoBtn(){
        videoBtn.setImage(UIImage(named:"stop"), for: .normal)
        videoBtn.translatesAutoresizingMaskIntoConstraints = false
        videoBtn.addTarget(self, action: #selector(controlVideo), for: .touchUpInside)
        videoBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        videoBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        videoBtn.heightAnchor.constraint(equalTo:containerView.heightAnchor, multiplier: 0.6).isActive = true
        videoBtn.widthAnchor.constraint(equalTo: videoBtn.heightAnchor).isActive = true
    }
    
    func setUpResetBtn(button:UIButton){
        button.setImage(UIImage(named: "reset"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetVideo), for: .touchUpInside)
        button.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 50).isActive = true
        button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalTo:containerView.heightAnchor, multiplier: 0.6).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
    }
    
    func setUpSaveBtn(button:UIButton){
        button.setImage(UIImage(named: "save"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveVideo), for: .touchUpInside)
        button.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -50).isActive = true
        button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalTo:containerView.heightAnchor, multiplier: 0.6).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
    }
    
    func setUpActivityIndicator(){
        mIndicator.isHidden = true
        mIndicator.translatesAutoresizingMaskIntoConstraints = false
        mIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupMovie(){
        if let url = URL(string:videoUrl!) {
            mItem = MovieItem(url: url)
        }
        mPlayer = MoviePlayer(playerItem: mItem)
        mPlayer.configure()
        mLayer = AVPlayerLayer(player: mPlayer)
        mLayer.videoGravity = isPortrait() ? AVLayerVideoGravityResizeAspect : AVLayerVideoGravityResizeAspectFill
        mLayer.frame = mView.bounds
        mView.layer.addSublayer(mLayer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(controlVideo))
        mView.addGestureRecognizer(tapGesture)
        view.sendSubview(toBack: mView)
        mPlayer.play()
        bufferTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(monitorBuffering), userInfo: nil, repeats: true)
    }
    
    func monitorBuffering() {
        let loaded = mItem.loadedTimeRanges.first
        let total = mItem.seekableTimeRanges.first
        let current = mItem.currentTime()
        guard let loadedRangeValue = loaded?.timeRangeValue else {
            return
        }
        guard let totalRangeValue = total?.timeRangeValue else {
            return
        }
        
        let loadedSeconds = CMTimeGetSeconds(CMTimeRangeGetEnd(loadedRangeValue))
        let totalSeconds = CMTimeGetSeconds(CMTimeRangeGetEnd(totalRangeValue))
        let currentSeconds = CMTimeGetSeconds(current)
        let ratioLT = (loadedSeconds/totalSeconds)
        let ratioCT = (currentSeconds/totalSeconds)
        self.navigationItem.rightBarButtonItem?.title =  "\(Int( ratioLT*100))" + "%"
        loadedWidthConstraint.isActive = false
        loadedWidthConstraint = loadedBar.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: CGFloat(ratioLT))
        loadedWidthConstraint.isActive = true
        slider.setValue(Float(ratioCT), animated: false)
        if !mItem.isPlaybackLikelyToKeepUp{
            showIndicator()
        } else {
            hideIndicator()
        }
        
    }
    
    func controlVideo() {
        
        if (mPlayer.isPlaying){
            videoBtn.setImage(UIImage(named:"play"), for: .normal)
            mPlayer.pause()
        } else {
            videoBtn.setImage(UIImage(named:"stop"), for: .normal)
            mPlayer.play()
        }
        
    }
    
    func resetVideo() {
        mPlayer.seek(to: kCMTimeZero)
        if !mPlayer.isPlaying {
            controlVideo()
        }
    }
    
    func saveVideo() {
        let asset = AVURLAsset(url: URL(string:self.videoUrl!)!)
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset640x480)
        let filename = "movieclip.mp4"
        
        let fm = FileManager.default
        let documentsDirectory = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let outputURL = documentsDirectory.appendingPathComponent(filename)

        exporter?.outputURL = outputURL
        exporter?.outputFileType = AVFileTypeMPEG4
        
        exporter?.exportAsynchronously(completionHandler: {
            print ("saved successfully...")
        })
        
        
    }
    
    func deviceOrientationDidChange() {
        mLayer.videoGravity = isPortrait() ? AVLayerVideoGravityResizeAspect : AVLayerVideoGravityResizeAspectFill
        navigationController?.navigationBar.isHidden = isPortrait() ? false : true
        mLayer.frame = mView.bounds
    }
    
    func slideToTime (slider : UISlider) {
        let total = mItem.seekableTimeRanges.first
        guard let totalRangeValue = total?.timeRangeValue else {
            return
        }
        let totalTime = CMTimeGetSeconds(CMTimeRangeGetEnd(totalRangeValue))
        let desiredTimeSeconds = Float(totalTime) * slider.value
        CMTimeMake(Int64(desiredTimeSeconds), 1)
        let desiredTime = CMTimeMake(Int64(desiredTimeSeconds), 1)
        mPlayer.seek(to: desiredTime)
        
        if (!mPlayer.isPlaying){
           controlVideo()
        }

    }
    
    func showIndicator() {
        mIndicator.startAnimating()
        mIndicator.isHidden = false
    }
    
    func hideIndicator() {
        mIndicator.stopAnimating()
        mIndicator.isHidden = true
    }
    
}



