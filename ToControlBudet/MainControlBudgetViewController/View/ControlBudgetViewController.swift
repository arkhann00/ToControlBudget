//
//  ControlBudgetViewController.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 08.12.2023.
//

import UIKit
import SnapKit


final class ControlBudgetViewController: UIViewController {
    
    var controlBudgetViewModel: ControlBudgetViewModelProtocol = ControlBudgetViewModel()
    let costsTableView = CostsTableView()
    let budgetLabel = BudgetLabel()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        controlBudgetViewModel.fetchCosts()
    }
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        configureNavigationController()
        configureDelegateAndDataSource()
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
    
    //MARK: - Расположение элементов на экране
    private func configureUI(){
        
        view.addSubview(budgetLabel)
        
        budgetLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.right.left.equalToSuperview().inset(5)
            make.height.equalTo(60)
        }
        
        if let lastBudget = controlBudgetViewModel.fetchBudgetValue() {
            budgetLabel.text = lastBudget
        }
        

        view.addSubview(costsTableView)
        
        costsTableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
            make.top.equalTo(budgetLabel).inset(100)
        }
        
        
        
    }
        
    
}
//MARK: - Расширение реализации протоколов для таблицы (tablev view)
extension ControlBudgetViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Подпись на протоколы таблицы
    func configureDelegateAndDataSource(){
        costsTableView.delegate = self
        costsTableView.dataSource = self
    }
    //MARK: - Опрелеление количества секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return controlBudgetViewModel.numberOfSectionsInCostTableView()
    }
    //MARK: - Определение количество ячеек затрат
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controlBudgetViewModel.numberOfRowsInCostsTableView()
    }
    //MARK: - Оформление ячейки для определенной затраты
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CostTableViewCell()
        
        cell.costLabel.text = controlBudgetViewModel.fetchCostValue(indexOfCost: indexPath.row) + controlBudgetViewModel.fetchSignOfCost(indexOfCost: indexPath.row)
        cell.descriptionTextView.text = controlBudgetViewModel.fetchDescriptionOfCost(indexOfCost: indexPath.row)
        
        return cell
    }
    //MARK: - Определение размера ячейки расчитанный по алгоритму
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = controlBudgetViewModel.calculateHeightOfCostCell(indexOfCost: indexPath.row)
        return height + 50
    }
    //MARK: - Оформление и создание кнопок по свайпу вправо
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [createDeleteSwipeAction(with: indexPath)])
    }
    //MARK: - Создание ячейки удаления
    private func createDeleteSwipeAction(with indexPath: IndexPath) -> UIContextualAction{
        
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, complition in
            guard self.controlBudgetViewModel.isEnableToChangeCost(index: indexPath.row) else {
                self.errorDifferentCurrencies()
                return
            }
            self.controlBudgetViewModel.deleteCost(with: indexPath.row)
            self.budgetLabel.text = self.controlBudgetViewModel.fetchBudgetValue()
            self.costsTableView.deleteRows(at: [indexPath], with: .right)
            self.costsTableView.reloadData()
            
        }
            
        return deleteContextualAction
        
    }
    //MARK: - Назначаем действие по нажатию на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard controlBudgetViewModel.isEnableToChangeCost(index: indexPath.row) else {
            errorDifferentCurrencies()
            return
        }
        
        let selectedRowValue = controlBudgetViewModel.fetchCostValue(indexOfCost: indexPath.row)
        let selectedRowDescription = controlBudgetViewModel.fetchDescriptionOfCost(indexOfCost: indexPath.row)
        
        createChangeCostAlertController(cost: selectedRowValue, description: selectedRowDescription, indexPath: indexPath)
        
    }
    //MARK: - Создание алерта сообщающий об несовместимости валют
    private func errorDifferentCurrencies() {
        
        let errorDifferentCurrenciesAlertController = UIAlertController(title: "Impossible to change the cost", message: "It is not possible to change the cost due to different currencies", preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .cancel)
        
        errorDifferentCurrenciesAlertController.addAction(okAlertAction)
        
        present(errorDifferentCurrenciesAlertController, animated: true)
        
    }
    
    //MARK: - Создание алерта по изменению затраты
    private func createChangeCostAlertController(cost value:String, description: String, indexPath: IndexPath){
        
        let changeCostAlertController = UIAlertController(title: "Change cost", message: "Change new cost and description", preferredStyle: .alert)
        changeCostAlertController.addTextField { tf in
            tf.placeholder = "New cost"
            tf.keyboardType = .decimalPad
            tf.text = value
            
        }
        changeCostAlertController.addTextField { tf in
            tf.placeholder = "New Description"
            tf.text = description
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        let changeCostAlertAction = UIAlertAction(title: "Change", style: .default) { [self] action in
            guard controlBudgetViewModel.changeCost(newPossibleCost: changeCostAlertController.textFields![0].text, description: changeCostAlertController.textFields![1].text!, index: indexPath.row) else {
                showErrorAlertController()
                return
            }
            budgetLabel.text = controlBudgetViewModel.fetchBudgetValue()
            costsTableView.reloadData()
        }
        changeCostAlertController.addAction(cancelAlertAction)
        changeCostAlertController.addAction(changeCostAlertAction)
        
        present(changeCostAlertController, animated: true)
        
        
    }
    
}

