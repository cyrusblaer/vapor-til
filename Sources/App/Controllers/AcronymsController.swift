import Vapor
import Fluent

struct AcronymController: RouteCollection {
    
    func boot(router: Router) throws {
        let acronymsRoutes = router.grouped("api", "acronyms")
        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.post(Acronym.self, use: createHandler)
        acronymsRoutes.get(Acronym.parameter, use: getHandler)
        acronymsRoutes.put(Acronym.parameter, use: updateHandler)
        acronymsRoutes.delete(Acronym.parameter, use: deleteHandler)
        acronymsRoutes.get("search", use: searchHandler)
        acronymsRoutes.get("first", use: getFirstHandler)
        acronymsRoutes.get("sorted", use: sortedHandler)
        acronymsRoutes.get(Acronym.parameter, "user", use: getUserHandler)
    }
    
    func createHandler(_ req: Request, acronym: Acronym) throws -> Future<Acronym> {
        return acronym.save(on: req)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Acronym> {
        return try req.parameters.next(Acronym.self)
    }

    func updateHandler(_ req: Request) throws -> Future<Acronym> {
        return try flatMap(to: Acronym.self,
                           req.parameters.next(Acronym.self),
                           req.content.decode(Acronym.self)
        ) { acronym, updatedAcronym in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            acronym.userID = updatedAcronym.userID
            return acronym.save(on: req)
        }
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req
        .parameters
        .next(Acronym.self)
        .delete(on: req)
        .transform(to: HTTPStatus.noContent)
    }
    
    func searchHandler(_ req: Request) throws -> Future<[Acronym]> {
        guard let searchTerm = req.query[String.self, at: "trem"] else {
            throw Abort(.badRequest)
        }
        return Acronym.query(on: req).group(.or) { or in
            or.filter(\.short == searchTerm)
            or.filter(\.long == searchTerm)
            }.all()
    }
    
    func getFirstHandler(_ req: Request) throws -> Future<Acronym> {
        return Acronym.query(on: req)
        .first()
            .map(to: Acronym.self) { acronym in
                guard let acronym = acronym else {
                    throw Abort(.notFound)
                }
                return acronym
        }
    }
    
    func sortedHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).sort(\.short, .ascending).all()
    }
    
    func getUserHandler(_ req: Request) throws -> Future<User> {
        return try req
        .parameters.next(Acronym.self)
            .flatMap(to: User.self) { acronym in
            acronym.user.get(on: req)
        }
    }
    
}

