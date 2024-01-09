import SwiftUI
import PassKit

struct ContentView: View {
    @State private var isLoading = false // Assuming you have isLoading as a state variable

    let paymentHandler = PaymentHandler()

    // Assuming cardItems is an array of items
    let cardItems = [
        CardItem(name: "XXX", price: 10) // Replace with your hardcoded values
        // Add more items if needed
    ]

    var body: some View {
        VStack {
            if PKPaymentAuthorizationController.canMakePayments() {
                PayWithApplePayButton(action: {
                    self.isLoading = true
                    var paymentSummaryItems = [PKPaymentSummaryItem]()
                    for item in self.cardItems {
                        let summaryItem = PKPaymentSummaryItem(
                            label: item.name,
                            amount: NSDecimalNumber(decimal: item.price),
                            type: .final
                        )
                        paymentSummaryItems.append(summaryItem)
                    }

                    self.paymentHandler.startPayment(items: paymentSummaryItems) { result, 
                        
                        paymentDataJson in
                        if result {
                            print("ok")
                            self.isLoading = false
                        } else {
                            print("Something happened. Oops")
                            self.isLoading = false
                        }
                    }
                })
            } else {
                Text("Apple Pay is not available")
            }
        }
        .padding()
    }
}

// Sample struct to represent card items
struct CardItem {
    let name: String
    let price: Decimal
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
