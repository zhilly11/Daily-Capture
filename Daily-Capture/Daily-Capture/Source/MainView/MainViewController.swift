//  Daily-Capture - MainViewController.swift
//  Created by zhilly, vetto on 2023/06/29

import UIKit

class MainViewController: UIViewController {
    let button: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(moveDiaryDetailView), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [button].forEach(view.addSubview(_:))
        configureButton()
    }
    
    @objc
    private func moveDiaryDetailView() {
        let viewModel = DiaryDetailViewModel(diary: Diary(pictures: [], title: "hi", createdAt: Date()))
        let diaryDetailView = UINavigationController(rootViewController: DiaryDetailViewController(diaryDetailViewModel: viewModel))
        diaryDetailView.modalPresentationStyle = .fullScreen
        
        self.present(diaryDetailView, animated: true)
    }
    
    private func configureButton() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}
