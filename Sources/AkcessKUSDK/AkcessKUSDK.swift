import Foundation
public struct AkcessKUSDK {
    private let BASE_URL = "https://edu-ku-kw.akcess.app"
    private let API = "/api"
    private let FIND_BY_EMAIL_OR_PHONE = "/findbyemailorphone'"
    private let ID_BY_AKCESS_ID = "/idbyakcessid'"
    private let DOCUMENT_LIST = "/getdocumentlist'"
    private let CERTIFICATE_LIST = "/certicatebyid'"
    private let COUNTRY_LIST = "/getallcountry"
    private let ADD_STUDENTS = "/adduser"
    private let NOTIFICATION_LIST = "/getpushnotificationslist"
    private let REQUEST_CERTIFICATE = "/certificate"
    public init() {
    }
    public func requestCertificate(
        akcessId: String,
        certificateTypeId: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let urlString = "\(BASE_URL)\(API)\(REQUEST_CERTIFICATE)"
        
        let body: [String: Any] = [
            "akcessId": akcessId,
            "certificate_type": certificateTypeId
        ]
        
        postRequest(urlString: urlString, bodyParams: body, completion: completion)
    }
    public func getNotificationList(
        akcessId: String,
        countryCode: String,
        email: String,
        mobile: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let urlString = "\(BASE_URL)\(API)\(NOTIFICATION_LIST)"
        
        let body: [String: Any] = [
            "akcessId": akcessId,
            "country_code": countryCode,
            "email": email,
            "mobile": mobile
        ]
        
        postRequest(urlString: urlString, bodyParams: body, completion: completion)
    }
    
    public func addStudent(
        firstName: String,
        lastName: String,
        nationality: String,
        email: String,
        mobile: String,
        city: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let urlString = "\(BASE_URL)\(API)\(ADD_STUDENTS)"
        let body: [String: Any] = [
            "firstname": firstName,
            "lastname": lastName,
            "country_id": nationality,
            "email": email,
            "mobileNumber": mobile,
            "city": city
        ]

        postRequest(urlString: urlString, bodyParams: body, completion: completion)
    }
    public func getCertificateList(
        akcessId: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let urlString = "\(BASE_URL)\(API)\(CERTIFICATE_LIST)"
        let body = ["akcessId": akcessId]

        postRequest(urlString: urlString, bodyParams: body, completion: completion)
    }
    public func getAllCountries(
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let urlString = "\(BASE_URL)\(API)\(COUNTRY_LIST)"
        getRequest(urlString: urlString, queryParams: nil, completion: completion)
    }
    public func getDocumentList(
        akcessId: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let urlString = "\(BASE_URL)\(API)\(DOCUMENT_LIST)"
        let body = ["akcessId": akcessId]

        postRequest(urlString: urlString, bodyParams: body, completion: completion)
    }
    public func getStudentIDByAkcessId(
        akcessId: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let urlString = "\(BASE_URL)\(API)\(ID_BY_AKCESS_ID)"
        let body = ["akcessId": akcessId]

        postRequest(urlString: urlString, bodyParams: body, completion: completion)
    }
    
    public func findByEmailOrPhone(
        email: String? = nil,
        phone: String? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        var params: [String: String] = [:]
        if let email = email { params["email"] = email }
        if let phone = phone { params["phone"] = phone }

        let fullURL = "\(BASE_URL)\(API)\(FIND_BY_EMAIL_OR_PHONE)"
        
        getRequest(urlString: fullURL, queryParams: params, completion: completion)
    }
    
    // MARK: - GET Request
       public func getRequest(
           urlString: String,
           queryParams: [String: String]? = nil,
           completion: @escaping (Result<Data, Error>) -> Void
       ) {
           var components = URLComponents(string: urlString)!
           if let params = queryParams {
               components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
           }

           guard let url = components.url else {
               completion(.failure(NSError(domain: "Invalid URL", code: 0)))
               return
           }

           let task = URLSession.shared.dataTask(with: url) { data, _, error in
               if let err = error {
                   completion(.failure(err))
               } else if let data = data {
                   completion(.success(data))
               } else {
                   completion(.failure(NSError(domain: "Unknown error", code: 0)))
               }
           }
           task.resume()
       }

       // MARK: - POST Request
       public func postRequest(
           urlString: String,
           bodyParams: [String: Any],
           completion: @escaping (Result<Data, Error>) -> Void
       ) {
           guard let url = URL(string: urlString) else {
               completion(.failure(NSError(domain: "Invalid URL", code: 0)))
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         
           request.setValue("*/*", forHTTPHeaderField: "Accept")

           do {
               let jsonData = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
               request.httpBody = jsonData
           } catch {
               completion(.failure(error))
               return
           }

           let task = URLSession.shared.dataTask(with: request) { data, _, error in
               if let err = error {
                   completion(.failure(err))
               } else if let data = data {
                   completion(.success(data))
               } else {
                   completion(.failure(NSError(domain: "Unknown error", code: 0)))
               }
           }
           task.resume()
       }
}
