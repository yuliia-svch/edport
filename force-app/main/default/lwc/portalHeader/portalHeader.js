import { LightningElement } from 'lwc';
import logoURL from '@salesforce/resourceUrl/Logo_big';
import { NavigationMixin } from 'lightning/navigation';

export default class PortalHeader extends NavigationMixin(LightningElement) {
    logoURL = logoURL;

    get menuLinks() {
        return [
            { label: 'Schedule', url: '/education/s' },
            { label: 'Courses', url: '/education/s' },
            { label: 'Grade List', url: '/education/s' }
        ];
    }

    navigateToHome() {
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				pageName: 'home'
			}
		});
	}

	logout() {
		const urlString = window.location.href;
		const baseUrl = urlString.substring(0, urlString.indexOf('/s'));
		const logoutUrl = baseUrl + '/secur/logout.jsp';
		window.open(logoutUrl, '_self');
	}
}