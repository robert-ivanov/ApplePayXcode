import Foundation
import PassKit
import UIKit

typealias PaymentCompletionHandler = (Bool, [String: Any]?) -> Void

class PaymentHandler: NSObject {
    var paymentController: PKPaymentAuthorizationController? // Remove redundant PKPaymentAuthorizationViewController declaration
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var paymentDataJson: [String: Any]?
    var completionHandler: PaymentCompletionHandler?

    func startPayment(items: [PKPaymentSummaryItem], completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion

        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = items
        paymentRequest.merchantIdentifier = "merchant.com.digitain.paydrom"
        paymentRequest.merchantCapabilities = .threeDSecure // Replace with correct capability
        paymentRequest.countryCode = "US" // Changed from couponCode
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = [.amex, .visa, .masterCard, .mada]

        let paymentAuthorizationController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentAuthorizationController.delegate = self
        paymentController = paymentAuthorizationController // Assigning the created controller

        paymentAuthorizationController.present(completion: { presented in
            if presented {
                print("Presented payment controller")
            } else {
                print("Failed to present")
                self.completionHandler?(false, nil)
            }
        })
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.paymentStatus = .success
        do {
            if let json = try JSONSerialization.jsonObject(with: payment.token.paymentData) as? [String: Any] {
                self.paymentDataJson = json
                print(payment.token.paymentMethod)
                print("Token JSON: \(json)")
                print("Payment Data: \("ROB")")
                print("Callto Back en , response from them")
                completion(PKPaymentAuthorizationResult(status: .success, errors: [])) // Corrected errors array
            }
        } catch let error as NSError {
            print("failed to load: \(error.localizedDescription)")
            completion(PKPaymentAuthorizationResult(status: .failure, errors: [])) // Corrected errors array and failure status
        }
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler?(true, self.paymentDataJson)
                    print("Success")
                } else {
                    self.completionHandler?(false, nil)
                    print("Nah")
                }
            }
        }
    }
}
