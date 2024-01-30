//
//  SettingsViewController.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 21.12.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    let currencySegmentedControl = CurrencySegmentedControl(items: ["₽","$","€","£"])
    let currencyTitleLabel = CurrencyTitleLabel()
    let settingsViewModel:SettingsViewModelProtocol = SettingsViewModel()
    let updateMonthlyBudgetSwitch = UpdateMonthlyBudgetSwitch()
    let monthlyBudgetTextField = MonthlyBudgetTextField()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureNavigationController()
    }
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViewLayout()
    }
    //MARK: - Оформление градиента для view
    private func configureViewLayout(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        let startColor = Colors().dark4.cgColor
        let endColor = Colors().dark1.cgColor
        gradientLayer.colors = [startColor, endColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    //MARK: - Расположение элементов и оформление экрана
    private func configure() {
        
        view.backgroundColor = Colors().dark2
        
        let currentCurrencyLabel = UILabel()
        currentCurrencyLabel.text = "Current currency"
        currentCurrencyLabel.textColor = Colors().green
        currentCurrencyLabel.font = currentCurrencyLabel.font.withSize(15)
        view.addSubview(currentCurrencyLabel)
        currentCurrencyLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(120)
        }
        
        view.addSubview(currencyTitleLabel)
        
        currencyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(currentCurrencyLabel).inset(10)
            make.right.left.equalToSuperview().inset(30)
        }
        
        view.addSubview(currencySegmentedControl)
        
        currencySegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(currencyTitleLabel).inset(25)
            make.right.left.equalToSuperview().inset(30)
        }
        let lastSelect = settingsViewModel.fetchCurrencyIndex()
        currencySegmentedControl.selectedSegmentIndex = lastSelect
        currencySegmentedControl.isSelected = true
        
        let updateMothlyBudgetLabel = UILabel()
        updateMothlyBudgetLabel.text = "Update monthly budget"
        updateMothlyBudgetLabel.textColor = Colors().green
        updateMothlyBudgetLabel.font = updateMothlyBudgetLabel.font.withSize(15)
        view.addSubview(updateMothlyBudgetLabel)
        updateMothlyBudgetLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(30)
            make.top.equalTo(currencySegmentedControl).inset(50)
        }
        
        
        view.addSubview(updateMonthlyBudgetSwitch)
        updateMonthlyBudgetSwitch.onTintColor = Colors().green
        updateMonthlyBudgetSwitch.snp.makeConstraints { make in
                    make.top.equalTo(updateMothlyBudgetLabel).inset(25)
                    make.right.equalToSuperview().inset(30)
                }
        updateMonthlyBudgetSwitch.isOn = settingsViewModel.fetchIsUpdateMonthlyBudget()
        updateMonthlyBudgetSwitch.addTarget(self, action: #selector(changeStateMonthlyBudgetTextField), for: .valueChanged)
        
        view.addSubview(monthlyBudgetTextField)
        monthlyBudgetTextField.snp.makeConstraints { make in
            make.top.equalTo(updateMothlyBudgetLabel).inset(25)
            make.left.equalToSuperview().inset(30)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        monthlyBudgetTextField.isEnabled = updateMonthlyBudgetSwitch.isOn
        monthlyBudgetTextField.text = settingsViewModel.fetchMonthlyBudgetForTextField()
        
        
    }
    
    @objc func changeStateMonthlyBudgetTextField() {
        monthlyBudgetTextField.isEnabled = updateMonthlyBudgetSwitch.isOn
    }

    
}
//MARK: - Расширение для инициализации navigation controller
extension SettingsViewController {
    //MARK: - Оформление navigation controller кнопками
    func configureNavigationController() {
        navigationItem.rightBarButtonItem = createSaveBarButtonItem()
    }
    //MARK: - Создание кнопки сохранения настроек
    private func createSaveBarButtonItem() -> UIBarButtonItem {
        
        let saveBarButtonItem = UIBarButtonItem(systemItem: .save,primaryAction: UIAction(handler: { [self] action in

            let currencyIndex = currencySegmentedControl.selectedSegmentIndex
            let currencyString = currencySegmentedControl.titleForSegment(at: currencyIndex)
            
            settingsViewModel.saveNewCurrency(currencyIndex: currencyIndex, currencyString: currencyString!)
            
            guard settingsViewModel.saveMonthlyBudget(maybeNewMonthlyBudget: monthlyBudgetTextField.text ?? "", isUpdateMonthlyBudget: updateMonthlyBudgetSwitch.isOn) else {
                showErrorAlertController()
                return
            }
            
        }))
        
        saveBarButtonItem.tintColor = Colors().green
        
        return saveBarButtonItem
        
    }
    
    private func showErrorAlertController(){
        
        let errorAlertcontroller = UIAlertController(title: "Invalid value", message: nil, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .cancel)
        
        errorAlertcontroller.addAction(okAlertAction)
        
        present(errorAlertcontroller, animated: true)
        
    }
    
}
