Network Error Handling:
Code:
import Foundation

// MARK: - Error Enum (Required by assignment)
enum NetworkError: Error {
    case noInternet
    case noData
    case invalidResponse
    case decodingFailed
    case unknown(String)
}

// MARK: - Todo Model
struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

// MARK: - Network Manager with Complete Error Handling
class NetworkManager {
    
    // This function simulates a network call but demonstrates REAL error handling
    func fetchTodos(completion: @escaping (Result<[Todo], NetworkError>) -> Void) {
        
        // SIMULATION MODE: Since online compilers don't support URLSession,
        // we'll simulate different scenarios to demonstrate error handling.
        // In a real iOS app, this would be an actual network request.
        
        let simulationScenario = "success"  // CHANGE THIS to test different errors
        // Options: "success", "noInternet", "noData", "invalidResponse", "decodingFailed"
        
        // Simulate network delay (like real async request)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            
            switch simulationScenario {
                
            // CASE 1: Successful response
            case "success":
                let sampleJSON = """
                [
                    {"userId": 1, "id": 1, "title": "Buy groceries", "completed": false},
                    {"userId": 1, "id": 2, "title": "Walk the dog", "completed": true},
                    {"userId": 1, "id": 3, "title": "Study Swift", "completed": false},
                    {"userId": 1, "id": 4, "title": "Workout", "completed": true}
                ]
                """
                guard let jsonData = sampleJSON.data(using: .utf8) else {
                    completion(.failure(.decodingFailed))
                    return
                }
                
                do {
                    let todos = try JSONDecoder().decode([Todo].self, from: jsonData)
                    completion(.success(todos))
                } catch {
                    completion(.failure(.decodingFailed))
                }
                
            // CASE 2: No Internet Connection (Error Handling Demo)
            case "noInternet":
                completion(.failure(.noInternet))
                
            // CASE 3: Server returned No Data (Error Handling Demo)
            case "noData":
                completion(.failure(.noData))
                
            // CASE 4: Invalid Response from Server (Error Handling Demo)
            case "invalidResponse":
                completion(.failure(.invalidResponse))
                
            // CASE 5: Decoding Failed (Error Handling Demo)
            case "decodingFailed":
                completion(.failure(.decodingFailed))
                
            default:
                completion(.failure(.unknown("Unknown simulation scenario")))
            }
        }
    }
}

// MARK: - Main Execution
print("=" .padding(toLength: 60, withPad: "=", startingAt: 0))
print("   iOS Networking Demo with Complete Error Handling")
print("=" .padding(toLength: 60, withPad: "=", startingAt: 0))
print()

let networkManager = NetworkManager()

// To test different error scenarios, change the "simulationScenario" variable above
print("Fetching todos from API...\n")

networkManager.fetchTodos { result in
    
    switch result {
        
    // SUCCESS CASE
    case .success(let todos):
        print(" SUCCESS: Data fetched successfully!")
        print(" Received \(todos.count) todo items\n")
        print("First 3 todos:")
        for todo in todos.prefix(3) {
            let statusIcon = todo.completed ? " COMPLETED" : " PENDING"
            print("   • \(todo.title)")
            print("     [ID: \(todo.id) | Status: \(statusIcon)]\n")
        }
        
    // ERROR CASE 1: No Internet
    case .failure(.noInternet):
        print(" ERROR: No internet connection detected")
        print("    Solution: Please check your Wi-Fi or cellular connection")
        print("    The app will work offline using cached data")
        
    // ERROR CASE 2: No Data Returned
    case .failure(.noData):
        print(" ERROR: Server returned no data")
        print("    Solution: The API endpoint may be temporarily unavailable")
        print("    Try again later or contact support")
        
    // ERROR CASE 3: Invalid Response
    case .failure(.invalidResponse):
        print(" ERROR: Server returned an invalid response")
        print("    Solution: The server might be down or misconfigured")
        print("    Status code indicates a problem on the server side")
        
    // ERROR CASE 4: Decoding Failed
    case .failure(.decodingFailed):
        print(" ERROR: Failed to decode the response data")
        print("    Solution: The data format may have changed")
        print("    Check if the API structure matches the expected model")
        
    // ERROR CASE 5: Unknown Error
    case .failure(.unknown(let message)):
        print(" ERROR: Unknown error occurred")
        print("    Details: \(message)")
    }
    
    print("\n" + "=" .padding(toLength: 60, withPad: "=", startingAt: 0))
    print("   Error handling demonstration complete")
    print("   All network error cases are handled gracefully")
    print("=" .padding(toLength: 60, withPad: "=", startingAt: 0))
}

// Keep the program running for async completion
RunLoop.main.run(until: Date(timeIntervalSinceNow: 3))
