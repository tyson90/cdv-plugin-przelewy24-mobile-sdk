cordova.define("cdv-plugin-przelewy24-mobile-sdk.Przelewy24MobileSDK", function(require, exports, module) {
var exec = require('cordova/exec');

function Przelewy24MobileSDK() {
	console.log('Przelewy24MobileSDK.js: was created');
}

Przelewy24MobileSDK.prototype.startPayment = function(conf, payment, success, error) {
	console.log('Przelewy24MobileSDK.startPayment()');

	this.init(conf, () => this.onStartPaymentSuccess({ ...conf, ...payment}, success, error), () => this.onStartPaymentError());
};

Przelewy24MobileSDK.prototype.init = function(conf, success, error) {
		console.log('Przelewy24MobileSDK.init()');
  exec(success, error, "Przelewy24MobileSDK", "init", [conf]);
};

Przelewy24MobileSDK.prototype.onStartPaymentError = function() {
	alert('Nie udało się rozpocząć transakcji');
};

Przelewy24MobileSDK.prototype.onStartPaymentSuccess = function(payment, success, error) {
	console.log('Przelewy24MobileSDK.onStartPaymentSuccess()');
	// console.log(payment);

	exec(success, error, "Przelewy24MobileSDK", "startPayment", [payment]);
};

module.exports = new Przelewy24MobileSDK();

});
