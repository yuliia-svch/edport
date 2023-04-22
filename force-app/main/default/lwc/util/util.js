import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const TOAST_VARIANTS = {
	INFO: 'info',
	SUCCESS: 'success',
	ERROR: 'error'
};

class Util {
	static TOAST_VARIANTS = TOAST_VARIANTS;

	static showToast(component, message, variant) {
		variant = variant || TOAST_VARIANTS.SUCCESS;
		component.dispatchEvent(
			new ShowToastEvent({ message, variant })
		);
	}

	static parseError(error) {
		if (typeof error === 'string') {
			return error;
		}
		if (Array.isArray(error) && error.length) {
			error = error[0];
		}
		if (error.body && error.body.message) {
			return error.body.message;
		} else if (error.message) {
			return error.message;
		} else {
			return 'Unknown error occurred';
		}
	}
}

export { Util }