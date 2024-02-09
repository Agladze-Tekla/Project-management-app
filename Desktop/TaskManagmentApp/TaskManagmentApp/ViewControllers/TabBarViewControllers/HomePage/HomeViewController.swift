//
//  HomeViewController.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/30/24.
//

import UIKit

final class HomeViewController: UIViewController {
    //MARK: - UI Components
    private let addProjectButton = CustomButton(title: "+ Add Project", hasBackground: false, fontSize: .small)
    
    private let addTaskButton = CustomButton(title: "+ Add Task", hasBackground: false, fontSize: .small)
    
    private let projectLabelButtonStackView: UIStackView = {
        let stack = UIStackView()
        stack.layer.cornerRadius = 13
        stack.spacing = 30
        stack.distribution = .equalCentering
        return stack
    }()
    
    private let allProjectStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 16
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40)
        return stack
    }()
    
    private let noProjectImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "folder.badge.plus")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()
    
    private let noProjectLabel: UILabel = {
        let label = UILabel()
        label.text = "You have no ongoing projects\nClick '+' to add a project"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let projectLabel = CustomLabel(title: "Projects", fontSize: .big)
    
    private let projectStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.backgroundColor = .systemBackground
        stack.spacing = 15
        stack.layer.cornerRadius = 25
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 60, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let accountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let todaysTaskLabel = CustomLabel(title: "Loading today's tasks...", fontSize: .med)
    
    private let progressStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let welcomeStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.layer.cornerRadius = 13
        stack.backgroundColor = .systemBackground
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stack
    }()
    
    private var welcomeLabel = CustomLabel(title: "Loading...", fontSize: .big)
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "pencil.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()
    
    private let projectCollectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
           collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
           return collectionView
       }()

    private var projects = [ProjectModel]()
    
    private let viewModel = HomeViewModel()
    
    private var taskCountLeft = 0
    
    private var taskCountDone = 0
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
            viewModel.fetchProjects()
        setupUI()
        setupDelegates()
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        setupBackground()
        addSubviews()
        setupConstraints()
        setupNavigationButton()
        setupWelcomeLabel()
        setupButtons()
        setupCollectionView()
        setupProjects()
    }
    
    private func setupBackground() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func addSubviews() {
        welcomeStackView.addArrangedSubview(image)
        welcomeStackView.addArrangedSubview(welcomeLabel)
        progressStackView.addArrangedSubview(todaysTaskLabel)
        accountStackView.addArrangedSubview(welcomeStackView)
        accountStackView.addArrangedSubview(progressStackView)
        projectLabelButtonStackView.addArrangedSubview(projectLabel)
        projectLabelButtonStackView.addArrangedSubview(addProjectButton)
        projectLabelButtonStackView.addArrangedSubview(addTaskButton)
        projectStackView.addArrangedSubview(projectLabelButtonStackView)
        projectStackView.addArrangedSubview(allProjectStackView)
        view.addSubview(accountStackView)
        view.addSubview(projectStackView)
    }
    
    private func setupConstraints() {
        setupAccountStackViewConstraints()
        setProjectStackViewConstraints()
    }
    
    private func setupAccountStackViewConstraints() {
        NSLayoutConstraint.activate([
            accountStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setProjectStackViewConstraints() {
        NSLayoutConstraint.activate([
            projectStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 40),
            projectStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(didTapLogout))
    }
    
    private func setupWelcomeLabel() {
        Authentication.shared.fetchUser { [weak self] user, error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showFetchingUserError(on: self, error: error)
                return
            }
            if let user = user {
                self.welcomeLabel.text = "Welcome\n\(user.username)!"
            }
        }
    }
    
    private func setupProjects() {
        viewModel.checkForProjects() { isEmpty, error in
            if let error = error {
                AlertManager.showProjectFetchingError(on: self, error: error)
                return
            }
            if isEmpty {
                self.allProjectStackView.addArrangedSubview(self.noProjectImageView)
                self.allProjectStackView.addArrangedSubview(self.noProjectLabel)
            } else {
                self.projectStackView.addArrangedSubview(self.projectCollectionView)
                NSLayoutConstraint.activate([
                    self.projectCollectionView.heightAnchor.constraint(equalToConstant: 170),
                    self.projectCollectionView.widthAnchor.constraint(equalTo: self.projectStackView.widthAnchor, constant: -20)
                ])
                self.projectCollectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView() {
          projectCollectionView.dataSource = self
         projectCollectionView.delegate = self
          projectCollectionView.register(ProjectViewCell.self, forCellWithReuseIdentifier: "ProjectCollectionCell")
       }
    
    private func setupDelegates() {
        viewModel.delegate = self
    }
    
    private func setupButtons() {
        addProjectButton.addTarget(self, action: #selector(didTapNewProject), for: .touchUpInside)
        addTaskButton.addTarget(self, action: #selector(didTapNewTask), for: .touchUpInside)
    }
    
    @objc private func didTapNewProject() {
        let vc = ProjectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapNewTask() {
        let vc = TaskDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogout() {
        viewModel.logout()
    }
}
//MARK: - CollectionView Data Source
extension  HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCollectionCell", for: indexPath) as? ProjectViewCell else {
            return UICollectionViewCell()
                    }
                    cell.configurate(project: projects[indexPath.row])
                   return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
}

//MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProjectDetailViewController(project: projects[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
      }
}

// MARK: - CollectionView FlowLayoutDelegatew
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let width = projectCollectionView.bounds.width / 3
          return CGSize(width: width, height: width)
      }
}

//MARK: - Extensions
extension HomeViewController: HomeViewModelDelegate {
    func tasksCountFetched(_ count: Int) {
        self.taskCountLeft = count
        todaysTaskLabel.text = "You have \(taskCountLeft) tasks for today"
    }
    
    
    func tasksCountFetchingFailed() {
        //TODO: ADD TASKCOUNTFAILALERT
    }
    
    func projectsFetched(_ projects: [ProjectModel]) {
        self.projects = projects
        projectCollectionView.reloadData()
    }
    
    func didLogoutSuccessfully() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }

    func didFailLogout(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            AlertManager.showLogOutError(on: self, error: error)
            return
        }
    }
}
