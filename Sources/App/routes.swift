import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
//    router.get("api", "acronyms") { req -> Future<[Acronym]> in
//        return Acronym.query(on: req).all()
//    }
    
//    router.get("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
//        return try req.parameters.next(Acronym.self)
//    }
//
//    router.put("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
//        return try flatMap(to: Acronym.self, req.parameters.next(Acronym.self), req.content.decode(Acronym.self), { acronyms, updateAcronym in
//            acronyms.short = updateAcronym.short
//            acronyms.long = updateAcronym.long
//
//            return acronyms.save(on: req)
//        })
//    }
//
//    router.delete("api", "acronyms", Acronym.parameter) { req -> Future<HTTPStatus> in
//        return try req.parameters.next(Acronym.self)
//                    .delete(on: req)
//                    .transform(to: HTTPStatus.noContent)
//    }
//
//    router.get("api", "acronyms", "search") { req -> Future<[Acronym]> in
//        guard let searchTerm = req.query[String.self, at: "term"] else {
//            throw Abort(.badRequest)
//        }
//
//        return Acronym.query(on: req)
//            .group(.or) { or in
//            or.filter(\.short == searchTerm)
//            or.filter(\.long == searchTerm)
//        }.all()
//    }
//
//    router.get("api", "acronyms", "first") { req -> Future<Acronym> in
//        return Acronym.query(on: req)
//            .first()
//            .map(to: Acronym.self) { acronym in
//                guard let acronym = acronym else {
//                    throw Abort(.notFound)
//                }
//                return acronym
//            }
//    }
//
//    router.get("api", "acronyms", "sorted") { req -> Future<[Acronym]> in
//        return Acronym.query(on: req)
//        .sort(\.short, .ascending)
//        .all()
//    }
    
    let acronymsController = AcronymController()
    try router.register(collection: acronymsController)
    
    let usersController = UsersController()
    try router.register(collection: usersController)
    
    let categoriesController = CategoriesController()
    try router.register(collection: categoriesController)
    
    let websiteController = WebsiteController()
    try router.register(collection: websiteController)
    
    let imperialController = ImperialController()
    try router.register(collection: imperialController)
}
