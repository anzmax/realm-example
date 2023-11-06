import UIKit

enum TabBarPage {
    case quote
    case allQuotes
    case categories
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .quote
        case 1:
            self = .allQuotes
        case 2:
            self = .categories
        default:
            return nil
        }
    }
    
    func makeTitle() -> String {
          switch self {
          case .quote:
              return "Цитата"
          case .allQuotes:
              return "Все цитаты"
          case .categories:
              return "Категории"
          }
    }
    
    func makeIcon() -> UIImage? {
        switch self {
        case .quote:
            return UIImage(systemName: "text.magnifyingglass")
        case .allQuotes:
            return UIImage(systemName: "text.quote")
        case .categories:
            return UIImage(systemName: "square.fill.text.grid.1x2")
        }
    }
}

class MainTabVC: UITabBarController {
    
    let fetchService = FetchService()
    let storageService = StorageService()
    
    private lazy var quoteVC = QuoteVC(sevice: fetchService, storageService: storageService)
    private lazy var allQuotesVC = AllQuotesVC(storageService: storageService)
    private var categoriesVC = CategoriesVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup() {
        tabBar.tintColor = .systemBlue
        let controllers = [UINavigationController(rootViewController: quoteVC), allQuotesVC, categoriesVC]
        self.viewControllers = controllers
        
        for (index, controller) in controllers.enumerated() {
            let page = TabBarPage.init(index: index)
            
            let tabItem = UITabBarItem.init(title: page?.makeTitle(), image: page?.makeIcon(), selectedImage: page?.makeIcon())
            controller.tabBarItem = tabItem
        }
    }
}
