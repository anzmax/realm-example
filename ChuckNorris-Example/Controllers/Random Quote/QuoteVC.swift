import UIKit
import RealmSwift

class QuoteVC: UIViewController {
    
    var currentQuote: Quote?
    var lastLoadedQuote: Quote?
    var quotes: [Quote] = []
    var service: FetchService
    var storageService: StorageService
    
    init(sevice: FetchService, storageService: StorageService) {
        self.service = sevice
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
        tableView.register(QuoteCell.self, forCellReuseIdentifier: QuoteCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        currentQuote = lastLoadedQuote
    }
    
    func setupViews() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(barButtonTapped))
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
    
    @objc func barButtonTapped() {
        loadQuote()
    }
    
    func loadQuote() {
        service.fetchQuote { result in
            switch result {
            case .success(let quote):
                self.lastLoadedQuote = quote
                
                self.storageService.append(quote)
                print(self.storageService.load())
                
                self.currentQuote = quote
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension QuoteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentQuote = currentQuote else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: QuoteCell.id, for: indexPath) as! QuoteCell
        cell.update(with: currentQuote)
        return cell
    }
}

class QuoteCell: UITableViewCell {
    
    static let id = "QuoteCell"
    
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
