var exec = require('cordova/exec');

function Przelewy24MobileSDK() {
	console.log("Przelewy24MobileSDK.js: is created");
}

Przelewy24MobileSDK.prototype.init = function(arg0, success, error) {
		// console.log('Przelewy24MobileSDK.init()');
    exec(success, error, "Przelewy24MobileSDK", "init", [arg0]);
};

Przelewy24MobileSDK.prototype.startPayment = function(configuration, payment, success, error) {
	// console.log('Przelewy24MobileSDK.startPayment()');
	
	this.init(configuration, () => this.onStartPaymentSuccess(payment, success, error), () => this.onStartPaymentError())
};

Przelewy24MobileSDK.prototype.onStartPaymentError = function() {
	alert('Nie udało się rozpocząć transakcji');
};

Przelewy24MobileSDK.prototype.onStartPaymentSuccess = function(payment, success, error) {
	// console.log('Przelewy24MobileSDK.onStartPaymentSuccess()');
	// console.log(payment);
	
	exec(success, error, "Przelewy24MobileSDK", "paymentStart", [payment]);
};

module.exports = new Przelewy24MobileSDK();