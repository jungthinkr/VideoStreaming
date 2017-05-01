//
//  MainMenuViewController.swift
//  VideoStreaming
//
//  Created by Aaron Liu on 4/29/17.
//  Copyright © 2017 Aaron Liu. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var containerView: UIView!
    var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        heightConstraint.isActive = false
        if isPortrait(){
            heightConstraint = containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        } else {
            heightConstraint = containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        }
        heightConstraint.isActive = true
    }
    
    
    func setup(){
        
        self.navigationItem.title = "Main Menu - Tap a Button"
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        containerView = UIView()
        view.addSubview(containerView)
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        containerView.layer.cornerRadius = 10
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        if isPortrait(){
            heightConstraint = containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        } else {
            heightConstraint = containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        }
        heightConstraint.isActive = true
        
        let nemoBtn = UIButton()
        containerView.addSubview(nemoBtn)
        nemoBtn.layer.cornerRadius = 35
        nemoBtn.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 249/255, alpha: 1)
        nemoBtn.setTitleColor(UIColor.black, for: .normal)
        nemoBtn.addTarget(self, action: #selector(nemoAction), for: .touchUpInside)
        nemoBtn.setImage(UIImage(named:"nemo"), for: .normal)
        nemoBtn.translatesAutoresizingMaskIntoConstraints = false
        nemoBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nemoBtn.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nemoBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        nemoBtn.widthAnchor.constraint(equalTo: nemoBtn.heightAnchor).isActive = true
        
        
        let incrediblesBtn = UIButton()
        containerView.addSubview(incrediblesBtn)
        incrediblesBtn.layer.cornerRadius = 35
        incrediblesBtn.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 249/255, alpha: 1)
        incrediblesBtn.setTitleColor(UIColor.black, for: .normal)
        incrediblesBtn.addTarget(self, action: #selector(incrediblesAction), for: .touchUpInside)
        incrediblesBtn.setImage(UIImage(named:"incredibles"), for: .normal)
        incrediblesBtn.translatesAutoresizingMaskIntoConstraints = false
        incrediblesBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        incrediblesBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        incrediblesBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        incrediblesBtn.widthAnchor.constraint(equalTo: incrediblesBtn.heightAnchor).isActive = true
        
        let bunnyBtn = UIButton()
        containerView.addSubview(bunnyBtn)
        bunnyBtn.layer.cornerRadius = 35
        bunnyBtn.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 249/255, alpha: 1)
        bunnyBtn.setTitleColor(UIColor.black, for: .normal)
        bunnyBtn.addTarget(self, action: #selector(bunnyAction), for: .touchUpInside)
        bunnyBtn.setImage(UIImage(named:"bunny"), for: .normal)
        bunnyBtn.translatesAutoresizingMaskIntoConstraints = false
        bunnyBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        bunnyBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bunnyBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bunnyBtn.widthAnchor.constraint(equalTo: bunnyBtn.heightAnchor).isActive = true
        
    }
    
    func nemoAction(_ sender: Any){
        let vc = MovieViewController()
        vc.videoUrl = kNemoUrl
        vc.mTitle = "Finding Nemo"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func incrediblesAction(_ sender: Any){
        let vc = MovieViewController()
        vc.videoUrl = kIncrediblesUrl
        vc.mTitle = "The Incredibles"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func bunnyAction(_ sender: Any){
        let vc = MovieViewController()
        vc.videoUrl = kBunnyUrl
        vc.mTitle = "Buck the Bunny"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    


}
