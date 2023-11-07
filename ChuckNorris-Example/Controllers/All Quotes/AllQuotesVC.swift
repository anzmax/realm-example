import UIKit
import RealmSwift

class AllQuotesVC: UIViewController {
    
    var quotes: [Quote] = []
    var storageService: StorageService
    
    init(storageService: StorageService) {
        self.storageService = storageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllQuoteCell.self, forCellReuseIdentifier: AllQuoteCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadQuotes), name: NSNotification.Name("NewQuoteAdded"), object: nil)
        reloadQuotes()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func reloadQuotes() {
        quotes = storageService.load().sorted(by: {$0.createdAt < $1.createdAt})
        tableView.reloadData()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
     }
}

extension AllQuotesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllQuoteCell.id, for: indexPath) as! AllQuoteCell
        let quote = quotes[indexPath.row]
        cell.update(with: quote)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let quoteToDelete = quotes[indexPath.row]
            
            storageService.delete(quote: quoteToDelete)
            
            quotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

class AllQuoteCell: UITableViewCell {
    
    static let id = "AllQuoteCell"
    
    var quoteLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    func update(with quote: Quote) {
        quoteLabel.text = quote.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(quoteLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            quoteLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            quoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            quoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            quoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
}