//MARK: - Расширение для инициализации navigation controller
extension ControlBudgetViewController {
    //MARK: - Оформление navigation controller кнопками 
    func configureNavigationController(){
        
        navigationItem.rightBarButtonItem = makeAddCostButtonOnNavigationController()
        navigationController?.navigationBar.tintColor = Colors().green
        navigationItem.centerItemGroups = [UIBarButtonItemGroup(barButtonItems: [makeChangeBudgetBarButtonItem()], representativeItem: nil)]
        navigationItem.leftBarButtonItem = makeButtonToEnterSettingsViewController()
    }
    //MARK: - Создание кнопки перехода в раздел настроек
    private func makeButtonToEnterSettingsViewController() -> UIBarButtonItem {
        
        let action = UIAction { action in
            self.navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
        
        let enterSettingsViewControllerBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), primaryAction: action)
        
        return enterSettingsViewControllerBarButtonItem
    }
    //MARK: - Создание кнопки добавления затраты
    private func makeAddCostButtonOnNavigationController() -> UIBarButtonItem {
        
        let action = UIAction { action in
            
            self.createAddNewCostAlertController()
            
        }
        let addBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
        addBarButtonItem.tintColor = Colors().green
        
        return addBarButtonItem
        
    }
    //MARK: - Создание алерта для создания затраты
    private func createAddNewCostAlertController() {
        
        let addCostAlertController = UIAlertController(title: "New cost", message: "Add new cost", preferredStyle: .alert)
        addCostAlertController.addTextField { tf in
            tf.placeholder = "New cost"
            tf.keyboardType = .decimalPad
        }
        addCostAlertController.addTextField { tf in
            tf.placeholder = "Description"
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addNewCostAlertAction = UIAlertAction(title: "Add", style: .default) {[self] action in
            guard controlBudgetViewModel.addNewCost(possibleCost: addCostAlertController.textFields![0].text, description: addCostAlertController.textFields![1].text!) else {
                showErrorAlertController()
                return
            }
            budgetLabel.text = controlBudgetViewModel.fetchBudgetValue()
            costsTableView.reloadData()
        }
        
        addCostAlertController.addAction(cancelAlertAction)
        addCostAlertController.addAction(addNewCostAlertAction)
        
        present(addCostAlertController, animated: true)
        
    }
    //MARK: - Создание кнопки изменения бюджета
    private func makeChangeBudgetBarButtonItem() -> UIBarButtonItem {
        
        let action = UIAction { action in
            self.createChangeBudgetAlertController()
        }
        let changeBudgetBarButtonItem = UIBarButtonItem(title: "Change Budget", primaryAction: action)
        
        return changeBudgetBarButtonItem
        
    }
    //MARK: - Создание алерта для изменения бюджета
    private func createChangeBudgetAlertController() {
        
        let changeBudgetAlertController = UIAlertController(title: "Change budget", message: "Add new budget", preferredStyle: .alert)
        changeBudgetAlertController.addTextField { tf in
            tf.placeholder = "New budget"
            tf.keyboardType = .decimalPad
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        let chacngeAlertAction = UIAlertAction(title: "Change", style: .default) { [self] action in
            
            guard let newBudgetString = controlBudgetViewModel.tryToChangeBudget(possibleBudget: changeBudgetAlertController.textFields?.first?.text) else {
                showErrorAlertController()
                return
            }
            
            budgetLabel.text = newBudgetString
            controlBudgetViewModel.saveBudgetValue()
            
        }
        changeBudgetAlertController.addAction(cancelAlertAction)
        changeBudgetAlertController.addAction(chacngeAlertAction)
        present(changeBudgetAlertController, animated: true)
    }
    
    
    
    //MARK: - Создание алерта оповещающий об ошибке некорректного значения
    private func showErrorAlertController(){
        
        let errorAlertcontroller = UIAlertController(title: "Invalid value", message: nil, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .cancel)
        
        errorAlertcontroller.addAction(okAlertAction)
        
        present(errorAlertcontroller, animated: true)
        
    }
        
}
