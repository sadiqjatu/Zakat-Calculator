//
//  HistoryVC.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 17/05/26.
//

import UIKit
import CoreData

enum HistorySection { case main }

class HistoryVC: ZCDataLoadingVC {
    
    let tableView   = UITableView()
    var savedRecords: [RenderableHistoryItem]  = []
    let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext     //temporary area or scratch pad
    var dataSource: UITableViewDiffableDataSource<HistorySection, RenderableHistoryItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()   //Background, colors
        configureTableView()        //Anchors, registering
        configureDataSource()       //Cell provider setup
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSavedRecords()         // Fetch fresh items
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateScreenData()          // Push items to the screen
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.rowHeight       = 160
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle  = .none
        tableView.delegate        = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseId)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<HistorySection, RenderableHistoryItem>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseId, for: indexPath) as! HistoryCell
            cell.set(categoryString: item.categoryString,
                     iconType: item.iconType,
                     timestamp: item.timestamp,
                     totalAssets: item.totalAssets,
                     zakatDue: item.zakatDue,
                     currentCurrency: item.currencyCode
            )
            
            cell.onDeleteButtonTapped = {
                if let currentIndexPath = self.dataSource.indexPath(for: item) {
                    self.deleteRecord(at: currentIndexPath)
                }
            }
            
            return cell
        })
    }
    
    
    func updateScreenData() {
        var snapshot = NSDiffableDataSourceSnapshot<HistorySection, RenderableHistoryItem>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(savedRecords)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if savedRecords.isEmpty {
            showEmptyStateView(with: HistoryVCStrings.historyPlaceholder.localized, in: self.view)
        } else {
            for subview in view.subviews {
                if subview is ZCEmptyStateView {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    
    func fetchSavedRecords() {
        let request: NSFetchRequest<CalculationHistory> = CalculationHistory.fetchRequest()
        
        let sortByDate  = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sortByDate]
        
        do {
            let rawDatabaseObjects = try context.fetch(request)
            
            self.savedRecords      = rawDatabaseObjects.map({ dbObject in
                return RenderableHistoryItem(id: dbObject.objectID,
                                             categoryString: dbObject.categoryString ?? "Unknown",
                                             iconString: dbObject.iconString ?? "cash",
                                             timestamp: dbObject.timestamp ?? Date(),
                                             totalAssets: dbObject.totalAssets,
                                             zakatDue: dbObject.zakatDue,
                                             currencyCode: dbObject.currencyCode ?? ""
                )
            })
            
            print("Successfully fetched \(savedRecords.count) calculation items from the database!")
        } catch {
            print("Failed to fetch records: \(error.localizedDescription)")
        }
    }
    
    
    func deleteRecord(at indexPath: IndexPath) {
        let itemToDelete    = savedRecords[indexPath.row]
        let managedObect    = context.object(with: itemToDelete.id)
        context.delete(managedObect)
        
        do {
            try context.save()
            print("Item successfully deleted from the database!")
            
            savedRecords.remove(at: indexPath.row)
            updateScreenData()
        } catch {
            print("Failed to commit deletion to the database: \(error.localizedDescription)")
        }
    }
}


extension HistoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            self.deleteRecord(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
