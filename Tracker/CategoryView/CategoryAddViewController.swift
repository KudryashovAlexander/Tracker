//
//  CategoryAddViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import UIKit

final class CategoryAddViewController: UIViewController {
    
    private let addCategoryTextField = UITextField().customTextField(placeHolder: String().categoryPlaceHolder)
    private let attentionLabel = UILabel().attenteionLabel(countSimbol: 25)
    private let addCategoryButton = UIButton().customBlackButton(title: String().buttonReady)
    private var categoryIsChange: Bool = false
    
    var viewModel: CategoryAddViewModel! {
        didSet {
            if viewModel.oldNCategoryName != nil {
                categoryIsChange = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        bind()
        checkView()
        
        addCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryTextField)
        
        NSLayoutConstraint.activate([
            addCategoryTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            addCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            addCategoryTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        attentionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(attentionLabel)
        
        NSLayoutConstraint.activate([
            attentionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            attentionLabel.topAnchor.constraint(equalTo: addCategoryTextField.bottomAnchor, constant: 8),
            attentionLabel.widthAnchor.constraint(equalTo:view.safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])
        
        
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            addCategoryButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        addCategoryTextField.delegate = self
    }
    
    private func checkView() {
        if categoryIsChange {
            self.navigationItem.title = String().categoryChangeTitle
            addCategoryButton.addTarget(self, action: #selector(changeCategoryName), for: .touchUpInside)
            guard let text = viewModel.oldNCategoryName else { return }
            addCategoryTextField.text = text
            checkSimbol(text.count)
        } else {
            self.navigationItem.title = String().categoryNewCategory
            addCategoryButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
            checkSimbol(0)
        }
    }
    
    private func bind() {
        viewModel.numberSimbol = { [weak self] countChar in
            self?.checkSimbol(countChar)
        }
    }
    
    @objc
    private func addCategory() {
        viewModel.saveCategory()
        dismiss(animated: true)
    }
    
    @objc
    private func changeCategoryName() {
        guard let text = addCategoryTextField.text else { return }
        viewModel.renameCategory(newName: text)
        dismiss(animated: true)
    }
    
    private func checkSimbol(_ count: Int) {
        switch count {
        case ..<1 :
            addCategoryButton.backgroundColor = .ypGray
            addCategoryButton.isEnabled = false
            attentionLabel.isHidden = true
        case 1...25 :
            addCategoryButton.backgroundColor = .ypBlack
            addCategoryButton.isEnabled = true
            attentionLabel.isHidden = true
        default:
            addCategoryButton.backgroundColor = .ypGray
            addCategoryButton.isEnabled = false
            attentionLabel.isHidden = false
        }
    }
    
}

//MARK: - Extension UITextFieldDelegate
extension CategoryAddViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange, with: string)
            viewModel.categoryName = updatedText
        }
        return true
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
