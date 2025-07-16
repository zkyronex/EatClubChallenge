import UIKit
import Combine

protocol Routable: AnyObject {

    var finish: AnyPublisher<Void, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

class Router: NSObject {

    private(set) var childRouters: [Routable] = []
    private var cancellables = Set<AnyCancellable>()

    func add(child router: Routable) {
        childRouters.append(router)

        router.finish
            .sink(receiveValue: { [weak self, weak router] _ in
                self?.childRouters.removeAll { $0 === router }
            })
            .store(in: &router.cancellables)
    }
}
