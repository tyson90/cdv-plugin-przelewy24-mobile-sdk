var exec = require('cordova/exec');

function Przelewy24MobileSDK() {
	console.log('Przelewy24MobileSDK.js: is created');
}

Przelewy24MobileSDK.prototype.startPayment = function(conf, payment, success, error) {
	console.log('Przelewy24MobileSDK.startPayment()');

	// this.init(conf, () => this.onStartPaymentSuccess(payment, success, error), () => this.onStartPaymentError())
	exec(success, error, 'Przelewy24MobileSDK', 'startTrnDirect', [{ ...conf, ...payment}]);
};

// TODO: remove it
// Przelewy24MobileSDK.prototype.init = function(arg0, success, error) {
// 		// console.log('Przelewy24MobileSDK.init()');
//     exec(success, error, "Przelewy24MobileSDK", "init", [arg0]);
// };

// TODO: remove it
// Przelewy24MobileSDK.prototype.onStartPaymentError = function() {
// 	alert('Nie udało się rozpocząć transakcji');
// };

// TODO: remove it
// Przelewy24MobileSDK.prototype.onStartPaymentSuccess = function(payment, success, error) {
// 	// console.log('Przelewy24MobileSDK.onStartPaymentSuccess()');
// 	// console.log(payment);
//
// 	exec(success, error, "Przelewy24MobileSDK", "paymentStart", [payment]);
// };

module.exports = new Przelewy24MobileSDK();
