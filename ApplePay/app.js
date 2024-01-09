document.addEventListener("DOMContentLoaded", function() {
    const paymentHandler = new PaymentHandler();
    
    const cardItems = [
        { name: "XXX", price: 10 }, // Replace with your hardcoded values
        // Add more items if needed
    ];

    const paymentButton = document.getElementById("paymentButton");
    const paymentStatus = document.getElementById("paymentStatus");

    if (window.ApplePaySession && PaymentHandler.canMakePayments()) {
        const button = document.createElement("button");
        button.textContent = "Pay with Apple Pay";
        button.addEventListener("click", function() {
            paymentStatus.textContent = "Processing...";
            const paymentSummaryItems = cardItems.map(item => {
                return {
                    label: item.name,
                    amount: item.price.toFixed(2), // Assuming price is in decimal
                };
            });

            paymentHandler.startPayment(paymentSummaryItems, function(result, paymentDataJson) {
                if (result) {
                    paymentStatus.textContent = "Payment successful";
                    console.log("ok");
                } else {
                    paymentStatus.textContent = "Something happened. Oops";
                    console.log("Something happened. Oops");
                }
            });
        });

        paymentButton.appendChild(button);
    } else {
        paymentButton.textContent = "Apple Pay is not available";
    }
});
